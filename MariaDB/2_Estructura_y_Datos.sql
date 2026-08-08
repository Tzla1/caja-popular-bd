-- ============================================================
--  Caja Popular - Estructura, restricciones, logica y datos
--  MariaDB 10.2+ / 12.x  (motor InnoDB, utf8mb4)
--  Traduccion fiel del esquema PostgreSQL original.
-- ============================================================

USE `BD_Jesdreel_Daniel_Mata_Gomez`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- 1. TABLAS
-- ------------------------------------------------------------

CREATE TABLE sucursales (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    direccion TEXT         NOT NULL,
    es_matriz BOOLEAN      NOT NULL DEFAULT FALSE
) ENGINE=InnoDB COMMENT='Sucursales fisicas de la Caja Popular';

CREATE TABLE empleados (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    apellidos     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol           VARCHAR(20)  NOT NULL,
    sucursal_id   INT          NOT NULL,
    activo        BOOLEAN      NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_empleado_sucursal FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    CONSTRAINT chk_empleado_rol CHECK (rol IN ('admin','cajero','gerente'))
) ENGINE=InnoDB COMMENT='Personal autorizado (cajero, admin, gerente)';

CREATE TABLE socios (
    id                      INT AUTO_INCREMENT PRIMARY KEY,
    nombre                  VARCHAR(100) NOT NULL,
    apellidos               VARCHAR(100) NOT NULL,
    fecha_nacimiento        DATE         NOT NULL,
    curp                    VARCHAR(18)  NOT NULL UNIQUE,
    rfc                     VARCHAR(13)  NOT NULL UNIQUE,
    email                   VARCHAR(150) UNIQUE,
    telefono                VARCHAR(15),
    fecha_alta              DATE         NOT NULL DEFAULT (CURDATE()),
    sucursal_id             INT          NOT NULL,
    estado                  VARCHAR(20)  NOT NULL DEFAULT 'activo',
    beneficiarios_completos BOOLEAN      NOT NULL DEFAULT FALSE,
    fecha_defuncion         DATE,
    aporte_inicial          DECIMAL(12,2) NOT NULL DEFAULT 3000.00,
    CONSTRAINT fk_socio_sucursal FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    CONSTRAINT chk_socio_estado CHECK (estado IN ('activo','inactivo','suspendido','fallecido')),
    CONSTRAINT chk_socio_aporte CHECK (aporte_inicial >= 3000.00),
    CONSTRAINT chk_socio_curp_largo CHECK (CHAR_LENGTH(curp) = 18),
    CONSTRAINT chk_socio_rfc_largo  CHECK (CHAR_LENGTH(rfc) BETWEEN 12 AND 13),
    CONSTRAINT chk_socio_curp_formato CHECK (curp REGEXP '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z][0-9]$'),
    CONSTRAINT chk_socio_rfc_formato  CHECK (rfc REGEXP '^[A-ZÑ&]{3,4}[0-9]{6}[0-9A-Z]{3}$'),
    CONSTRAINT chk_socio_email_formato CHECK (email IS NULL OR email REGEXP '^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$')
) ENGINE=InnoDB COMMENT='Personas afiliadas a la Caja Popular';

CREATE TABLE documentos_socio (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    socio_id      INT          NOT NULL,
    tipo          VARCHAR(50)  NOT NULL,
    fecha_entrega DATE         NOT NULL DEFAULT (CURDATE()),
    verificado    BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_documento_socio FOREIGN KEY (socio_id) REFERENCES socios(id) ON DELETE CASCADE,
    CONSTRAINT chk_tipo_documento CHECK (tipo IN (
        'INE','CURP','RFC','COMPROBANTE_DOMICILIO','ACTA_NACIMIENTO',
        'CARTA_POLICIA','CONSENTIMIENTO_DATOS','SOLICITUD'
    )),
    CONSTRAINT uq_documento_por_socio UNIQUE (socio_id, tipo)
) ENGINE=InnoDB COMMENT='Documentos entregados por cada socio';

CREATE TABLE beneficiarios (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    socio_id              INT          NOT NULL,
    nombre                VARCHAR(100) NOT NULL,
    apellidos             VARCHAR(100) NOT NULL,
    porcentaje            DECIMAL(5,2) NOT NULL,
    es_socio              BOOLEAN      NOT NULL DEFAULT FALSE,
    socio_beneficiario_id INT,
    CONSTRAINT fk_beneficiario_socio FOREIGN KEY (socio_id) REFERENCES socios(id) ON DELETE CASCADE,
    CONSTRAINT fk_beneficiario_socio_ben FOREIGN KEY (socio_beneficiario_id) REFERENCES socios(id),
    CONSTRAINT chk_beneficiario_porcentaje CHECK (porcentaje > 0 AND porcentaje <= 100)
) ENGINE=InnoDB COMMENT='Beneficiarios designados por el socio (max 4, suma 100%)';

CREATE TABLE cuentas_ahorro (
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    socio_id             INT           NOT NULL UNIQUE,
    saldo                DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    fecha_apertura       DATE          NOT NULL DEFAULT (CURDATE()),
    ultimo_deposito_mes  DATE,
    estado               VARCHAR(20)   NOT NULL DEFAULT 'activa',
    tasa_interes_mensual DECIMAL(5,4)  NOT NULL DEFAULT 0.2000,
    CONSTRAINT fk_cuenta_socio FOREIGN KEY (socio_id) REFERENCES socios(id),
    CONSTRAINT chk_cuenta_estado CHECK (estado IN ('activa','suspendida','cerrada')),
    CONSTRAINT chk_saldo_no_negativo CHECK (saldo >= 0),
    CONSTRAINT chk_tasa_ahorro CHECK (tasa_interes_mensual = 0.2000)
) ENGINE=InnoDB COMMENT='Cuenta unica de ahorro por socio (interes 20% mensual)';

CREATE TABLE prestamos (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    socio_id           INT           NOT NULL,
    monto_original     DECIMAL(12,2) NOT NULL,
    saldo_pendiente    DECIMAL(12,2) NOT NULL,
    tasa_interes       DECIMAL(5,4)  NOT NULL DEFAULT 0.0500,
    fecha_solicitud    DATE          NOT NULL DEFAULT (CURDATE()),
    fecha_aprobacion   DATE,
    estado             VARCHAR(20)   NOT NULL DEFAULT 'solicitado',
    fecha_limite_pago  DATE,
    dias_atraso        INT           NOT NULL DEFAULT 0,
    penalizacion_pct   DECIMAL(5,4)  NOT NULL DEFAULT 0.4000,
    monto_penalizacion DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    motivo_cancelacion VARCHAR(100),
    CONSTRAINT fk_prestamo_socio FOREIGN KEY (socio_id) REFERENCES socios(id),
    CONSTRAINT chk_prestamo_estado CHECK (estado IN ('solicitado','activo','pagado','cancelado','saldado_defuncion')),
    CONSTRAINT chk_prestamo_monto_positivo CHECK (monto_original > 0),
    CONSTRAINT chk_prestamo_monto_max CHECK (monto_original <= 50000.00),
    CONSTRAINT chk_prestamo_saldo CHECK (saldo_pendiente >= 0),
    CONSTRAINT chk_prestamo_saldo_menor_original CHECK (saldo_pendiente <= monto_original),
    CONSTRAINT chk_prestamo_tasa CHECK (tasa_interes = 0.0500),
    CONSTRAINT chk_penalizacion_pct CHECK (penalizacion_pct = 0.4000)
) ENGINE=InnoDB COMMENT='Prestamos otorgados (tope 50000, 2x saldo, max 2 activos)';

