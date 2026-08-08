-- ============================================================
--  Caja Popular - Estructura y restricciones (Oracle 21c/23ai)
--  Traduccion del esquema PostgreSQL/MariaDB.
--  Ejecutar conectado al schema CAJA (ver 0_Crear_Usuario.sql).
-- ============================================================

-- Limpieza idempotente (ignora errores si no existen)
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE '||t.table_name||' CASCADE CONSTRAINTS';
  END LOOP;
  FOR v IN (SELECT view_name FROM user_views) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW '||v.view_name;
  END LOOP;
END;
/

-- ------------------------------------------------------------
-- 1. TABLAS
-- ------------------------------------------------------------

CREATE TABLE sucursales (
    id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre    VARCHAR2(100) NOT NULL,
    municipio VARCHAR2(100) NOT NULL,
    direccion CLOB          NOT NULL,
    es_matriz NUMBER(1)     DEFAULT 0 NOT NULL,
    CONSTRAINT chk_sucursal_matriz CHECK (es_matriz IN (0,1))
);

CREATE TABLE empleados (
    id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre        VARCHAR2(100) NOT NULL,
    apellidos     VARCHAR2(100) NOT NULL,
    email         VARCHAR2(150) NOT NULL UNIQUE,
    password_hash VARCHAR2(255) NOT NULL,
    rol           VARCHAR2(20)  NOT NULL,
    sucursal_id   NUMBER        NOT NULL,
    activo        NUMBER(1)     DEFAULT 1 NOT NULL,
    CONSTRAINT fk_empleado_sucursal FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    CONSTRAINT chk_empleado_rol CHECK (rol IN ('admin','cajero','gerente')),
    CONSTRAINT chk_empleado_activo CHECK (activo IN (0,1))
);

CREATE TABLE socios (
    id                      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre                  VARCHAR2(100) NOT NULL,
    apellidos               VARCHAR2(100) NOT NULL,
    fecha_nacimiento        DATE          NOT NULL,
    curp                    VARCHAR2(18)  NOT NULL UNIQUE,
    rfc                     VARCHAR2(13)  NOT NULL UNIQUE,
    email                   VARCHAR2(150) UNIQUE,
    telefono                VARCHAR2(15),
    fecha_alta              DATE          DEFAULT TRUNC(SYSDATE) NOT NULL,
    sucursal_id             NUMBER        NOT NULL,
    estado                  VARCHAR2(20)  DEFAULT 'activo' NOT NULL,
    beneficiarios_completos NUMBER(1)     DEFAULT 0 NOT NULL,
    fecha_defuncion         DATE,
    aporte_inicial          NUMBER(12,2)  DEFAULT 3000.00 NOT NULL,
    CONSTRAINT fk_socio_sucursal FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    CONSTRAINT chk_socio_estado CHECK (estado IN ('activo','inactivo','suspendido','fallecido')),
    CONSTRAINT chk_socio_aporte CHECK (aporte_inicial >= 3000.00),
    CONSTRAINT chk_socio_curp_largo CHECK (LENGTH(curp) = 18),
    CONSTRAINT chk_socio_rfc_largo  CHECK (LENGTH(rfc) BETWEEN 12 AND 13),
    CONSTRAINT chk_socio_curp_formato CHECK (REGEXP_LIKE(curp, '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z][0-9]$')),
    CONSTRAINT chk_socio_rfc_formato  CHECK (REGEXP_LIKE(rfc, '^[A-ZÑ&]{3,4}[0-9]{6}[0-9A-Z]{3}$')),
    CONSTRAINT chk_socio_email_formato CHECK (email IS NULL OR REGEXP_LIKE(email, '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$')),
    CONSTRAINT chk_socio_benef_flag CHECK (beneficiarios_completos IN (0,1))
);

CREATE TABLE documentos_socio (
    id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    socio_id      NUMBER       NOT NULL,
    tipo          VARCHAR2(50) NOT NULL,
    fecha_entrega DATE         DEFAULT TRUNC(SYSDATE) NOT NULL,
    verificado    NUMBER(1)    DEFAULT 0 NOT NULL,
    CONSTRAINT fk_documento_socio FOREIGN KEY (socio_id) REFERENCES socios(id) ON DELETE CASCADE,
    CONSTRAINT chk_tipo_documento CHECK (tipo IN (
        'INE','CURP','RFC','COMPROBANTE_DOMICILIO','ACTA_NACIMIENTO',
        'CARTA_POLICIA','CONSENTIMIENTO_DATOS','SOLICITUD')),
    CONSTRAINT chk_doc_verificado CHECK (verificado IN (0,1)),
    CONSTRAINT uq_documento_por_socio UNIQUE (socio_id, tipo)
);

