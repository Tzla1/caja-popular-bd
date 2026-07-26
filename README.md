# Proyecto Final — Base de Datos: Caja Popular

**Alumno:** Jesdreel Daniel Mata Gómez
**Materia:** Base de Datos
**Motor:** PostgreSQL 18 · **Herramienta:** pgAdmin 4

Sistema de base de datos para una Caja Popular (cooperativa de ahorro y préstamo):
socios, cuentas de ahorro, préstamos, transacciones, beneficiarios y sucursales,
con reglas de negocio, integridad referencial y **blindaje de seguridad** contra
manipulación de datos.

---

## 📥 Cómo descargar todo

- **Opción 1 (recomendada):** botón verde **`Code` → `Download ZIP`** en la parte superior del repositorio. Se descarga todo en un solo archivo.
- **Opción 2 (git):** `git clone https://github.com/Tzla1/caja-popular-bd.git`

---

## 🚀 Instalación (2 pasos)

Todo está en dos archivos que se copian y pegan completos. **No requiere nada externo, solo PostgreSQL y pgAdmin.**

### Paso 1 — Crear la base de datos
El archivo `1_Crear_Base_Datos.txt` trae `DROP DATABASE` + `CREATE DATABASE`, que PostgreSQL **no** permite correr dentro del Query Tool normal. Por eso se usa el **PSQL Tool**:

1. En pgAdmin, clic sobre el servidor de PostgreSQL (o sobre la base `postgres`).
2. Menú **Tools → PSQL Tool** (se abre una terminal). Si pide contraseña, la del usuario `postgres`.
3. Abrir `1_Crear_Base_Datos.txt`, `Ctrl+A`, `Ctrl+C`, pegar en la terminal (`Ctrl+Shift+V`) y **Enter**.
4. Clic derecho en **Databases → Refresh**: aparece `BD_Jesdreel_Daniel_Mata_Gomez`.

### Paso 2 — Estructura, datos y blindaje (todo en uno)
1. Clic derecho sobre `BD_Jesdreel_Daniel_Mata_Gomez` → **Query Tool**.
2. Abrir `2_Estructura_y_Datos.txt`, `Ctrl+A`, `Ctrl+C`, pegar en el Query Tool y **F5**.

Ese único bloque crea tablas, restricciones, funciones, triggers, vistas, **el blindaje de seguridad** y carga todos los datos de prueba. Listo.

---

## ✅ Verificación

En el Query Tool de la base nueva:

```sql
SELECT 'Sucursales' AS tabla, COUNT(*) FROM sucursales
UNION ALL SELECT 'Empleados',        COUNT(*) FROM empleados
UNION ALL SELECT 'Socios',           COUNT(*) FROM socios
UNION ALL SELECT 'Documentos',       COUNT(*) FROM documentos_socio
UNION ALL SELECT 'Beneficiarios',    COUNT(*) FROM beneficiarios
UNION ALL SELECT 'Cuentas ahorro',   COUNT(*) FROM cuentas_ahorro
UNION ALL SELECT 'Prestamos',        COUNT(*) FROM prestamos
UNION ALL SELECT 'Transacciones',    COUNT(*) FROM transacciones
UNION ALL SELECT 'Abonos prestamo',  COUNT(*) FROM abonos_prestamo;
```

Debe mostrar: **6, 14, 30, 240, 52, 30, 18, 80, 15**.

---

## 🔒 Blindaje de seguridad (ya integrado en `2_Estructura_y_Datos.txt`)

Se auditó la base buscando formas de brincar las restricciones. Las reglas
estáticas (`CHECK`, `UNIQUE`, `FOREIGN KEY`, `NOT NULL`) **no se pueden
desactivar** en PostgreSQL ni con `session_replication_role=replica`. Los huecos
detectados y cómo quedaron cerrados:

