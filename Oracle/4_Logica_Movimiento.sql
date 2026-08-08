-- ============================================================
--  Caja Popular - Logica de MOVIMIENTO (Oracle PL/SQL)
--  Se crea DESPUES de cargar los datos, para que los saldos
--  semilla NO se recalculen (identico al original PostgreSQL).
-- ============================================================

-- ------------------------------------------------------------
-- aplicar_transaccion: valida y ajusta saldo/prestamo por cada
-- transaccion nueva. Activa el "ledger" para permitir el UPDATE
-- de saldo que de otro modo bloquea trg_proteger_saldo.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_aplicar_transaccion
BEFORE INSERT ON transacciones
FOR EACH ROW
DECLARE
    v_socio_cuenta   NUMBER;
    v_socio_prestamo NUMBER;
    v_saldo          NUMBER;
BEGIN
    pkg_caja.g_ledger := 'on';

    IF :NEW.prestamo_id IS NOT NULL THEN
        SELECT socio_id INTO v_socio_cuenta   FROM cuentas_ahorro WHERE id = :NEW.cuenta_id;
        SELECT socio_id INTO v_socio_prestamo FROM prestamos      WHERE id = :NEW.prestamo_id;
        IF v_socio_cuenta <> v_socio_prestamo THEN
            RAISE_APPLICATION_ERROR(-20030, 'La cuenta y el prestamo no pertenecen al mismo socio');
        END IF;
    END IF;

    IF :NEW.tipo IN ('abono_prestamo','penalizacion','desembolso_prestamo')
       AND :NEW.prestamo_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20031, 'La transaccion requiere prestamo_id');
    END IF;

    IF :NEW.tipo IN ('deposito','interes_ahorro')
       AND (:NEW.monto < 100 OR :NEW.monto > 10000) THEN
        RAISE_APPLICATION_ERROR(-20032, 'Monto fuera de rango 100-10000');
    END IF;

    IF :NEW.tipo IN ('deposito','interes_ahorro','apertura','desembolso_prestamo') THEN
        UPDATE cuentas_ahorro SET saldo = saldo + :NEW.monto WHERE id = :NEW.cuenta_id;
    ELSIF :NEW.tipo = 'retiro' THEN
        SELECT saldo INTO v_saldo FROM cuentas_ahorro WHERE id = :NEW.cuenta_id FOR UPDATE;
        IF :NEW.monto > v_saldo THEN
            RAISE_APPLICATION_ERROR(-20033, 'Fondos insuficientes para el retiro');
        END IF;
        UPDATE cuentas_ahorro SET saldo = saldo - :NEW.monto WHERE id = :NEW.cuenta_id;
    ELSIF :NEW.tipo = 'abono_prestamo' THEN
        UPDATE prestamos SET saldo_pendiente = saldo_pendiente - :NEW.monto WHERE id = :NEW.prestamo_id;
    ELSIF :NEW.tipo = 'penalizacion' THEN
        UPDATE prestamos SET saldo_pendiente = saldo_pendiente + :NEW.monto WHERE id = :NEW.prestamo_id;
    END IF;

    pkg_caja.g_ledger := NULL;
END;
/

-- ------------------------------------------------------------
-- proteger_saldo: impide modificar saldo directamente (solo via
-- transacciones, cuando el ledger esta activo).
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_proteger_saldo
BEFORE UPDATE OF saldo ON cuentas_ahorro
FOR EACH ROW
BEGIN
    IF :NEW.saldo <> :OLD.saldo
       AND (pkg_caja.g_ledger IS NULL OR pkg_caja.g_ledger <> 'on') THEN
        RAISE_APPLICATION_ERROR(-20040, 'El saldo solo puede modificarse via transacciones');
    END IF;
END;
/