CREATE TABLE transacciones (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    cuenta_id   INT           NOT NULL,
    prestamo_id INT,
    tipo        VARCHAR(30)   NOT NULL,
    monto       DECIMAL(12,2) NOT NULL,
    metodo_pago VARCHAR(30)   NOT NULL,
    fecha       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(255),
    empleado_id INT,
    CONSTRAINT fk_trans_cuenta   FOREIGN KEY (cuenta_id)   REFERENCES cuentas_ahorro(id),
    CONSTRAINT fk_trans_prestamo FOREIGN KEY (prestamo_id) REFERENCES prestamos(id),
    CONSTRAINT fk_trans_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    CONSTRAINT chk_transaccion_tipo CHECK (tipo IN (
        'deposito','retiro','interes_ahorro','abono_prestamo',
        'desembolso_prestamo','penalizacion','apertura'
    )),
    CONSTRAINT chk_transaccion_metodo CHECK (metodo_pago IN (
        'SPEI','EFECTIVO','DEBITO_VISA','DEBITO_MASTERCARD','DEBITO_CARNET',
        'CREDITO_VISA','CREDITO_MASTERCARD','CREDITO_CARNET'
    )),
    CONSTRAINT chk_transaccion_monto CHECK (monto > 0),
    CONSTRAINT chk_transaccion_deposito_min_max CHECK (
        tipo <> 'deposito' OR (monto >= 100.00 AND monto <= 10000.00)
    )
) ENGINE=InnoDB COMMENT='Movimientos monetarios (deposito, retiro, abono, etc)';

CREATE TABLE abonos_prestamo (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    prestamo_id         INT           NOT NULL,
    mes_correspondiente DATE          NOT NULL,
    monto_capital       DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    monto_interes       DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    monto_penalizacion  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    fecha_pago          DATE          NOT NULL DEFAULT (CURDATE()),
    en_tiempo           BOOLEAN       NOT NULL,
    transaccion_id      INT,
    CONSTRAINT fk_abono_prestamo    FOREIGN KEY (prestamo_id)    REFERENCES prestamos(id),
    CONSTRAINT fk_abono_transaccion FOREIGN KEY (transaccion_id) REFERENCES transacciones(id),
    CONSTRAINT chk_abono_montos_positivos CHECK (
        monto_capital >= 0 AND monto_interes >= 0 AND monto_penalizacion >= 0
    ),
    CONSTRAINT uq_abono_prestamo_mes UNIQUE (prestamo_id, mes_correspondiente)
) ENGINE=InnoDB COMMENT='Registro de abonos mensuales a prestamos';

CREATE TABLE capital_caja (
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    monto                DECIMAL(14,2) NOT NULL,
    ultima_actualizacion TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_capital_no_negativo CHECK (monto >= 0)
) ENGINE=InnoDB COMMENT='Capital total disponible en la Caja Popular';

CREATE TABLE presupuesto_operativo (
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    ejercicio_anio       INT           NOT NULL UNIQUE,
    monto_asignado       DECIMAL(14,2) NOT NULL,
    monto_ejercido       DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    ultima_actualizacion TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_presupuesto_positivo CHECK (monto_asignado > 0),
    CONSTRAINT chk_presupuesto_ejercido CHECK (monto_ejercido >= 0 AND monto_ejercido <= monto_asignado)
) ENGINE=InnoDB COMMENT='Presupuesto anual asignado y ejercido';

-- ------------------------------------------------------------
-- 2. INDICES
-- ------------------------------------------------------------

CREATE INDEX idx_socios_sucursal      ON socios(sucursal_id);
CREATE INDEX idx_socios_estado        ON socios(estado);
CREATE INDEX idx_cuentas_socio        ON cuentas_ahorro(socio_id);
CREATE INDEX idx_prestamos_socio      ON prestamos(socio_id);
CREATE INDEX idx_prestamos_estado     ON prestamos(estado);
CREATE INDEX idx_transacciones_cuenta ON transacciones(cuenta_id);
CREATE INDEX idx_transacciones_fecha  ON transacciones(fecha);
CREATE INDEX idx_abonos_prestamo      ON abonos_prestamo(prestamo_id);
CREATE INDEX idx_abonos_mes           ON abonos_prestamo(mes_correspondiente);
CREATE INDEX idx_documentos_socio     ON documentos_socio(socio_id);
CREATE INDEX idx_beneficiarios_socio  ON beneficiarios(socio_id);

-- ------------------------------------------------------------
-- 3. PROCEDIMIENTO AUXILIAR (reemplaza funcion validar_beneficiarios)
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE sp_validar_beneficiarios(IN p_socio INT)
BEGIN
    DECLARE v_count INT;
    DECLARE v_suma  DECIMAL(6,2);
    SELECT COUNT(*), COALESCE(SUM(porcentaje),0)
      INTO v_count, v_suma
      FROM beneficiarios WHERE socio_id = p_socio;
    IF v_count > 4 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un socio no puede tener mas de 4 beneficiarios';
    END IF;
    IF v_suma > 100.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La suma de porcentajes de beneficiarios no puede exceder 100';
    END IF;
    UPDATE socios
       SET beneficiarios_completos = (v_count BETWEEN 1 AND 4 AND v_suma = 100.00)
     WHERE id = p_socio;
END$$

-- ------------------------------------------------------------
-- 4. TRIGGERS DE REGLAS (creados ANTES de la carga de datos,
--    igual que en el original PostgreSQL)
-- ------------------------------------------------------------

-- 4.1 socios: edad >= 19 y aporte >= 3000 (INSERT y UPDATE)
CREATE TRIGGER trg_socios_bi
BEFORE INSERT ON socios FOR EACH ROW
BEGIN
    IF NEW.fecha_nacimiento > (CURDATE() - INTERVAL 19 YEAR) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio debe tener 19 anios o mas cumplidos';
    END IF;
    IF NEW.aporte_inicial < 3000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El aporte inicial minimo para abrir cuenta es de 3000.00';
    END IF;
END$$

