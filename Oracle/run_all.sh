#!/usr/bin/env bash
# Levanta Oracle Free en Docker y carga toda la Caja Popular.
# Requiere Docker. Idempotente: si el contenedor ya existe, lo reutiliza.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
NAME=oracle-caja
PASS=Oracle_2026
SVC=localhost:1521/FREEPDB1

# 1. Contenedor
if ! docker ps -a --format '{{.Names}}' | grep -q "^${NAME}$"; then
  echo ">> Creando contenedor Oracle Free (primera vez descarga ~2GB)..."
  docker run -d --name "$NAME" -p 1521:1521 -e ORACLE_PASSWORD=$PASS gvenzl/oracle-free:slim-faststart
else
  docker start "$NAME" >/dev/null
fi

echo ">> Esperando a que Oracle este listo..."
until docker logs "$NAME" 2>&1 | grep -q "DATABASE IS READY TO USE"; do sleep 3; done

# 2. Copiar scripts y ejecutar
docker cp "$DIR/." "$NAME:/tmp/orasql" >/dev/null
SYS="sqlplus -S system/${PASS}@${SVC}"
CAJA="sqlplus -S caja/Caja_2026@${SVC}"

echo ">> 0 Crear usuario CAJA (SYSTEM)"
docker exec -i "$NAME" bash -lc "$SYS @/tmp/orasql/0_Crear_Usuario.sql"
echo ">> 1 Estructura (CAJA)"
docker exec -i "$NAME" bash -lc "$CAJA @/tmp/orasql/1_Estructura.sql"      | grep -iE "ORA-|PLS-" || true
echo ">> 2 Logica de reglas (CAJA)"
docker exec -i "$NAME" bash -lc "$CAJA @/tmp/orasql/2_Logica_Reglas.sql"   | grep -iE "ORA-|PLS-" || true
echo ">> 3 Datos (CAJA)"
docker exec -i "$NAME" bash -lc "$CAJA @/tmp/orasql/3_Datos.sql"           | grep -iE "ORA-|PLS-" || true
echo ">> 4 Logica de movimiento (CAJA)"
docker exec -i "$NAME" bash -lc "$CAJA @/tmp/orasql/4_Logica_Movimiento.sql" | grep -iE "ORA-|PLS-" || true
echo ">> 5 Roles y permisos (SYSTEM)"
docker exec -i "$NAME" bash -lc "$SYS @/tmp/orasql/5_Roles_Permisos.sql"   | grep -iE "ORA-" || true

echo ">> LISTO. Entrar con:"
echo "   docker exec -it $NAME sqlplus caja/Caja_2026@${SVC}"
