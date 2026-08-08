-- ============================================================
--  Caja Popular - DATOS SEMILLA (Oracle)
--  Generado desde la version MariaDB.
--  Cambios: 1 INSERT por fila (IDENTITY correcta); TRUE/FALSE -> 1/0.
-- ============================================================
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI';

INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES ('Matriz Guadalajara', 'Guadalajara', 'Av. Vallarta 1234, Col. Ladron de Guevara, Guadalajara, Jalisco', 1);
INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES ('Sucursal Zapopan', 'Zapopan', 'Av. Patria 567, Col. Jardines Universidad, Zapopan, Jalisco', 0);
INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES ('Sucursal Tlaquepaque','Tlaquepaque', 'Calle Independencia 89, Centro, San Pedro Tlaquepaque, Jalisco',0);
INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES ('Sucursal Tonala', 'Tonala', 'Av. Tonalteca 234, Centro, Tonala, Jalisco', 0);
INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES ('Sucursal Tlajomulco', 'Tlajomulco', 'Carr. a Chapala Km 12, Tlajomulco de Zuniga, Jalisco', 0);
INSERT INTO sucursales (nombre, municipio, direccion, es_matriz) VALUES ('Sucursal Chapala', 'Chapala', 'Av. Madero 45, Centro, Chapala, Jalisco', 0);

INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Roberto', 'Guzman Perez', 'roberto.guzman@cajapopular.mx', 'hash_admin_001', 'admin', 1);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Maria', 'Hernandez Lopez', 'maria.hernandez@cajapopular.mx', 'hash_gerente_01', 'gerente', 1);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Carlos', 'Ramirez Sanchez', 'carlos.ramirez@cajapopular.mx', 'hash_cajero_001', 'cajero', 1);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Ana', 'Martinez Gomez', 'ana.martinez@cajapopular.mx', 'hash_cajero_002', 'cajero', 1);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Jorge', 'Lopez Torres', 'jorge.lopez@cajapopular.mx', 'hash_gerente_02', 'gerente', 2);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Patricia', 'Gonzalez Ruiz', 'patricia.gonzalez@cajapopular.mx','hash_cajero_003', 'cajero', 2);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Luis', 'Fernandez Diaz', 'luis.fernandez@cajapopular.mx', 'hash_gerente_03', 'gerente', 3);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Sofia', 'Vazquez Morales', 'sofia.vazquez@cajapopular.mx', 'hash_cajero_004', 'cajero', 3);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Diego', 'Mendoza Castillo', 'diego.mendoza@cajapopular.mx', 'hash_gerente_04', 'gerente', 4);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Laura', 'Cruz Reyes', 'laura.cruz@cajapopular.mx', 'hash_cajero_005', 'cajero', 4);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Fernando', 'Ortiz Rivera', 'fernando.ortiz@cajapopular.mx', 'hash_gerente_05', 'gerente', 5);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Gabriela', 'Silva Navarro', 'gabriela.silva@cajapopular.mx', 'hash_cajero_006', 'cajero', 5);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Miguel', 'Rojas Herrera', 'miguel.rojas@cajapopular.mx', 'hash_gerente_06', 'gerente', 6);
INSERT INTO empleados (nombre, apellidos, email, password_hash, rol, sucursal_id) VALUES ('Adriana', 'Aguilar Flores', 'adriana.aguilar@cajapopular.mx', 'hash_cajero_007', 'cajero', 6);

INSERT INTO capital_caja (monto) VALUES (5000000.00);

INSERT INTO presupuesto_operativo (ejercicio_anio, monto_asignado, monto_ejercido) VALUES (2025, 500000.00, 480000.00);
INSERT INTO presupuesto_operativo (ejercicio_anio, monto_asignado, monto_ejercido) VALUES (2026, 500000.00, 125000.00);

INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Juan', 'Perez Garcia', '1985-03-15', 'PEGJ850315HJCRRN01', 'PEGJ850315AB1', 'juan.perez@mail.mx', '3312345001', '2024-01-10', 1, 'activo', 5000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Maria', 'Lopez Sanchez', '1990-07-22', 'LOSM900722MJCPNR02', 'LOSM900722CD2', 'maria.lopez@mail.mx', '3312345002', '2024-02-15', 1, 'activo', 3000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Carlos', 'Ramirez Torres', '1978-11-05', 'RATC781105HJCMRR03', 'RATC781105EF3', 'carlos.ramirez@mail.mx', '3312345003', '2024-03-20', 2, 'activo', 4500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Ana', 'Gonzalez Ruiz', '1995-05-30', 'GORA950530MJCNZN04', 'GORA950530GH4', 'ana.gonzalez@mail.mx', '3312345004', '2024-04-25', 2, 'activo', 3500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Jorge', 'Hernandez Diaz', '1982-09-12', 'HEDJ820912HJCRRZ05', 'HEDJ820912IJ5', 'jorge.hernandez@mail.mx', '3312345005', '2024-05-05', 3, 'activo', 6000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Patricia', 'Martinez Gomez', '1988-01-18', 'MAGP880118MJCRMT06', 'MAGP880118KL6', 'patricia.martinez@mail.mx','3312345006', '2024-06-10', 3, 'activo', 3000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Luis', 'Vazquez Morales', '1975-04-25', 'VAML750425HJCZRS07', 'VAML750425MN7', 'luis.vazquez@mail.mx', '3312345007', '2024-07-15', 4, 'activo', 8000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Sofia', 'Mendoza Castillo', '1992-08-08', 'MECS920808MJCNSF08', 'MECS920808OP8', 'sofia.mendoza@mail.mx', '3312345008', '2024-08-20', 4, 'activo', 3200.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Diego', 'Cruz Reyes', '1980-12-14', 'CURD801214HJCRYG09', 'CURD801214QR9', 'diego.cruz@mail.mx', '3312345009', '2024-09-25', 5, 'activo', 5500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Laura', 'Ortiz Rivera', '1987-06-20', 'OIRL870620MJCRVR10', 'OIRL870620ST0', 'laura.ortiz@mail.mx', '3312345010', '2024-10-05', 5, 'activo', 4000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Fernando', 'Silva Navarro', '1972-02-28', 'SISI720228HJCLVR11', 'SISI720228UV1', 'fernando.silva@mail.mx', '3312345011', '2024-11-10', 6, 'activo', 7500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Gabriela', 'Rojas Herrera', '1993-10-03', 'ROHG931003MJCJRR12', 'ROHG931003WX2', 'gabriela.rojas@mail.mx', '3312345012', '2024-12-15', 6, 'activo', 3000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Miguel', 'Aguilar Flores', '1984-07-17', 'AAFM840717HJCGLR13', 'AAFM840717YZ3', 'miguel.aguilar@mail.mx', '3312345013', '2025-01-20', 1, 'activo', 6500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Adriana', 'Torres Jimenez', '1991-11-11', 'TOJA911111MJCRMR14', 'TOJA911111AB4', 'adriana.torres@mail.mx', '3312345014', '2025-02-05', 1, 'activo', 3800.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Ricardo', 'Ibarra Salazar', '1979-05-09', 'IASR790509HJCBLC15', 'IASR790509CD5', 'ricardo.ibarra@mail.mx', '3312345015', '2025-03-12', 2, 'activo', 5000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Elena', 'Nunez Campos', '1986-08-24', 'NUCE860824MJCXMR16', 'NUCE860824EF6', 'elena.nunez@mail.mx', '3312345016', '2025-04-18', 2, 'activo', 3300.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Pablo', 'Contreras Vega', '1974-01-06', 'COVP740106HJCNVL17', 'COVP740106GH7', 'pablo.contreras@mail.mx', '3312345017', '2025-05-22', 3, 'activo', 9000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Monica', 'Estrada Solis', '1994-03-19', 'EESM940319MJCSNC18', 'EESM940319IJ8', 'monica.estrada@mail.mx', '3312345018', '2025-06-28', 3, 'activo', 3000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Alberto', 'Molina Peña', '1983-09-27', 'MOPA830927HJCLXL19', 'MOPA830927KL9', 'alberto.molina@mail.mx', '3312345019', '2025-07-04', 4, 'activo', 4200.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Rosa', 'Delgado Cortes', '1989-12-01', 'DECR891201MJCLRS20', 'DECR891201MN0', 'rosa.delgado@mail.mx', '3312345020', '2025-08-11', 4, 'activo', 3500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Enrique', 'Cabrera Guzman', '1976-06-13', 'CAGE760613HJCBZN21', 'CAGE760613OP1', 'enrique.cabrera@mail.mx', '3312345021', '2025-09-16', 5, 'activo', 6800.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Cristina', 'Alvarez Mora', '1996-04-05', 'AAMC960405MJCLRR22', 'AAMC960405QR2', 'cristina.alvarez@mail.mx', '3312345022', '2025-10-21', 5, 'activo', 3000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Ramon', 'Pacheco Duran', '1981-10-29', 'PADR811029HJCCRM23', 'PADR811029ST3', 'ramon.pacheco@mail.mx', '3312345023', '2025-11-26', 6, 'activo', 5200.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Beatriz', 'Rivas Espinoza', '1990-02-17', 'RIEB900217MJCVSN24', 'RIEB900217UV4', 'beatriz.rivas@mail.mx', '3312345024', '2025-12-30', 6, 'activo', 4100.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Sergio', 'Zamora Palacios', '1977-07-08', 'ZAPS770708HJCMLR25', 'ZAPS770708WX5', 'sergio.zamora@mail.mx', '3312345025', '2026-01-15', 1, 'activo', 7000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Veronica', 'Gutierrez Franco', '1985-11-23', 'GUFV851123MJCTRR26', 'GUFV851123YZ6', 'veronica.gutierrez@mail.mx','3312345026','2026-02-20', 2, 'activo', 3600.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Andres', 'Villanueva Soto', '1973-05-16', 'VISA730516HJCLLN27', 'VISA730516AB7', 'andres.villanueva@mail.mx','3312345027', '2026-03-25', 3, 'activo', 8500.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Karla', 'Reyes Miranda', '1997-08-04', 'REMK970804MJCYRR28', 'REMK970804CD8', 'karla.reyes@mail.mx', '3312345028', '2026-04-30', 4, 'activo', 3000.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Ivan', 'Serrano Cardenas', '1988-12-22', 'SECI881222HJCRRV29', 'SECI881222EF9', 'ivan.serrano@mail.mx', '3312345029', '2026-05-08', 5, 'activo', 4700.00);
INSERT INTO socios (nombre, apellidos, fecha_nacimiento, curp, rfc, email, telefono, fecha_alta, sucursal_id, estado, aporte_inicial) VALUES ('Alejandra', 'Ponce Bautista', '1979-03-30', 'POBA790330MJCNTL30', 'POBA790330GH0', 'alejandra.ponce@mail.mx', '3312345030', '2026-06-12', 6, 'activo', 5300.00);