CREATE TRIGGER trg_socios_bu
BEFORE UPDATE ON socios FOR EACH ROW
BEGIN
    -- check_socio_reglas
    IF NEW.fecha_nacimiento > (CURDATE() - INTERVAL 19 YEAR) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio debe tener 19 anios o mas cumplidos';
    END IF;
    IF NEW.aporte_inicial < 3000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El aporte inicial minimo para abrir cuenta es de 3000.00';
    END IF;
    -- saldar_prestamo_por_defuncion (solo cuando cambia fecha_defuncion)
    IF NEW.fecha_defuncion IS NOT NULL
       AND (OLD.fecha_defuncion IS NULL OR NOT (OLD.fecha_defuncion <=> NEW.fecha_defuncion)) THEN
        UPDATE prestamos
           SET estado = 'saldado_defuncion',
               saldo_pendiente = 0,
               motivo_cancelacion = 'Defuncion del socio'
         WHERE socio_id = NEW.id
           AND estado IN ('activo','solicitado');
        SET NEW.estado = 'fallecido';
    END IF;
END$$

-- 4.2 prestamos: max 2 activos/solicitados y monto <= 2x saldo
CREATE TRIGGER trg_prestamos_bi
BEFORE INSERT ON prestamos FOR EACH ROW
BEGIN
    DECLARE v_activos INT;
    DECLARE v_saldo   DECIMAL(12,2);
    -- check_max_prestamos_activos
    IF NEW.estado IN ('activo','solicitado') THEN
        SELECT COUNT(*) INTO v_activos
          FROM prestamos
         WHERE socio_id = NEW.socio_id
           AND estado IN ('activo','solicitado');
        IF v_activos >= 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio ya tiene 2 prestamos activos o solicitados (maximo permitido)';
        END IF;
    END IF;
    -- check_prestamo_vs_saldo
    SELECT saldo INTO v_saldo FROM cuentas_ahorro WHERE socio_id = NEW.socio_id;
    IF v_saldo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio no tiene cuenta de ahorro registrada';
    END IF;
    IF NEW.monto_original > v_saldo * 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto solicitado excede 2 veces el saldo de la cuenta';
    END IF;
END$$

CREATE TRIGGER trg_prestamos_bu
BEFORE UPDATE ON prestamos FOR EACH ROW
BEGIN
    DECLARE v_activos INT;
    DECLARE v_saldo   DECIMAL(12,2);
    IF NEW.estado IN ('activo','solicitado') THEN
        SELECT COUNT(*) INTO v_activos
          FROM prestamos
         WHERE socio_id = NEW.socio_id
           AND estado IN ('activo','solicitado')
           AND id <> NEW.id;
        IF v_activos >= 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio ya tiene 2 prestamos activos o solicitados (maximo permitido)';
        END IF;
    END IF;
    -- vs_saldo solo cuando cambia monto_original (equivale a UPDATE OF monto_original)
    IF NOT (NEW.monto_original <=> OLD.monto_original) THEN
        SELECT saldo INTO v_saldo FROM cuentas_ahorro WHERE socio_id = NEW.socio_id;
        IF v_saldo IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El socio no tiene cuenta de ahorro registrada';
        END IF;
        IF NEW.monto_original > v_saldo * 2 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto solicitado excede 2 veces el saldo de la cuenta';
        END IF;
    END IF;
END$$

-- 4.3 beneficiarios: validar (AFTER INSERT / UPDATE / DELETE)
CREATE TRIGGER trg_benef_ai
AFTER INSERT ON beneficiarios FOR EACH ROW
BEGIN
    CALL sp_validar_beneficiarios(NEW.socio_id);
END$$

CREATE TRIGGER trg_benef_au
AFTER UPDATE ON beneficiarios FOR EACH ROW
BEGIN
    CALL sp_validar_beneficiarios(NEW.socio_id);
END$$

CREATE TRIGGER trg_benef_ad
AFTER DELETE ON beneficiarios FOR EACH ROW
BEGIN
    CALL sp_validar_beneficiarios(OLD.socio_id);
END$$

DELIMITER ;

-- ------------------------------------------------------------
-- 5. VISTAS
-- ------------------------------------------------------------

CREATE VIEW v_socios_elegibles_prestamo AS
SELECT s.id, s.nombre, s.apellidos, ca.saldo,
       LEAST(ca.saldo * 2, 50000.00) AS monto_maximo_prestable
  FROM socios s
  JOIN cuentas_ahorro ca ON ca.socio_id = s.id
 WHERE s.estado = 'activo'
   AND s.fecha_defuncion IS NULL
   AND s.fecha_alta <= (CURDATE() - INTERVAL 6 MONTH)
   AND ca.saldo >= 3000.00
   AND NOT EXISTS (
        SELECT 1 FROM prestamos p
         WHERE p.socio_id = s.id
           AND p.estado IN ('activo','solicitado')
   );

CREATE VIEW v_prestamos_en_mora AS
SELECT p.id, p.socio_id, s.nombre, s.apellidos,
       p.monto_original, p.saldo_pendiente,
       p.fecha_limite_pago,
       DATEDIFF(CURDATE(), p.fecha_limite_pago) AS dias_mora
  FROM prestamos p
  JOIN socios s ON s.id = p.socio_id
 WHERE p.estado = 'activo'
   AND p.fecha_limite_pago < CURDATE();

CREATE VIEW v_resumen_socios AS
SELECT s.id, s.nombre, s.apellidos, s.estado, s.fecha_alta,
       ca.saldo AS saldo_cuenta,
       (SELECT COUNT(*) FROM prestamos p
         WHERE p.socio_id = s.id AND p.estado = 'activo') AS prestamos_activos,
       (SELECT COALESCE(SUM(porcentaje),0) FROM beneficiarios b
         WHERE b.socio_id = s.id) AS suma_beneficiarios
  FROM socios s
  LEFT JOIN cuentas_ahorro ca ON ca.socio_id = s.id;

-- ------------------------------------------------------------
-- 6. DATOS SEMILLA
-- ------------------------------------------------------------

INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES
('Matriz Guadalajara', 'Guadalajara',  'Av. Vallarta 1234, Col. Ladron de Guevara, Guadalajara, Jalisco', TRUE),
('Sucursal Zapopan',   'Zapopan',      'Av. Patria 567, Col. Jardines Universidad, Zapopan, Jalisco',   FALSE),
('Sucursal Tlaquepaque','Tlaquepaque', 'Calle Independencia 89, Centro, San Pedro Tlaquepaque, Jalisco',FALSE),
('Sucursal Tonala',    'Tonala',       'Av. Tonalteca 234, Centro, Tonala, Jalisco',                    FALSE),
('Sucursal Tlajomulco', 'Tlajomulco',  'Carr. a Chapala Km 12, Tlajomulco de Zuniga, Jalisco',          FALSE),
('Sucursal Chapala',   'Chapala',      'Av. Madero 45, Centro, Chapala, Jalisco',                       FALSE);

INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES
('Roberto',   'Guzman Perez',        'roberto.guzman@cajapopular.mx',   'hash_admin_001',  'admin',   1),
('Maria',     'Hernandez Lopez',     'maria.hernandez@cajapopular.mx',  'hash_gerente_01', 'gerente', 1),
('Carlos',    'Ramirez Sanchez',     'carlos.ramirez@cajapopular.mx',   'hash_cajero_001', 'cajero',  1),
('Ana',       'Martinez Gomez',      'ana.martinez@cajapopular.mx',     'hash_cajero_002', 'cajero',  1),
('Jorge',     'Lopez Torres',        'jorge.lopez@cajapopular.mx',      'hash_gerente_02', 'gerente', 2),
('Patricia',  'Gonzalez Ruiz',       'patricia.gonzalez@cajapopular.mx','hash_cajero_003', 'cajero',  2),
('Luis',      'Fernandez Diaz',      'luis.fernandez@cajapopular.mx',   'hash_gerente_03', 'gerente', 3),
('Sofia',     'Vazquez Morales',     'sofia.vazquez@cajapopular.mx',    'hash_cajero_004', 'cajero',  3),
('Diego',     'Mendoza Castillo',    'diego.mendoza@cajapopular.mx',    'hash_gerente_04', 'gerente', 4),
('Laura',     'Cruz Reyes',          'laura.cruz@cajapopular.mx',       'hash_cajero_005', 'cajero',  4),
('Fernando',  'Ortiz Rivera',        'fernando.ortiz@cajapopular.mx',   'hash_gerente_05', 'gerente', 5),
('Gabriela',  'Silva Navarro',       'gabriela.silva@cajapopular.mx',   'hash_cajero_006', 'cajero',  5),
('Miguel',    'Rojas Herrera',       'miguel.rojas@cajapopular.mx',     'hash_gerente_06', 'gerente', 6),
('Adriana',   'Aguilar Flores',      'adriana.aguilar@cajapopular.mx',  'hash_cajero_007', 'cajero',  6);

INSERT INTO capital_caja (monto) VALUES (5000000.00);

INSERT INTO presupuesto_operativo (ejercicio_anio, monto_asignado, monto_ejercido) VALUES
(2025, 500000.00, 480000.00),
(2026, 500000.00, 125000.00);

INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES
('Juan',      'Perez Garcia',       '1985-03-15', 'PEGJ850315HJCRRN01', 'PEGJ850315AB1', 'juan.perez@mail.mx',       '3312345001', '2024-01-10', 1, 'activo', 5000.00),
('Maria',     'Lopez Sanchez',      '1990-07-22', 'LOSM900722MJCPNR02', 'LOSM900722CD2', 'maria.lopez@mail.mx',      '3312345002', '2024-02-15', 1, 'activo', 3000.00),
('Carlos',    'Ramirez Torres',     '1978-11-05', 'RATC781105HJCMRR03', 'RATC781105EF3', 'carlos.ramirez@mail.mx',   '3312345003', '2024-03-20', 2, 'activo', 4500.00),
('Ana',       'Gonzalez Ruiz',      '1995-05-30', 'GORA950530MJCNZN04', 'GORA950530GH4', 'ana.gonzalez@mail.mx',     '3312345004', '2024-04-25', 2, 'activo', 3500.00),
('Jorge',     'Hernandez Diaz',     '1982-09-12', 'HEDJ820912HJCRRZ05', 'HEDJ820912IJ5', 'jorge.hernandez@mail.mx',  '3312345005', '2024-05-05', 3, 'activo', 6000.00),
('Patricia',  'Martinez Gomez',     '1988-01-18', 'MAGP880118MJCRMT06', 'MAGP880118KL6', 'patricia.martinez@mail.mx','3312345006', '2024-06-10', 3, 'activo', 3000.00),
('Luis',      'Vazquez Morales',    '1975-04-25', 'VAML750425HJCZRS07', 'VAML750425MN7', 'luis.vazquez@mail.mx',     '3312345007', '2024-07-15', 4, 'activo', 8000.00),
('Sofia',     'Mendoza Castillo',   '1992-08-08', 'MECS920808MJCNSF08', 'MECS920808OP8', 'sofia.mendoza@mail.mx',    '3312345008', '2024-08-20', 4, 'activo', 3200.00),
('Diego',     'Cruz Reyes',         '1980-12-14', 'CURD801214HJCRYG09', 'CURD801214QR9', 'diego.cruz@mail.mx',       '3312345009', '2024-09-25', 5, 'activo', 5500.00),
('Laura',     'Ortiz Rivera',       '1987-06-20', 'OIRL870620MJCRVR10', 'OIRL870620ST0', 'laura.ortiz@mail.mx',      '3312345010', '2024-10-05', 5, 'activo', 4000.00),
('Fernando',  'Silva Navarro',      '1972-02-28', 'SISI720228HJCLVR11', 'SISI720228UV1', 'fernando.silva@mail.mx',   '3312345011', '2024-11-10', 6, 'activo', 7500.00),
('Gabriela',  'Rojas Herrera',      '1993-10-03', 'ROHG931003MJCJRR12', 'ROHG931003WX2', 'gabriela.rojas@mail.mx',   '3312345012', '2024-12-15', 6, 'activo', 3000.00),
('Miguel',    'Aguilar Flores',     '1984-07-17', 'AAFM840717HJCGLR13', 'AAFM840717YZ3', 'miguel.aguilar@mail.mx',   '3312345013', '2025-01-20', 1, 'activo', 6500.00),
('Adriana',   'Torres Jimenez',     '1991-11-11', 'TOJA911111MJCRMR14', 'TOJA911111AB4', 'adriana.torres@mail.mx',   '3312345014', '2025-02-05', 1, 'activo', 3800.00),
('Ricardo',   'Ibarra Salazar',     '1979-05-09', 'IASR790509HJCBLC15', 'IASR790509CD5', 'ricardo.ibarra@mail.mx',   '3312345015', '2025-03-12', 2, 'activo', 5000.00),
('Elena',     'Nunez Campos',       '1986-08-24', 'NUCE860824MJCXMR16', 'NUCE860824EF6', 'elena.nunez@mail.mx',      '3312345016', '2025-04-18', 2, 'activo', 3300.00),
('Pablo',     'Contreras Vega',     '1974-01-06', 'COVP740106HJCNVL17', 'COVP740106GH7', 'pablo.contreras@mail.mx',  '3312345017', '2025-05-22', 3, 'activo', 9000.00),
('Monica',    'Estrada Solis',      '1994-03-19', 'EESM940319MJCSNC18', 'EESM940319IJ8', 'monica.estrada@mail.mx',   '3312345018', '2025-06-28', 3, 'activo', 3000.00),
('Alberto',   'Molina Peña',        '1983-09-27', 'MOPA830927HJCLXL19', 'MOPA830927KL9', 'alberto.molina@mail.mx',   '3312345019', '2025-07-04', 4, 'activo', 4200.00),
('Rosa',      'Delgado Cortes',     '1989-12-01', 'DECR891201MJCLRS20', 'DECR891201MN0', 'rosa.delgado@mail.mx',     '3312345020', '2025-08-11', 4, 'activo', 3500.00),
('Enrique',   'Cabrera Guzman',     '1976-06-13', 'CAGE760613HJCBZN21', 'CAGE760613OP1', 'enrique.cabrera@mail.mx',  '3312345021', '2025-09-16', 5, 'activo', 6800.00),
('Cristina',  'Alvarez Mora',       '1996-04-05', 'AAMC960405MJCLRR22', 'AAMC960405QR2', 'cristina.alvarez@mail.mx', '3312345022', '2025-10-21', 5, 'activo', 3000.00),
('Ramon',     'Pacheco Duran',      '1981-10-29', 'PADR811029HJCCRM23', 'PADR811029ST3', 'ramon.pacheco@mail.mx',    '3312345023', '2025-11-26', 6, 'activo', 5200.00),
('Beatriz',   'Rivas Espinoza',     '1990-02-17', 'RIEB900217MJCVSN24', 'RIEB900217UV4', 'beatriz.rivas@mail.mx',    '3312345024', '2025-12-30', 6, 'activo', 4100.00),
('Sergio',    'Zamora Palacios',    '1977-07-08', 'ZAPS770708HJCMLR25', 'ZAPS770708WX5', 'sergio.zamora@mail.mx',    '3312345025', '2026-01-15', 1, 'activo', 7000.00),
('Veronica',  'Gutierrez Franco',   '1985-11-23', 'GUFV851123MJCTRR26', 'GUFV851123YZ6', 'veronica.gutierrez@mail.mx','3312345026','2026-02-20', 2, 'activo', 3600.00),
('Andres',    'Villanueva Soto',    '1973-05-16', 'VISA730516HJCLLN27', 'VISA730516AB7', 'andres.villanueva@mail.mx','3312345027', '2026-03-25', 3, 'activo', 8500.00),
('Karla',     'Reyes Miranda',      '1997-08-04', 'REMK970804MJCYRR28', 'REMK970804CD8', 'karla.reyes@mail.mx',      '3312345028', '2026-04-30', 4, 'activo', 3000.00),
('Ivan',      'Serrano Cardenas',   '1988-12-22', 'SECI881222HJCRRV29', 'SECI881222EF9', 'ivan.serrano@mail.mx',     '3312345029', '2026-05-08', 5, 'activo', 4700.00),
('Alejandra', 'Ponce Bautista',     '1979-03-30', 'POBA790330MJCNTL30', 'POBA790330GH0', 'alejandra.ponce@mail.mx',  '3312345030', '2026-06-12', 6, 'activo', 5300.00);