CREATE TABLE beneficiarios (
    id                    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    socio_id              NUMBER       NOT NULL,
    nombre                VARCHAR2(100) NOT NULL,
    apellidos             VARCHAR2(100) NOT NULL,
    porcentaje            NUMBER(5,2)  NOT NULL,
    es_socio              NUMBER(1)    DEFAULT 0 NOT NULL,
    socio_beneficiario_id NUMBER,
    CONSTRAINT fk_beneficiario_socio FOREIGN KEY (socio_id) REFERENCES socios(id) ON DELETE CASCADE,
    CONSTRAINT fk_beneficiario_socio_ben FOREIGN KEY (socio_beneficiario_id) REFERENCES socios(id),
    CONSTRAINT chk_beneficiario_porcentaje CHECK (porcentaje > 0 AND porcentaje <= 100),
    CONSTRAINT chk_benef_es_socio CHECK (es_socio IN (0,1))
);

CREATE TABLE cuentas_ahorro (
    id                   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    socio_id             NUMBER       NOT NULL UNIQUE,
    saldo                NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    fecha_apertura       DATE         DEFAULT TRUNC(SYSDATE) NOT NULL,
    ultimo_deposito_mes  DATE,
    estado               VARCHAR2(20) DEFAULT 'activa' NOT NULL,
    tasa_interes_mensual NUMBER(5,4)  DEFAULT 0.2000 NOT NULL,
    CONSTRAINT fk_cuenta_socio FOREIGN KEY (socio_id) REFERENCES socios(id),
    CONSTRAINT chk_cuenta_estado CHECK (estado IN ('activa','suspendida','cerrada')),
    CONSTRAINT chk_saldo_no_negativo CHECK (saldo >= 0),
    CONSTRAINT chk_tasa_ahorro CHECK (tasa_interes_mensual = 0.2000)
);

CREATE TABLE prestamos (
    id                 NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    socio_id           NUMBER       NOT NULL,
    monto_original     NUMBER(12,2) NOT NULL,
    saldo_pendiente    NUMBER(12,2) NOT NULL,
    tasa_interes       NUMBER(5,4)  DEFAULT 0.0500 NOT NULL,
    fecha_solicitud    DATE         DEFAULT TRUNC(SYSDATE) NOT NULL,
    fecha_aprobacion   DATE,
    estado             VARCHAR2(20) DEFAULT 'solicitado' NOT NULL,
    fecha_limite_pago  DATE,
    dias_atraso        NUMBER       DEFAULT 0 NOT NULL,
    penalizacion_pct   NUMBER(5,4)  DEFAULT 0.4000 NOT NULL,
    monto_penalizacion NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    motivo_cancelacion VARCHAR2(100),
    CONSTRAINT fk_prestamo_socio FOREIGN KEY (socio_id) REFERENCES socios(id),
    CONSTRAINT chk_prestamo_estado CHECK (estado IN ('solicitado','activo','pagado','cancelado','saldado_defuncion')),
    CONSTRAINT chk_prestamo_monto_positivo CHECK (monto_original > 0),
    CONSTRAINT chk_prestamo_monto_max CHECK (monto_original <= 50000.00),
    CONSTRAINT chk_prestamo_saldo CHECK (saldo_pendiente >= 0),
    CONSTRAINT chk_prestamo_saldo_menor_original CHECK (saldo_pendiente <= monto_original),
    CONSTRAINT chk_prestamo_tasa CHECK (tasa_interes = 0.0500),
    CONSTRAINT chk_penalizacion_pct CHECK (penalizacion_pct = 0.4000)
);

CREATE TABLE transacciones (
    id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cuenta_id   NUMBER       NOT NULL,
    prestamo_id NUMBER,
    tipo        VARCHAR2(30) NOT NULL,
    monto       NUMBER(12,2) NOT NULL,
    metodo_pago VARCHAR2(30) NOT NULL,
    fecha       TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    descripcion VARCHAR2(255),
    empleado_id NUMBER,
    CONSTRAINT fk_trans_cuenta   FOREIGN KEY (cuenta_id)   REFERENCES cuentas_ahorro(id),
    CONSTRAINT fk_trans_prestamo FOREIGN KEY (prestamo_id) REFERENCES prestamos(id),
    CONSTRAINT fk_trans_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    CONSTRAINT chk_transaccion_tipo CHECK (tipo IN (
        'deposito','retiro','interes_ahorro','abono_prestamo',
        'desembolso_prestamo','penalizacion','apertura')),
    CONSTRAINT chk_transaccion_metodo CHECK (metodo_pago IN (
        'SPEI','EFECTIVO','DEBITO_VISA','DEBITO_MASTERCARD','DEBITO_CARNET',
        'CREDITO_VISA','CREDITO_MASTERCARD','CREDITO_CARNET')),
    CONSTRAINT chk_transaccion_monto CHECK (monto > 0),
    CONSTRAINT chk_transaccion_deposito_min_max CHECK (
        tipo <> 'deposito' OR (monto >= 100.00 AND monto <= 10000.00))
);

