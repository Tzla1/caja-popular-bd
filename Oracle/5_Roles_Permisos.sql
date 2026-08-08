-- ============================================================
--  Caja Popular - Roles, usuarios y permisos (Oracle)
--  Ejecutar como SYSTEM sobre FREEPDB1 (crea usuarios locales).
--  Equivale al blindaje de PostgreSQL / archivo 3 de MariaDB.
-- ============================================================

-- Limpieza idempotente
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rol_consulta'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP ROLE rol_caja';     EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usuario1 CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP USER usuario2 CASCADE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ------------------------------------------------------------
-- 1. ROLES
--    rol_consulta -> solo lectura
--    rol_caja     -> operacion CRUD sobre los datos
-- ------------------------------------------------------------
CREATE ROLE rol_consulta;
CREATE ROLE rol_caja;

-- Conceder privilegios sobre cada tabla del schema CAJA
BEGIN
  FOR t IN (SELECT table_name FROM dba_tables WHERE owner = 'CAJA') LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON caja.'||t.table_name||' TO rol_consulta';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON caja.'||t.table_name||' TO rol_caja';
  END LOOP;
END;
/

-- ------------------------------------------------------------
-- 2. USUARIOS CON CONTRASEÑA
--    usuario1 -> operador de caja  (rol_caja)
--    usuario2 -> consulta/auditoria (rol_consulta)
-- ------------------------------------------------------------
CREATE USER usuario1 IDENTIFIED BY "U1_x9Kd2pLm7Qw"
    DEFAULT TABLESPACE USERS QUOTA 0 ON USERS;
CREATE USER usuario2 IDENTIFIED BY "U2_v4Rt8zBn3Ce"
    DEFAULT TABLESPACE USERS QUOTA 0 ON USERS;

GRANT CREATE SESSION TO usuario1;
GRANT CREATE SESSION TO usuario2;

GRANT rol_caja     TO usuario1;
GRANT rol_consulta TO usuario2;

-- Rol activo por defecto
ALTER USER usuario1 DEFAULT ROLE rol_caja;
ALTER USER usuario2 DEFAULT ROLE rol_consulta;
