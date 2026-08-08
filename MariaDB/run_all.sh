#!/usr/bin/env bash
# Carga completa de la Caja Popular en MariaDB y verificacion rapida.
# Uso:  ./run_all.sh        (usa 'sudo mariadb' por auth unix_socket)
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
DB=BD_Jesdreel_Daniel_Mata_Gomez
M="sudo mariadb"

echo ">> 1/3 Creando base..."      ; $M < "$DIR/1_Crear_Base_Datos.sql"
echo ">> 2/3 Estructura y datos..."; $M < "$DIR/2_Estructura_y_Datos.sql"
echo ">> 3/3 Roles y permisos..."  ; $M < "$DIR/3_Roles_Permisos.sql"

echo ">> Verificacion:"
$M "$DB" -t -e "
SELECT 'socios' t, COUNT(*) n FROM socios
UNION ALL SELECT 'transacciones', COUNT(*) FROM transacciones
UNION ALL SELECT 'beneficiarios', COUNT(*) FROM beneficiarios;
SELECT COUNT(*) triggers FROM information_schema.triggers WHERE trigger_schema='$DB';
SELECT TABLE_NAME vistas FROM information_schema.views WHERE table_schema='$DB';"
echo ">> LISTO. Entrar con:  sudo mariadb $DB"