| # | Hueco detectado | Blindaje aplicado |
|---|---|---|
| 1 | **Sobregiro:** se podía retirar más que el saldo | Trigger `aplicar_transaccion` valida fondos antes del retiro |
| 2 | **Saldo editable a mano** (`UPDATE saldo`) | Trigger `proteger_saldo_directo`: el saldo solo se mueve vía transacciones |
| 3 | **Préstamo escalable por UPDATE** (brincaba el límite 2× saldo) | `trg_prestamo_vs_saldo` ahora cubre `INSERT` **y** `UPDATE` |
| 4 | **Transacción cruzada** entre socios | Se valida que cuenta y préstamo sean del mismo socio |
| 5 | **Deuda estática:** abonos no reducían el préstamo | El abono descuenta `saldo_pendiente`; el `CHECK >= 0` frena el exceso |
| 6 | **Tope de depósito evadible** relabelando el tipo | El rango 100–10000 aplica a todo crédito |
| 7 | **Formato débil** de CURP / RFC / email | `CHECK` con expresión regular |

### Prueba del blindaje (opcional)
Después de instalar, estos intentos **deben fallar**:

```sql
INSERT INTO transacciones (cuenta_id, tipo, monto, metodo_pago)
VALUES (1, 'retiro', 999999.00, 'EFECTIVO');            -- Fondos insuficientes

UPDATE cuentas_ahorro SET saldo = 999999999 WHERE id = 1; -- Saldo solo via transacciones

INSERT INTO transacciones (cuenta_id, prestamo_id, tipo, monto, metodo_pago)
VALUES (2, 1, 'abono_prestamo', 100.00, 'EFECTIVO');     -- Cuenta y prestamo no coinciden

INSERT INTO transacciones (cuenta_id, tipo, monto, metodo_pago)
VALUES (1, 'interes_ahorro', 50000.00, 'EFECTIVO');      -- Fuera de rango 100-10000
```

> `Blindaje_Prueba.txt` es el mismo blindaje empaquetado aparte, para aplicarlo
> sobre una base **que ya existe** sin recrearla. Para una instalación desde cero
> no hace falta: ya viene dentro de `2_Estructura_y_Datos.txt`.

---

## 📂 Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `1_Crear_Base_Datos.txt` | Crea la base de datos (PSQL Tool) |
| `2_Estructura_y_Datos.txt` | Estructura + restricciones + funciones + triggers + vistas + blindaje + datos |
| `Blindaje_Prueba.txt` | Blindaje independiente para aplicar sobre una base ya existente |
| `LEEME_PROFESOR.txt` | Instrucciones en texto plano |
| `Documento_2_Diseno_BD.pdf` | Diseño: diagrama, diccionario de datos, reglas de negocio |
| `Documento_3_Instrucciones_DDL_DML.pdf` | Guía de instalación paso a paso |
| `Documento_4_Restricciones_Requisitos.pdf` | Mapeo requisitos RF-01 a RF-20 ↔ SQL |
| `Diagramas/` | Diagrama de estructura (SVG y PNG) |
| `Presentacion/` | Presentación (abrir `index.html` en el navegador) |

---

## 🧱 Modelo de datos

11 tablas: `sucursales`, `empleados`, `socios`, `documentos_socio`,
`beneficiarios`, `cuentas_ahorro`, `prestamos`, `transacciones`,
`abonos_prestamo`, `capital_caja`, `presupuesto_operativo`.

Reglas de negocio principales:
- Socio: 19+ años, aporte inicial ≥ $3,000.
- Cuenta única por socio, saldo no negativo, interés 20% mensual.
- Préstamo: tope $50,000, máximo 2× el saldo, máximo 2 activos por socio, tasa 5%.
- Beneficiarios: máximo 4, la suma de porcentajes no excede 100%.
- Defunción del socio: salda automáticamente sus préstamos.

Ver el diagrama en `Diagramas/Estructura_BD.svg` y el detalle en `Documento_2_Diseno_BD.pdf`.
