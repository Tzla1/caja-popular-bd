-- ============================================================
--  Caja Popular - Roles, usuarios y permisos (MariaDB)
--  Equivalente al blindaje de PostgreSQL (Blindaje_Prueba.txt).
--  Requiere ejecutarse como root/admin de MariaDB.
-- ============================================================

USE `BD_Jesdreel_Daniel_Mata_Gomez`;

-- ------------------------------------------------------------
-- 1. ROLES (MariaDB 10.0.5+)
--    consulta -> solo lectura (equivale a rol NOLOGIN de PG)
--    caja     -> operacion CRUD sobre los datos, sin privilegios
--                administrativos (equivale a NOSUPERUSER/NOCREATEDB)
-- ------------------------------------------------------------
CREATE ROLE IF NOT EXISTS consulta;
CREATE ROLE IF NOT EXISTS caja;

GRANT SELECT
    ON `BD_Jesdreel_Daniel_Mata_Gomez`.*
    TO consulta;

GRANT SELECT, INSERT, UPDATE, DELETE
    ON `BD_Jesdreel_Daniel_Mata_Gomez`.*
    TO caja;

-- Permitir ejecutar el procedimiento de validacion a quien opere la caja
GRANT EXECUTE ON PROCEDURE `BD_Jesdreel_Daniel_Mata_Gomez`.sp_validar_beneficiarios TO caja;

-- ------------------------------------------------------------
-- 2. USUARIOS CON CONTRASEÑA (equivale a ALTER ROLE ... PASSWORD)
--    usuario1 -> operador de caja  (rol caja)
--    usuario2 -> consulta/auditoria (rol consulta)
-- ------------------------------------------------------------
CREATE USER IF NOT EXISTS 'usuario1'@'localhost' IDENTIFIED BY 'U1_x9Kd2pLm7Qw!';
CREATE USER IF NOT EXISTS 'usuario2'@'localhost' IDENTIFIED BY 'U2_v4Rt8zBn3Ce!';

GRANT caja     TO 'usuario1'@'localhost';
GRANT consulta TO 'usuario2'@'localhost';

-- Rol activo por defecto al iniciar sesion
SET DEFAULT ROLE caja     FOR 'usuario1'@'localhost';
SET DEFAULT ROLE consulta FOR 'usuario2'@'localhost';

-- ------------------------------------------------------------
-- 3. ENDURECIMIENTO
--    En PostgreSQL: REVOKE ALL ON SCHEMA public FROM PUBLIC.
--    En MariaDB no existe PUBLIC/esquema publico: el principio
--    de minimo privilegio se cumple NO otorgando privilegios
--    globales a ningun usuario. Solo caja/consulta tienen acceso.
-- ------------------------------------------------------------

FLUSH PRIVILEGES;
