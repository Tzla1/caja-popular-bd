-- ============================================================
--  Caja Popular - Logica de REGLAS (Oracle PL/SQL)
--  Se crea ANTES de cargar datos (valida durante la carga,
--  igual que el original PostgreSQL). NO toca saldos.
-- ============================================================

-- Paquete con variable de sesion (equivale a caja.ledger de PostgreSQL)
CREATE OR REPLACE PACKAGE pkg_caja AS
    g_ledger VARCHAR2(3);
END pkg_caja;
/

-- ------------------------------------------------------------
-- socios: edad >= 19, aporte >= 3000, y saldado por defuncion
-- (solo lee :NEW / actualiza prestamos -> sin tabla mutante)
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_socios_biu
BEFORE INSERT OR UPDATE ON socios
FOR EACH ROW
BEGIN
    IF :NEW.fecha_nacimiento > ADD_MONTHS(TRUNC(SYSDATE), -19*12) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El socio debe tener 19 anios o mas cumplidos');
    END IF;
    IF :NEW.aporte_inicial < 3000 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El aporte inicial minimo para abrir cuenta es de 3000.00');
    END IF;

    IF UPDATING AND :NEW.fecha_defuncion IS NOT NULL
       AND (:OLD.fecha_defuncion IS NULL OR :OLD.fecha_defuncion <> :NEW.fecha_defuncion) THEN
        UPDATE prestamos
           SET estado = 'saldado_defuncion',
               saldo_pendiente = 0,
               motivo_cancelacion = 'Defuncion del socio'
         WHERE socio_id = :NEW.id
           AND estado IN ('activo','solicitado');
        :NEW.estado := 'fallecido';
    END IF;
END;
/

-- ------------------------------------------------------------
-- prestamos: COMPOUND TRIGGER (evita ORA-04091 tabla mutante)
--   * BEFORE ROW  -> monto <= 2x saldo de la cuenta
--   * AFTER STMT  -> maximo 2 prestamos activos/solicitados
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_prestamos_comp
FOR INSERT OR UPDATE ON prestamos
COMPOUND TRIGGER
    TYPE t_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    g_socios t_ids;
    g_n      PLS_INTEGER := 0;

    BEFORE EACH ROW IS
        v_saldo NUMBER;
    BEGIN
        IF INSERTING OR (:OLD.monto_original <> :NEW.monto_original) THEN
            BEGIN
                SELECT saldo INTO v_saldo
                  FROM cuentas_ahorro WHERE socio_id = :NEW.socio_id;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20010, 'El socio no tiene cuenta de ahorro registrada');
            END;
            IF :NEW.monto_original > v_saldo * 2 THEN
                RAISE_APPLICATION_ERROR(-20011, 'El monto solicitado excede 2 veces el saldo de la cuenta');
            END IF;
        END IF;
        IF :NEW.estado IN ('activo','solicitado') THEN
            g_n := g_n + 1;
            g_socios(g_n) := :NEW.socio_id;
        END IF;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
        v_cnt NUMBER;
    BEGIN
        FOR i IN 1 .. g_n LOOP
            SELECT COUNT(*) INTO v_cnt
              FROM prestamos
             WHERE socio_id = g_socios(i)
               AND estado IN ('activo','solicitado');
            IF v_cnt > 2 THEN
                RAISE_APPLICATION_ERROR(-20012, 'El socio ya tiene 2 prestamos activos o solicitados (maximo permitido)');
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END trg_prestamos_comp;
/

-- ------------------------------------------------------------
-- beneficiarios: COMPOUND TRIGGER (evita tabla mutante)
--   max 4 por socio, suma <= 100, y marca beneficiarios_completos
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_benef_comp
FOR INSERT OR UPDATE OR DELETE ON beneficiarios
COMPOUND TRIGGER
    TYPE t_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    g_socios t_ids;
    g_n      PLS_INTEGER := 0;

    AFTER EACH ROW IS
    BEGIN
        g_n := g_n + 1;
        IF DELETING THEN
            g_socios(g_n) := :OLD.socio_id;
        ELSE
            g_socios(g_n) := :NEW.socio_id;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_count NUMBER;
        v_suma  NUMBER;
    BEGIN
        FOR i IN 1 .. g_n LOOP
            SELECT COUNT(*), NVL(SUM(porcentaje),0)
              INTO v_count, v_suma
              FROM beneficiarios WHERE socio_id = g_socios(i);
            IF v_count > 4 THEN
                RAISE_APPLICATION_ERROR(-20020, 'Un socio no puede tener mas de 4 beneficiarios');
            END IF;
            IF v_suma > 100 THEN
                RAISE_APPLICATION_ERROR(-20021, 'La suma de porcentajes de beneficiarios no puede exceder 100');
            END IF;
            UPDATE socios
               SET beneficiarios_completos =
                   CASE WHEN v_count BETWEEN 1 AND 4 AND v_suma = 100 THEN 1 ELSE 0 END
             WHERE id = g_socios(i);
        END LOOP;
    END AFTER STATEMENT;
END trg_benef_comp;
/

-- ------------------------------------------------------------
-- VISTAS
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_socios_elegibles_prestamo AS
SELECT s.id, s.nombre, s.apellidos, ca.saldo,
       LEAST(ca.saldo * 2, 50000.00) AS monto_maximo_prestable
  FROM socios s
  JOIN cuentas_ahorro ca ON ca.socio_id = s.id
 WHERE s.estado = 'activo'
   AND s.fecha_defuncion IS NULL
   AND s.fecha_alta <= ADD_MONTHS(TRUNC(SYSDATE), -6)
   AND ca.saldo >= 3000.00
   AND NOT EXISTS (
        SELECT 1 FROM prestamos p
         WHERE p.socio_id = s.id
           AND p.estado IN ('activo','solicitado'));

CREATE OR REPLACE VIEW v_prestamos_en_mora AS
SELECT p.id, p.socio_id, s.nombre, s.apellidos,
       p.monto_original, p.saldo_pendiente,
       p.fecha_limite_pago,
       (TRUNC(SYSDATE) - p.fecha_limite_pago) AS dias_mora
  FROM prestamos p
  JOIN socios s ON s.id = p.socio_id
 WHERE p.estado = 'activo'
   AND p.fecha_limite_pago < TRUNC(SYSDATE);

CREATE OR REPLACE VIEW v_resumen_socios AS
SELECT s.id, s.nombre, s.apellidos, s.estado, s.fecha_alta,
       ca.saldo AS saldo_cuenta,
       (SELECT COUNT(*) FROM prestamos p
         WHERE p.socio_id = s.id AND p.estado = 'activo') AS prestamos_activos,
       (SELECT NVL(SUM(porcentaje),0) FROM beneficiarios b
         WHERE b.socio_id = s.id) AS suma_beneficiarios
  FROM socios s
  LEFT JOIN cuentas_ahorro ca ON ca.socio_id = s.id;