INSERT INTO documentos_socio (socio_id, tipo, verificado)
SELECT s.id, t.tipo, 1
  FROM socios s
 CROSS JOIN (
    SELECT 'INE' AS tipo FROM dual
    UNION ALL SELECT 'CURP' FROM dual
    UNION ALL SELECT 'RFC' FROM dual
    UNION ALL SELECT 'COMPROBANTE_DOMICILIO' FROM dual
    UNION ALL SELECT 'ACTA_NACIMIENTO' FROM dual
    UNION ALL SELECT 'CARTA_POLICIA' FROM dual
    UNION ALL SELECT 'CONSENTIMIENTO_DATOS' FROM dual
    UNION ALL SELECT 'SOLICITUD' FROM dual
 ) t;

INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (1, 25000.00, '2024-01-10', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (2, 8500.00, '2024-02-15', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (3, 18000.00, '2024-03-20', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (4, 6200.00, '2024-04-25', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (5, 32000.00, '2024-05-05', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (6, 4800.00, '2024-06-10', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (7, 45000.00, '2024-07-15', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (8, 9200.00, '2024-08-20', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (9, 22000.00, '2024-09-25', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (10, 15500.00, '2024-10-05', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (11, 38000.00, '2024-11-10', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (12, 5100.00, '2024-12-15', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (13, 28000.00, '2025-01-20', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (14, 7300.00, '2025-02-05', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (15, 19500.00, '2025-03-12', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (16, 6700.00, '2025-04-18', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (17, 42000.00, '2025-05-22', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (18, 4200.00, '2025-06-28', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (19, 12000.00, '2025-07-04', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (20, 8800.00, '2025-08-11', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (21, 30000.00, '2025-09-16', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (22, 3600.00, '2025-10-21', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (23, 17000.00, '2025-11-26', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (24, 10500.00, '2025-12-30', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (25, 33000.00, '2026-01-15', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (26, 7900.00, '2026-02-20', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (27, 40000.00, '2026-03-25', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (28, 3800.00, '2026-04-30', '2026-06-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (29, 11200.00, '2026-05-08', '2026-07-01', 'activa');
INSERT INTO cuentas_ahorro (socio_id, saldo, fecha_apertura, ultimo_deposito_mes, estado) VALUES (30, 14300.00, '2026-06-12', '2026-07-01', 'activa');

INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (1, 'Carmen', 'Garcia Rodriguez', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (2, 'Pedro', 'Sanchez Ruiz', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (2, 'Lucia', 'Sanchez Ruiz', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (3, 'Elena', 'Torres Vega', 60.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (3, 'Ricardo', 'Ramirez Torres', 40.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (4, 'Alma', 'Ruiz Salinas', 33.34, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (4, 'Diego', 'Gonzalez Ruiz', 33.33, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (4, 'Sofia', 'Gonzalez Ruiz', 33.33, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (5, 'Rosa', 'Diaz Cruz', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (5, 'Miguel', 'Hernandez Diaz', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (5, 'Ana', 'Hernandez Diaz', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (5, 'Luis', 'Hernandez Diaz', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (6, 'Jose', 'Gomez Perez', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (7, 'Marta', 'Morales Silva', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (7, 'Julio', 'Vazquez Morales', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (8, 'Luis', 'Castillo Reyes', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (9, 'Angela', 'Reyes Contreras', 70.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (9, 'Mario', 'Cruz Reyes', 30.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (10, 'Isabel', 'Rivera Ortega', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (11, 'Roberto', 'Navarro Silva', 40.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (11, 'Silvia', 'Silva Navarro', 30.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (11, 'Andrea', 'Silva Navarro', 30.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (12, 'Ernesto', 'Herrera Diaz', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (13, 'Paola', 'Flores Aguilar', 60.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (13, 'Emilio', 'Aguilar Flores', 40.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (14, 'Nicolas', 'Jimenez Torres', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (15, 'Blanca', 'Salazar Ibarra', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (15, 'Rodrigo', 'Ibarra Salazar', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (16, 'Fabiola', 'Campos Nunez', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (17, 'Hector', 'Vega Contreras', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (17, 'Camila', 'Contreras Vega', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (17, 'Daniela', 'Contreras Vega', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (17, 'Tomas', 'Contreras Vega', 25.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (18, 'Julian', 'Solis Estrada', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (19, 'Regina', 'Peña Molina', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (19, 'Ivan', 'Molina Peña', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (20, 'Guadalupe', 'Cortes Delgado', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (21, 'Xavier', 'Guzman Cabrera', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (21, 'Norma', 'Cabrera Guzman', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (22, 'Ismael', 'Mora Alvarez', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (23, 'Yolanda', 'Duran Pacheco', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (23, 'Emiliano', 'Pacheco Duran', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (24, 'Rafael', 'Espinoza Rivas', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (25, 'Ofelia', 'Palacios Zamora', 40.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (25, 'Cesar', 'Zamora Palacios', 30.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (25, 'Lorena', 'Zamora Palacios', 30.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (26, 'Manuel', 'Franco Gutierrez', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (27, 'Teresa', 'Soto Villanueva', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (28, 'Vanessa', 'Miranda Reyes', 100.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (29, 'Gonzalo', 'Cardenas Serrano', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (29, 'Ximena', 'Serrano Cardenas', 50.00, 0);
INSERT INTO beneficiarios (socio_id, nombre, apellidos, porcentaje, es_socio) VALUES (30, 'Estela', 'Bautista Ponce', 100.00, 0);

INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (1, 20000.00, 12000.00, '2025-08-15', '2025-08-17', 'activo', '2026-08-15');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (3, 15000.00, 9000.00, '2025-09-10', '2025-09-12', 'activo', '2026-09-10');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (5, 30000.00, 18000.00, '2025-10-05', '2025-10-07', 'activo', '2026-10-05');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (7, 40000.00, 25000.00, '2025-11-20', '2025-11-22', 'activo', '2026-11-20');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (9, 18000.00, 10000.00, '2026-01-08', '2026-01-10', 'activo', '2027-01-08');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (11, 35000.00, 22000.00, '2026-02-14', '2026-02-16', 'activo', '2027-02-14');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (13, 25000.00, 15000.00, '2026-03-22', '2026-03-24', 'activo', '2027-03-22');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (15, 12000.00, 7000.00, '2025-06-30', '2025-07-02', 'activo', '2026-06-30');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (17, 45000.00, 30000.00, '2026-01-18', '2026-01-20', 'activo', '2027-01-18');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (19, 8000.00, 4500.00, '2026-04-05', '2026-04-07', 'activo', '2027-04-05');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (21, 28000.00, 20000.00, '2026-02-27', '2026-03-01', 'activo', '2027-02-27');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (23, 15000.00, 10000.00, '2026-05-12', '2026-05-14', 'activo', '2027-05-12');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (2, 10000.00, 0.00, '2024-06-01', '2024-06-03', 'pagado', '2025-06-01');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (4, 6000.00, 0.00, '2024-08-15', '2024-08-17', 'pagado', '2025-08-15');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (6, 9000.00, 0.00, '2024-10-20', '2024-10-22', 'pagado', '2025-10-20');
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (25, 50000.00, 50000.00, '2026-07-05', NULL, 'solicitado', NULL);
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (27, 40000.00, 40000.00, '2026-07-10', NULL, 'solicitado', NULL);
INSERT INTO prestamos (socio_id, monto_original, saldo_pendiente, fecha_solicitud, fecha_aprobacion, estado, fecha_limite_pago) VALUES (29, 10000.00, 10000.00, '2025-11-15', '2025-11-17', 'cancelado', '2026-11-15');

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, NULL, 'apertura', 5000.00, 'EFECTIVO', '2024-01-10 10:00', 'Apertura de cuenta', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (2, NULL, 'apertura', 3000.00, 'EFECTIVO', '2024-02-15 10:00', 'Apertura de cuenta', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (3, NULL, 'apertura', 4500.00, 'EFECTIVO', '2024-03-20 10:00', 'Apertura de cuenta', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (4, NULL, 'apertura', 3500.00, 'EFECTIVO', '2024-04-25 10:00', 'Apertura de cuenta', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (5, NULL, 'apertura', 6000.00, 'EFECTIVO', '2024-05-05 10:00', 'Apertura de cuenta', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (6, NULL, 'apertura', 3000.00, 'EFECTIVO', '2024-06-10 10:00', 'Apertura de cuenta', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (7, NULL, 'apertura', 8000.00, 'EFECTIVO', '2024-07-15 10:00', 'Apertura de cuenta', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (8, NULL, 'apertura', 3200.00, 'EFECTIVO', '2024-08-20 10:00', 'Apertura de cuenta', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (9, NULL, 'apertura', 5500.00, 'EFECTIVO', '2024-09-25 10:00', 'Apertura de cuenta', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (10, NULL, 'apertura', 4000.00, 'EFECTIVO', '2024-10-05 10:00', 'Apertura de cuenta', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (11, NULL, 'apertura', 7500.00, 'EFECTIVO', '2024-11-10 10:00', 'Apertura de cuenta', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (12, NULL, 'apertura', 3000.00, 'EFECTIVO', '2024-12-15 10:00', 'Apertura de cuenta', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (13, NULL, 'apertura', 6500.00, 'EFECTIVO', '2025-01-20 10:00', 'Apertura de cuenta', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (14, NULL, 'apertura', 3800.00, 'EFECTIVO', '2025-02-05 10:00', 'Apertura de cuenta', 4);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (15, NULL, 'apertura', 5000.00, 'EFECTIVO', '2025-03-12 10:00', 'Apertura de cuenta', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (16, NULL, 'apertura', 3300.00, 'EFECTIVO', '2025-04-18 10:00', 'Apertura de cuenta', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (17, NULL, 'apertura', 9000.00, 'EFECTIVO', '2025-05-22 10:00', 'Apertura de cuenta', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (18, NULL, 'apertura', 3000.00, 'EFECTIVO', '2025-06-28 10:00', 'Apertura de cuenta', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (19, NULL, 'apertura', 4200.00, 'EFECTIVO', '2025-07-04 10:00', 'Apertura de cuenta', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (20, NULL, 'apertura', 3500.00, 'EFECTIVO', '2025-08-11 10:00', 'Apertura de cuenta', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (21, NULL, 'apertura', 6800.00, 'EFECTIVO', '2025-09-16 10:00', 'Apertura de cuenta', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (22, NULL, 'apertura', 3000.00, 'EFECTIVO', '2025-10-21 10:00', 'Apertura de cuenta', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (23, NULL, 'apertura', 5200.00, 'EFECTIVO', '2025-11-26 10:00', 'Apertura de cuenta', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (24, NULL, 'apertura', 4100.00, 'EFECTIVO', '2025-12-30 10:00', 'Apertura de cuenta', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (25, NULL, 'apertura', 7000.00, 'EFECTIVO', '2026-01-15 10:00', 'Apertura de cuenta', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (26, NULL, 'apertura', 3600.00, 'EFECTIVO', '2026-02-20 10:00', 'Apertura de cuenta', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (27, NULL, 'apertura', 8500.00, 'EFECTIVO', '2026-03-25 10:00', 'Apertura de cuenta', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (28, NULL, 'apertura', 3000.00, 'EFECTIVO', '2026-04-30 10:00', 'Apertura de cuenta', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (29, NULL, 'apertura', 4700.00, 'EFECTIVO', '2026-05-08 10:00', 'Apertura de cuenta', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (30, NULL, 'apertura', 5300.00, 'EFECTIVO', '2026-06-12 10:00', 'Apertura de cuenta', 14);

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, NULL, 'deposito', 2000.00, 'SPEI', '2026-05-01 09:15', 'Deposito mensual', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, NULL, 'deposito', 2500.00, 'DEBITO_VISA', '2026-06-01 09:20', 'Deposito mensual', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, NULL, 'deposito', 3000.00, 'EFECTIVO', '2026-07-01 09:00', 'Deposito mensual', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (2, NULL, 'deposito', 500.00, 'EFECTIVO', '2026-06-01 11:00', 'Deposito mensual', 4);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (2, NULL, 'deposito', 1000.00, 'SPEI', '2026-07-01 12:00', 'Deposito mensual', 4);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (3, NULL, 'deposito', 1500.00, 'EFECTIVO', '2026-06-01 13:30', 'Deposito mensual', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (4, NULL, 'deposito', 800.00, 'DEBITO_MASTERCARD', '2026-07-01 14:15', 'Deposito mensual', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (5, NULL, 'deposito', 5000.00, 'SPEI', '2026-07-01 15:00', 'Deposito mensual', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (5, NULL, 'retiro', 1500.00, 'EFECTIVO', '2026-07-10 16:00', 'Retiro parcial', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (7, NULL, 'deposito', 8000.00, 'SPEI', '2026-07-01 10:00', 'Deposito mensual', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (7, NULL, 'retiro', 2000.00, 'EFECTIVO', '2026-07-15 12:00', 'Retiro parcial', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (9, NULL, 'deposito', 3000.00, 'DEBITO_CARNET', '2026-07-01 11:00', 'Deposito mensual', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (11, NULL, 'deposito', 6000.00, 'SPEI', '2026-07-01 09:30', 'Deposito mensual', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (13, NULL, 'deposito', 4000.00, 'CREDITO_VISA', '2026-07-01 10:15', 'Deposito mensual', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (15, NULL, 'deposito', 2500.00, 'EFECTIVO', '2026-07-01 11:30', 'Deposito mensual', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (17, NULL, 'deposito', 7000.00, 'SPEI', '2026-07-01 12:45', 'Deposito mensual', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (21, NULL, 'deposito', 5000.00, 'DEBITO_VISA', '2026-07-01 14:00', 'Deposito mensual', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (23, NULL, 'deposito', 2000.00, 'EFECTIVO', '2026-06-01 15:30', 'Deposito mensual', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (25, NULL, 'deposito', 6000.00, 'SPEI', '2026-07-01 09:00', 'Deposito mensual', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (27, NULL, 'deposito', 8000.00, 'SPEI', '2026-07-01 10:30', 'Deposito mensual', 8);

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, 1, 'desembolso_prestamo', 20000.00, 'SPEI', '2025-08-17 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (3, 2, 'desembolso_prestamo', 15000.00, 'SPEI', '2025-09-12 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (5, 3, 'desembolso_prestamo', 30000.00, 'SPEI', '2025-10-07 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (7, 4, 'desembolso_prestamo', 40000.00, 'SPEI', '2025-11-22 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (9, 5, 'desembolso_prestamo', 18000.00, 'SPEI', '2026-01-10 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (11, 6, 'desembolso_prestamo', 35000.00, 'SPEI', '2026-02-16 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (13, 7, 'desembolso_prestamo', 25000.00, 'SPEI', '2026-03-24 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (15, 8, 'desembolso_prestamo', 12000.00, 'SPEI', '2025-07-02 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (17, 9, 'desembolso_prestamo', 45000.00, 'SPEI', '2026-01-20 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (19, 10, 'desembolso_prestamo', 8000.00, 'SPEI', '2026-04-07 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (21, 11, 'desembolso_prestamo', 28000.00, 'SPEI', '2026-03-01 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (23, 12, 'desembolso_prestamo', 15000.00, 'SPEI', '2026-05-14 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (2, 13, 'desembolso_prestamo', 10000.00, 'SPEI', '2024-06-03 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (4, 14, 'desembolso_prestamo', 6000.00, 'SPEI', '2024-08-17 10:00', 'Desembolso de prestamo', 1);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (6, 15, 'desembolso_prestamo', 9000.00, 'SPEI', '2024-10-22 10:00', 'Desembolso de prestamo', 1);

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, 1, 'abono_prestamo', 1000.00, 'EFECTIVO', '2026-05-15 10:00', 'Abono mensual capital', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, 1, 'abono_prestamo', 1000.00, 'SPEI', '2026-06-15 10:00', 'Abono mensual capital', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (1, 1, 'abono_prestamo', 1000.00, 'EFECTIVO', '2026-07-15 10:00', 'Abono mensual capital', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (3, 2, 'abono_prestamo', 800.00, 'EFECTIVO', '2026-06-10 10:00', 'Abono mensual', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (3, 2, 'abono_prestamo', 800.00, 'SPEI', '2026-07-10 10:00', 'Abono mensual', 6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (5, 3, 'abono_prestamo', 1500.00, 'SPEI', '2026-06-05 10:00', 'Abono mensual', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (5, 3, 'abono_prestamo', 1500.00, 'EFECTIVO', '2026-07-05 10:00', 'Abono mensual', 8);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (7, 4, 'abono_prestamo', 2500.00, 'SPEI', '2026-06-20 10:00', 'Abono mensual', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (7, 4, 'abono_prestamo', 2500.00, 'SPEI', '2026-07-20 10:00', 'Abono mensual', 10);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (9, 5, 'abono_prestamo', 1000.00, 'EFECTIVO', '2026-07-08 10:00', 'Abono mensual', 12);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (11, 6, 'abono_prestamo', 2000.00, 'SPEI', '2026-07-14 10:00', 'Abono mensual', 14);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (13, 7, 'abono_prestamo', 1500.00, 'SPEI', '2026-07-22 10:00', 'Abono mensual', 3);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (2, 13,'abono_prestamo', 10000.00, 'SPEI', '2025-06-01 10:00', 'Liquidacion total prestamo',4);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (4, 14,'abono_prestamo', 6000.00, 'SPEI', '2025-08-15 10:00', 'Liquidacion total prestamo',6);
INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago, fecha, descripcion, empleado_id) VALUES (6, 15,'abono_prestamo', 9000.00, 'SPEI', '2025-10-20 10:00', 'Liquidacion total prestamo',8);

INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (1, '2026-05-01', 1000.00, 600.00, '2026-05-15', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (1, '2026-06-01', 1000.00, 550.00, '2026-06-15', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (1, '2026-07-01', 1000.00, 500.00, '2026-07-15', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (2, '2026-06-01', 800.00, 450.00, '2026-06-10', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (2, '2026-07-01', 800.00, 400.00, '2026-07-10', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (3, '2026-06-01', 1500.00, 900.00, '2026-06-05', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (3, '2026-07-01', 1500.00, 850.00, '2026-07-05', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (4, '2026-06-01', 2500.00, 1250.00, '2026-06-20', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (4, '2026-07-01', 2500.00, 1200.00, '2026-07-20', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (5, '2026-07-01', 1000.00, 500.00, '2026-07-08', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (6, '2026-07-01', 2000.00, 1100.00, '2026-07-14', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (7, '2026-07-01', 1500.00, 750.00, '2026-07-22', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (13,'2025-06-01', 10000.00, 500.00, '2025-06-01', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (14,'2025-08-01', 6000.00, 300.00, '2025-08-15', 1);
INSERT INTO abonos_prestamo (prestamo_id, mes_correspondiente, monto_capital, monto_interes, fecha_pago, en_tiempo) VALUES (15,'2025-10-01', 9000.00, 450.00, '2025-10-20', 1);

UPDATE socios SET fecha_defuncion = '2026-06-15' WHERE id = 8;

COMMIT;