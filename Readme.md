# 💰 AlkeWallet - Sistema de Monedero Virtual

Sistema de gestión de monedero digital multi-moneda que permite a los usuarios realizar transferencias con conversión automática entre diferentes divisas utilizando tasas de cambio configurables.

## 📋 Descripción

**AlkeWallet** es una aplicación de monedero virtual que facilita transacciones entre usuarios con soporte para múltiples monedas internacionales. El sistema maneja conversiones automáticas basadas en tasas de cambio respecto a una moneda base (CLP - Peso Chileno).

### Características Principales

- ✅ **Gestión de usuarios** con cuentas asignadas a una moneda específica
- ✅ **Transferencias entre usuarios** con diferentes monedas
- ✅ **Conversión automática** de divisas basada en tasas configurables
- ✅ **Transacciones ACID** que garantizan integridad de datos
- ✅ **Validación de saldo** antes de cada operación
- ✅ **Soporte para 10 monedas** internacionales
- ✅ **Función de conversión** reutilizable entre cualquier par de monedas
- ✅ **Procedimiento almacenado** para transferencias seguras
- ✅ **Vista de resumen** con estadísticas de actividad de usuarios

## 🗄️ Estructura de Base de Datos

### Tabla `usuario`
Almacena la información de cada usuario del sistema.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `usuario_id` | INT (PK) | Identificador único del usuario |
| `nombre` | VARCHAR(100) | Nombre completo del usuario |
| `correo_electronico` | VARCHAR(100) UNIQUE | Email único para login |
| `contrasena` | VARCHAR(255) | Hash de contraseña |
| `saldo` | DECIMAL(15,2) | Saldo actual en su moneda asignada |
| `saldo_moneda_id` | INT (FK) | Moneda de la cuenta del usuario |
| `fecha_creacion` | TIMESTAMP | Fecha de registro automática |

**Claves foráneas:**
- `fk_u_divisa`: Relaciona `saldo_moneda_id` → `moneda(moneda_id)`

---

### Tabla `moneda`
Catálogo de monedas soportadas por el sistema.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `moneda_id` | INT (PK) | Identificador único de la moneda |
| `moneda_iso` | CHAR(3) UNIQUE | Código ISO 4217 (USD, EUR, CLP, etc.) |
| `moneda_nombre` | VARCHAR(100) UNIQUE | Nombre completo de la moneda |
| `moneda_simbolo` | VARCHAR(10) | Símbolo visual ($, €, £, etc.) |
| `tasa` | DECIMAL(10,6) | Tasa de conversión respecto a CLP |

**Nota:** La tasa representa cuántos CLP equivalen a 1 unidad de esa moneda.
- Ejemplo: `USD tasa=950` significa que 1 USD = 950 CLP

---

### Tabla `transaccion`
Registro histórico de todas las transferencias realizadas.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `transaccion_id` | INT (PK) | Identificador único de la transacción |
| `transaccion_fecha` | TIMESTAMP | Fecha y hora de la operación |
| `usuario_remitente_id` | INT (FK) | Usuario que envía el dinero |
| `usuario_destinatario_id` | INT (FK) | Usuario que recibe el dinero |
| `importe` | DECIMAL(15,2) | Monto transferido |
| `importe_moneda_id` | INT (FK) | Moneda en que se registra el importe |

**Claves foráneas:**
- `fk_t_envia`: Relaciona `usuario_remitente_id` → `usuario(usuario_id)`
- `fk_t_recibe`: Relaciona `usuario_destinatario_id` → `usuario(usuario_id)`
- `fk_t_divisa`: Relaciona `importe_moneda_id` → `moneda(moneda_id)`

---

### Vista `resumen_cuenta`
Vista consolidada con estadísticas de cada usuario.

**Información mostrada:**
- Datos básicos del usuario y su moneda
- Total de transacciones enviadas y recibidas
- Suma total enviada y recibida
- Días activos desde el registro

## 💱 Monedas Soportadas

| ISO | Moneda               | Símbolo | Tasa (vs CLP) |
|-----|----------------------|---------|---------------|
| USD | Dólar estadounidense | $       | 950.000000    | 
| EUR | Euro                 | €       | 1035.000000   |
| CLP | Peso chileno         | $       | 1.000000      |
| ARS | Peso argentino       | $       | 0.826000      |
| BRL | Real brasileño       | R$      | 191.000000    |
| MXN | Peso mexicano        | $       | 47.260000     |
| COP | Peso colombiano      | $       | 0.229000      |
| PEN | Sol peruano          | S/      | 254.700000    |
| GBP | Libra esterlina      | £       | 1202.500000   |
| JPY | Yen japonés          | ¥       | 6.350000      |