CREATE TABLE abonos_prestamo (
    id                  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prestamo_id         NUMBER       NOT NULL,
    mes_correspondiente DATE         NOT NULL,
    monto_capital       NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    monto_interes       NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    monto_penalizacion  NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    fecha_pago          DATE         DEFAULT TRUNC(SYSDATE) NOT NULL,
    en_tiempo           NUMBER(1)    NOT NULL,
    transaccion_id      NUMBER,
    CONSTRAINT fk_abono_prestamo    FOREIGN KEY (prestamo_id)    REFERENCES prestamos(id),
    CONSTRAINT fk_abono_transaccion FOREIGN KEY (transaccion_id) REFERENCES transacciones(id),
    CONSTRAINT chk_abono_montos_positivos CHECK (
        monto_capital >= 0 AND monto_interes >= 0 AND monto_penalizacion >= 0),
    CONSTRAINT chk_abono_en_tiempo CHECK (en_tiempo IN (0,1)),
    CONSTRAINT uq_abono_prestamo_mes UNIQUE (prestamo_id, mes_correspondiente)
);

CREATE TABLE capital_caja (
    id                   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    monto                NUMBER(14,2) NOT NULL,
    ultima_actualizacion TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_capital_no_negativo CHECK (monto >= 0)
);

CREATE TABLE presupuesto_operativo (
    id                   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ejercicio_anio       NUMBER       NOT NULL UNIQUE,
    monto_asignado       NUMBER(14,2) NOT NULL,
    monto_ejercido       NUMBER(14,2) DEFAULT 0.00 NOT NULL,
    ultima_actualizacion TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_presupuesto_positivo CHECK (monto_asignado > 0),
    CONSTRAINT chk_presupuesto_ejercido CHECK (monto_ejercido >= 0 AND monto_ejercido <= monto_asignado)
);

-- ------------------------------------------------------------
-- 2. COMENTARIOS
-- ------------------------------------------------------------
COMMENT ON TABLE sucursales            IS 'Sucursales fisicas de la Caja Popular';
COMMENT ON TABLE empleados             IS 'Personal autorizado (cajero, admin, gerente)';
COMMENT ON TABLE socios                IS 'Personas afiliadas a la Caja Popular';
COMMENT ON TABLE documentos_socio      IS 'Documentos entregados por cada socio';
COMMENT ON TABLE beneficiarios         IS 'Beneficiarios designados por el socio (max 4, suma 100%)';
COMMENT ON TABLE cuentas_ahorro        IS 'Cuenta unica de ahorro por socio (interes 20% mensual)';
COMMENT ON TABLE prestamos             IS 'Prestamos otorgados (tope 50000, 2x saldo, max 2 activos)';
COMMENT ON TABLE transacciones         IS 'Movimientos monetarios (deposito, retiro, abono, etc)';
COMMENT ON TABLE abonos_prestamo       IS 'Registro de abonos mensuales a prestamos';
COMMENT ON TABLE capital_caja          IS 'Capital total disponible en la Caja Popular';
COMMENT ON TABLE presupuesto_operativo IS 'Presupuesto anual asignado y ejercido';

-- ------------------------------------------------------------
-- 3. INDICES
-- ------------------------------------------------------------
CREATE INDEX idx_socios_sucursal      ON socios(sucursal_id);
CREATE INDEX idx_socios_estado        ON socios(estado);
-- idx_cuentas_socio omitido: cuentas_ahorro.socio_id ya es UNIQUE (Oracle indexa la UK automaticamente)
CREATE INDEX idx_prestamos_socio      ON prestamos(socio_id);
CREATE INDEX idx_prestamos_estado     ON prestamos(estado);
CREATE INDEX idx_transacciones_cuenta ON transacciones(cuenta_id);
CREATE INDEX idx_transacciones_fecha  ON transacciones(fecha);
CREATE INDEX idx_abonos_prestamo      ON abonos_prestamo(prestamo_id);
CREATE INDEX idx_abonos_mes           ON abonos_prestamo(mes_correspondiente);
CREATE INDEX idx_documentos_socio     ON documentos_socio(socio_id);
CREATE INDEX idx_beneficiarios_socio  ON beneficiarios(socio_id);