INSERT INTO documentos_socio (socio_id, tipo, verificado)
SELECT s.id, t.tipo, TRUE
  FROM socios s
 CROSS JOIN (
    SELECT 'INE' AS tipo
    UNION ALL SELECT 'CURP'
    UNION ALL SELECT 'RFC'
    UNION ALL SELECT 'COMPROBANTE_DOMICILIO'
    UNION ALL SELECT 'ACTA_NACIMIENTO'
    UNION ALL SELECT 'CARTA_POLICIA'
    UNION ALL SELECT 'CONSENTIMIENTO_DATOS'
    UNION ALL SELECT 'SOLICITUD'
 ) t;

INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES
(1,  25000.00, '2024-01-10', '2026-07-01', 'activa'),
(2,   8500.00, '2024-02-15', '2026-07-01', 'activa'),
(3,  18000.00, '2024-03-20', '2026-06-01', 'activa'),
(4,   6200.00, '2024-04-25', '2026-07-01', 'activa'),
(5,  32000.00, '2024-05-05', '2026-07-01', 'activa'),
(6,   4800.00, '2024-06-10', '2026-06-01', 'activa'),
(7,  45000.00, '2024-07-15', '2026-07-01', 'activa'),
(8,   9200.00, '2024-08-20', '2026-07-01', 'activa'),
(9,  22000.00, '2024-09-25', '2026-07-01', 'activa'),
(10, 15500.00, '2024-10-05', '2026-06-01', 'activa'),
(11, 38000.00, '2024-11-10', '2026-07-01', 'activa'),
(12,  5100.00, '2024-12-15', '2026-07-01', 'activa'),
(13, 28000.00, '2025-01-20', '2026-07-01', 'activa'),
(14,  7300.00, '2025-02-05', '2026-06-01', 'activa'),
(15, 19500.00, '2025-03-12', '2026-07-01', 'activa'),
(16,  6700.00, '2025-04-18', '2026-07-01', 'activa'),
(17, 42000.00, '2025-05-22', '2026-07-01', 'activa'),
(18,  4200.00, '2025-06-28', '2026-06-01', 'activa'),
(19, 12000.00, '2025-07-04', '2026-07-01', 'activa'),
(20,  8800.00, '2025-08-11', '2026-07-01', 'activa'),
(21, 30000.00, '2025-09-16', '2026-07-01', 'activa'),
(22,  3600.00, '2025-10-21', '2026-07-01', 'activa'),
(23, 17000.00, '2025-11-26', '2026-06-01', 'activa'),
(24, 10500.00, '2025-12-30', '2026-07-01', 'activa'),
(25, 33000.00, '2026-01-15', '2026-07-01', 'activa'),
(26,  7900.00, '2026-02-20', '2026-07-01', 'activa'),
(27, 40000.00, '2026-03-25', '2026-07-01', 'activa'),
(28,  3800.00, '2026-04-30', '2026-06-01', 'activa'),
(29, 11200.00, '2026-05-08', '2026-07-01', 'activa'),
(30, 14300.00, '2026-06-12', '2026-07-01', 'activa');

INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES
(1,  'Carmen',    'Garcia Rodriguez',   100.00, FALSE),
(2,  'Pedro',     'Sanchez Ruiz',        50.00, FALSE),
(2,  'Lucia',     'Sanchez Ruiz',        50.00, FALSE),
(3,  'Elena',     'Torres Vega',         60.00, FALSE),
(3,  'Ricardo',   'Ramirez Torres',      40.00, FALSE),
(4,  'Alma',      'Ruiz Salinas',        33.34, FALSE),
(4,  'Diego',     'Gonzalez Ruiz',       33.33, FALSE),
(4,  'Sofia',     'Gonzalez Ruiz',       33.33, FALSE),
(5,  'Rosa',      'Diaz Cruz',           25.00, FALSE),
(5,  'Miguel',    'Hernandez Diaz',      25.00, FALSE),
(5,  'Ana',       'Hernandez Diaz',      25.00, FALSE),
(5,  'Luis',      'Hernandez Diaz',      25.00, FALSE),
(6,  'Jose',      'Gomez Perez',        100.00, FALSE),
(7,  'Marta',     'Morales Silva',       50.00, FALSE),
(7,  'Julio',     'Vazquez Morales',     50.00, FALSE),
(8,  'Luis',      'Castillo Reyes',     100.00, FALSE),
(9,  'Angela',    'Reyes Contreras',     70.00, FALSE),
(9,  'Mario',     'Cruz Reyes',          30.00, FALSE),
(10, 'Isabel',    'Rivera Ortega',      100.00, FALSE),
(11, 'Roberto',   'Navarro Silva',       40.00, FALSE),
(11, 'Silvia',    'Silva Navarro',       30.00, FALSE),
(11, 'Andrea',    'Silva Navarro',       30.00, FALSE),
(12, 'Ernesto',   'Herrera Diaz',       100.00, FALSE),
(13, 'Paola',     'Flores Aguilar',      60.00, FALSE),
(13, 'Emilio',    'Aguilar Flores',      40.00, FALSE),
(14, 'Nicolas',   'Jimenez Torres',     100.00, FALSE),
(15, 'Blanca',    'Salazar Ibarra',      50.00, FALSE),
(15, 'Rodrigo',   'Ibarra Salazar',      50.00, FALSE),
(16, 'Fabiola',   'Campos Nunez',       100.00, FALSE),
(17, 'Hector',    'Vega Contreras',      25.00, FALSE),
(17, 'Camila',    'Contreras Vega',      25.00, FALSE),
(17, 'Daniela',   'Contreras Vega',      25.00, FALSE),
(17, 'Tomas',     'Contreras Vega',      25.00, FALSE),
(18, 'Julian',    'Solis Estrada',      100.00, FALSE),
(19, 'Regina',    'Peña Molina',         50.00, FALSE),
(19, 'Ivan',      'Molina Peña',         50.00, FALSE),
(20, 'Guadalupe', 'Cortes Delgado',     100.00, FALSE),
(21, 'Xavier',    'Guzman Cabrera',      50.00, FALSE),
(21, 'Norma',     'Cabrera Guzman',      50.00, FALSE),
(22, 'Ismael',    'Mora Alvarez',       100.00, FALSE),
(23, 'Yolanda',   'Duran Pacheco',       50.00, FALSE),
(23, 'Emiliano',  'Pacheco Duran',       50.00, FALSE),
(24, 'Rafael',    'Espinoza Rivas',     100.00, FALSE),
(25, 'Ofelia',    'Palacios Zamora',     40.00, FALSE),
(25, 'Cesar',     'Zamora Palacios',     30.00, FALSE),
(25, 'Lorena',    'Zamora Palacios',     30.00, FALSE),
(26, 'Manuel',    'Franco Gutierrez',   100.00, FALSE),
(27, 'Teresa',    'Soto Villanueva',    100.00, FALSE),
(28, 'Vanessa',   'Miranda Reyes',      100.00, FALSE),
(29, 'Gonzalo',   'Cardenas Serrano',    50.00, FALSE),
(29, 'Ximena',    'Serrano Cardenas',    50.00, FALSE),
(30, 'Estela',    'Bautista Ponce',     100.00, FALSE);

INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES
(1,  20000.00, 12000.00, '2025-08-15', '2025-08-17', 'activo',    '2026-08-15'),
(3,  15000.00,  9000.00, '2025-09-10', '2025-09-12', 'activo',    '2026-09-10'),
(5,  30000.00, 18000.00, '2025-10-05', '2025-10-07', 'activo',    '2026-10-05'),
(7,  40000.00, 25000.00, '2025-11-20', '2025-11-22', 'activo',    '2026-11-20'),
(9,  18000.00, 10000.00, '2026-01-08', '2026-01-10', 'activo',    '2027-01-08'),
(11, 35000.00, 22000.00, '2026-02-14', '2026-02-16', 'activo',    '2027-02-14'),
(13, 25000.00, 15000.00, '2026-03-22', '2026-03-24', 'activo',    '2027-03-22'),
(15, 12000.00,  7000.00, '2025-06-30', '2025-07-02', 'activo',    '2026-06-30'),
(17, 45000.00, 30000.00, '2026-01-18', '2026-01-20', 'activo',    '2027-01-18'),
(19,  8000.00,  4500.00, '2026-04-05', '2026-04-07', 'activo',    '2027-04-05'),
(21, 28000.00, 20000.00, '2026-02-27', '2026-03-01', 'activo',    '2027-02-27'),
(23, 15000.00, 10000.00, '2026-05-12', '2026-05-14', 'activo',    '2027-05-12'),
(2,  10000.00,     0.00, '2024-06-01', '2024-06-03', 'pagado',    '2025-06-01'),
(4,   6000.00,     0.00, '2024-08-15', '2024-08-17', 'pagado',    '2025-08-15'),
(6,   9000.00,     0.00, '2024-10-20', '2024-10-22', 'pagado',    '2025-10-20'),
(25, 50000.00, 50000.00, '2026-07-05', NULL,          'solicitado', NULL),
(27, 40000.00, 40000.00, '2026-07-10', NULL,          'solicitado', NULL),
(29, 10000.00, 10000.00, '2025-11-15', '2025-11-17', 'cancelado', '2026-11-15');

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES
(1,  NULL, 'apertura',            5000.00, 'EFECTIVO', '2024-01-10 10:00', 'Apertura de cuenta',        3),
(2,  NULL, 'apertura',            3000.00, 'EFECTIVO', '2024-02-15 10:00', 'Apertura de cuenta',        3),
(3,  NULL, 'apertura',            4500.00, 'EFECTIVO', '2024-03-20 10:00', 'Apertura de cuenta',        6),
(4,  NULL, 'apertura',            3500.00, 'EFECTIVO', '2024-04-25 10:00', 'Apertura de cuenta',        6),
(5,  NULL, 'apertura',            6000.00, 'EFECTIVO', '2024-05-05 10:00', 'Apertura de cuenta',        8),
(6,  NULL, 'apertura',            3000.00, 'EFECTIVO', '2024-06-10 10:00', 'Apertura de cuenta',        8),
(7,  NULL, 'apertura',            8000.00, 'EFECTIVO', '2024-07-15 10:00', 'Apertura de cuenta',       10),
(8,  NULL, 'apertura',            3200.00, 'EFECTIVO', '2024-08-20 10:00', 'Apertura de cuenta',       10),
(9,  NULL, 'apertura',            5500.00, 'EFECTIVO', '2024-09-25 10:00', 'Apertura de cuenta',       12),
(10, NULL, 'apertura',            4000.00, 'EFECTIVO', '2024-10-05 10:00', 'Apertura de cuenta',       12),
(11, NULL, 'apertura',            7500.00, 'EFECTIVO', '2024-11-10 10:00', 'Apertura de cuenta',       14),
(12, NULL, 'apertura',            3000.00, 'EFECTIVO', '2024-12-15 10:00', 'Apertura de cuenta',       14),
(13, NULL, 'apertura',            6500.00, 'EFECTIVO', '2025-01-20 10:00', 'Apertura de cuenta',        3),
(14, NULL, 'apertura',            3800.00, 'EFECTIVO', '2025-02-05 10:00', 'Apertura de cuenta',        4),
(15, NULL, 'apertura',            5000.00, 'EFECTIVO', '2025-03-12 10:00', 'Apertura de cuenta',        6),
(16, NULL, 'apertura',            3300.00, 'EFECTIVO', '2025-04-18 10:00', 'Apertura de cuenta',        6),
(17, NULL, 'apertura',            9000.00, 'EFECTIVO', '2025-05-22 10:00', 'Apertura de cuenta',        8),
(18, NULL, 'apertura',            3000.00, 'EFECTIVO', '2025-06-28 10:00', 'Apertura de cuenta',        8),
(19, NULL, 'apertura',            4200.00, 'EFECTIVO', '2025-07-04 10:00', 'Apertura de cuenta',       10),
(20, NULL, 'apertura',            3500.00, 'EFECTIVO', '2025-08-11 10:00', 'Apertura de cuenta',       10),
(21, NULL, 'apertura',            6800.00, 'EFECTIVO', '2025-09-16 10:00', 'Apertura de cuenta',       12),
(22, NULL, 'apertura',            3000.00, 'EFECTIVO', '2025-10-21 10:00', 'Apertura de cuenta',       12),
(23, NULL, 'apertura',            5200.00, 'EFECTIVO', '2025-11-26 10:00', 'Apertura de cuenta',       14),
(24, NULL, 'apertura',            4100.00, 'EFECTIVO', '2025-12-30 10:00', 'Apertura de cuenta',       14),
(25, NULL, 'apertura',            7000.00, 'EFECTIVO', '2026-01-15 10:00', 'Apertura de cuenta',        3),
(26, NULL, 'apertura',            3600.00, 'EFECTIVO', '2026-02-20 10:00', 'Apertura de cuenta',        6),
(27, NULL, 'apertura',            8500.00, 'EFECTIVO', '2026-03-25 10:00', 'Apertura de cuenta',        8),
(28, NULL, 'apertura',            3000.00, 'EFECTIVO', '2026-04-30 10:00', 'Apertura de cuenta',       10),
(29, NULL, 'apertura',            4700.00, 'EFECTIVO', '2026-05-08 10:00', 'Apertura de cuenta',       12),
(30, NULL, 'apertura',            5300.00, 'EFECTIVO', '2026-06-12 10:00', 'Apertura de cuenta',       14);

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES
(1,  NULL, 'deposito',            2000.00, 'SPEI',              '2026-05-01 09:15', 'Deposito mensual',           3),
(1,  NULL, 'deposito',            2500.00, 'DEBITO_VISA',       '2026-06-01 09:20', 'Deposito mensual',           3),
(1,  NULL, 'deposito',            3000.00, 'EFECTIVO',          '2026-07-01 09:00', 'Deposito mensual',           3),
(2,  NULL, 'deposito',             500.00, 'EFECTIVO',          '2026-06-01 11:00', 'Deposito mensual',           4),
(2,  NULL, 'deposito',            1000.00, 'SPEI',              '2026-07-01 12:00', 'Deposito mensual',           4),
(3,  NULL, 'deposito',            1500.00, 'EFECTIVO',          '2026-06-01 13:30', 'Deposito mensual',           6),
(4,  NULL, 'deposito',             800.00, 'DEBITO_MASTERCARD', '2026-07-01 14:15', 'Deposito mensual',           6),
(5,  NULL, 'deposito',            5000.00, 'SPEI',              '2026-07-01 15:00', 'Deposito mensual',           8),
(5,  NULL, 'retiro',              1500.00, 'EFECTIVO',          '2026-07-10 16:00', 'Retiro parcial',             8),
(7,  NULL, 'deposito',            8000.00, 'SPEI',              '2026-07-01 10:00', 'Deposito mensual',          10),
(7,  NULL, 'retiro',              2000.00, 'EFECTIVO',          '2026-07-15 12:00', 'Retiro parcial',            10),
(9,  NULL, 'deposito',            3000.00, 'DEBITO_CARNET',     '2026-07-01 11:00', 'Deposito mensual',          12),
(11, NULL, 'deposito',            6000.00, 'SPEI',              '2026-07-01 09:30', 'Deposito mensual',          14),
(13, NULL, 'deposito',            4000.00, 'CREDITO_VISA',      '2026-07-01 10:15', 'Deposito mensual',           3),
(15, NULL, 'deposito',            2500.00, 'EFECTIVO',          '2026-07-01 11:30', 'Deposito mensual',           6),
(17, NULL, 'deposito',            7000.00, 'SPEI',              '2026-07-01 12:45', 'Deposito mensual',           8),
(21, NULL, 'deposito',            5000.00, 'DEBITO_VISA',       '2026-07-01 14:00', 'Deposito mensual',          12),
(23, NULL, 'deposito',            2000.00, 'EFECTIVO',          '2026-06-01 15:30', 'Deposito mensual',          14),
(25, NULL, 'deposito',            6000.00, 'SPEI',              '2026-07-01 09:00', 'Deposito mensual',           3),
(27, NULL, 'deposito',            8000.00, 'SPEI',              '2026-07-01 10:30', 'Deposito mensual',           8);

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES
(1,  1,  'desembolso_prestamo', 20000.00, 'SPEI', '2025-08-17 10:00', 'Desembolso de prestamo',  1),
(3,  2,  'desembolso_prestamo', 15000.00, 'SPEI', '2025-09-12 10:00', 'Desembolso de prestamo',  1),
(5,  3,  'desembolso_prestamo', 30000.00, 'SPEI', '2025-10-07 10:00', 'Desembolso de prestamo',  1),
(7,  4,  'desembolso_prestamo', 40000.00, 'SPEI', '2025-11-22 10:00', 'Desembolso de prestamo',  1),
(9,  5,  'desembolso_prestamo', 18000.00, 'SPEI', '2026-01-10 10:00', 'Desembolso de prestamo',  1),
(11, 6,  'desembolso_prestamo', 35000.00, 'SPEI', '2026-02-16 10:00', 'Desembolso de prestamo',  1),
(13, 7,  'desembolso_prestamo', 25000.00, 'SPEI', '2026-03-24 10:00', 'Desembolso de prestamo',  1),
(15, 8,  'desembolso_prestamo', 12000.00, 'SPEI', '2025-07-02 10:00', 'Desembolso de prestamo',  1),
(17, 9,  'desembolso_prestamo', 45000.00, 'SPEI', '2026-01-20 10:00', 'Desembolso de prestamo',  1),
(19, 10, 'desembolso_prestamo',  8000.00, 'SPEI', '2026-04-07 10:00', 'Desembolso de prestamo',  1),
(21, 11, 'desembolso_prestamo', 28000.00, 'SPEI', '2026-03-01 10:00', 'Desembolso de prestamo',  1),
(23, 12, 'desembolso_prestamo', 15000.00, 'SPEI', '2026-05-14 10:00', 'Desembolso de prestamo',  1),
(2,  13, 'desembolso_prestamo', 10000.00, 'SPEI', '2024-06-03 10:00', 'Desembolso de prestamo',  1),
(4,  14, 'desembolso_prestamo',  6000.00, 'SPEI', '2024-08-17 10:00', 'Desembolso de prestamo',  1),
(6,  15, 'desembolso_prestamo',  9000.00, 'SPEI', '2024-10-22 10:00', 'Desembolso de prestamo',  1);

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES
(1,  1, 'abono_prestamo',  1000.00, 'EFECTIVO', '2026-05-15 10:00', 'Abono mensual capital',     3),
(1,  1, 'abono_prestamo',  1000.00, 'SPEI',     '2026-06-15 10:00', 'Abono mensual capital',     3),
(1,  1, 'abono_prestamo',  1000.00, 'EFECTIVO', '2026-07-15 10:00', 'Abono mensual capital',     3),
(3,  2, 'abono_prestamo',   800.00, 'EFECTIVO', '2026-06-10 10:00', 'Abono mensual',             6),
(3,  2, 'abono_prestamo',   800.00, 'SPEI',     '2026-07-10 10:00', 'Abono mensual',             6),
(5,  3, 'abono_prestamo',  1500.00, 'SPEI',     '2026-06-05 10:00', 'Abono mensual',             8),
(5,  3, 'abono_prestamo',  1500.00, 'EFECTIVO', '2026-07-05 10:00', 'Abono mensual',             8),
(7,  4, 'abono_prestamo',  2500.00, 'SPEI',     '2026-06-20 10:00', 'Abono mensual',            10),
(7,  4, 'abono_prestamo',  2500.00, 'SPEI',     '2026-07-20 10:00', 'Abono mensual',            10),
(9,  5, 'abono_prestamo',  1000.00, 'EFECTIVO', '2026-07-08 10:00', 'Abono mensual',            12),
(11, 6, 'abono_prestamo',  2000.00, 'SPEI',     '2026-07-14 10:00', 'Abono mensual',            14),
(13, 7, 'abono_prestamo',  1500.00, 'SPEI',     '2026-07-22 10:00', 'Abono mensual',             3),
(2,  13,'abono_prestamo', 10000.00, 'SPEI',     '2025-06-01 10:00', 'Liquidacion total prestamo',4),
(4,  14,'abono_prestamo',  6000.00, 'SPEI',     '2025-08-15 10:00', 'Liquidacion total prestamo',6),
(6,  15,'abono_prestamo',  9000.00, 'SPEI',     '2025-10-20 10:00', 'Liquidacion total prestamo',8);

INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES
(1, '2026-05-01',  1000.00,  600.00, '2026-05-15', TRUE),
(1, '2026-06-01',  1000.00,  550.00, '2026-06-15', TRUE),
(1, '2026-07-01',  1000.00,  500.00, '2026-07-15', TRUE),
(2, '2026-06-01',   800.00,  450.00, '2026-06-10', TRUE),
(2, '2026-07-01',   800.00,  400.00, '2026-07-10', TRUE),
(3, '2026-06-01',  1500.00,  900.00, '2026-06-05', TRUE),
(3, '2026-07-01',  1500.00,  850.00, '2026-07-05', TRUE),
(4, '2026-06-01',  2500.00, 1250.00, '2026-06-20', TRUE),
(4, '2026-07-01',  2500.00, 1200.00, '2026-07-20', TRUE),
(5, '2026-07-01',  1000.00,  500.00, '2026-07-08', TRUE),
(6, '2026-07-01',  2000.00, 1100.00, '2026-07-14', TRUE),
(7, '2026-07-01',  1500.00,  750.00, '2026-07-22', TRUE),
(13,'2025-06-01', 10000.00,  500.00, '2025-06-01', TRUE),
(14,'2025-08-01',  6000.00,  300.00, '2025-08-15', TRUE),
(15,'2025-10-01',  9000.00,  450.00, '2025-10-20', TRUE);

UPDATE socios SET fecha_defuncion = '2026-06-15' WHERE id = 8;

-- ------------------------------------------------------------
-- 7. TRIGGERS DE MOVIMIENTO (creados DESPUES de los datos,
--    igual que el original: no recalculan los saldos semilla)
-- ------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER trg_aplicar_transaccion
BEFORE INSERT ON transacciones FOR EACH ROW
BEGIN
    DECLARE v_socio_cuenta   INT;
    DECLARE v_socio_prestamo INT;
    DECLARE v_saldo          DECIMAL(12,2);

    SET @caja_ledger = 'on';

    IF NEW.prestamo_id IS NOT NULL THEN
        SELECT socio_id INTO v_socio_cuenta   FROM cuentas_ahorro WHERE id = NEW.cuenta_id;
        SELECT socio_id INTO v_socio_prestamo FROM prestamos      WHERE id = NEW.prestamo_id;
        IF NOT (v_socio_cuenta <=> v_socio_prestamo) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta y el prestamo no pertenecen al mismo socio';
        END IF;
    END IF;

    IF NEW.tipo IN ('abono_prestamo','penalizacion','desembolso_prestamo')
       AND NEW.prestamo_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La transaccion requiere prestamo_id';
    END IF;

    IF NEW.tipo IN ('deposito','interes_ahorro')
       AND (NEW.monto < 100.00 OR NEW.monto > 10000.00) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Monto fuera de rango 100-10000';
    END IF;

    IF NEW.tipo IN ('deposito','interes_ahorro','apertura','desembolso_prestamo') THEN
        UPDATE cuentas_ahorro SET saldo = saldo + NEW.monto WHERE id = NEW.cuenta_id;
    ELSEIF NEW.tipo = 'retiro' THEN
        SELECT saldo INTO v_saldo FROM cuentas_ahorro WHERE id = NEW.cuenta_id FOR UPDATE;
        IF NEW.monto > v_saldo THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fondos insuficientes para el retiro';
        END IF;
        UPDATE cuentas_ahorro SET saldo = saldo - NEW.monto WHERE id = NEW.cuenta_id;
    ELSEIF NEW.tipo = 'abono_prestamo' THEN
        UPDATE prestamos SET saldo_pendiente = saldo_pendiente - NEW.monto WHERE id = NEW.prestamo_id;
    ELSEIF NEW.tipo = 'penalizacion' THEN
        UPDATE prestamos SET saldo_pendiente = saldo_pendiente + NEW.monto WHERE id = NEW.prestamo_id;
    END IF;

    SET @caja_ledger = NULL;
END$$

CREATE TRIGGER trg_proteger_saldo
BEFORE UPDATE ON cuentas_ahorro FOR EACH ROW
BEGIN
    IF NOT (NEW.saldo <=> OLD.saldo)
       AND (@caja_ledger IS NULL OR @caja_ledger <> 'on') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El saldo solo puede modificarse via transacciones';
    END IF;
END$$

DELIMITER ;
