-- ============================================================
--  Caja Popular - Creacion del esquema/usuario CAJA (Oracle)
--  Ejecutar como SYSTEM sobre el PDB (FREEPDB1).
--  Equivale a "CREATE DATABASE" de PostgreSQL: en Oracle el
--  contenedor logico de objetos es el SCHEMA de un usuario.
-- ============================================================

-- Limpieza idempotente
BEGIN
   EXECUTE IMMEDIATE 'DROP USER caja CASCADE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE USER caja IDENTIFIED BY "Caja_2026"
    DEFAULT TABLESPACE USERS
    QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE TRIGGER,
      CREATE PROCEDURE, CREATE SEQUENCE, CREATE ROLE
    TO caja;
