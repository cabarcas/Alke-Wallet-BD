-- eliminacion tablas transaccion, usuario, moneda

-- crea base de datos AlkeWallet evitando de error si ya existe
CREATE DATABASE IF NOT EXISTS AlkeWallet;

-- seleccionar la base de datos AlkeWallet como activa
USE AlkeWallet;

-- muestra todas las base de datos del servidor MySQL
SHOW DATABASES;

-- ============================================================================
-- Creacion de tablas
-- ============================================================================

-- 1. Tabla usuario: representa a cada usuario del sistema de monedero.
CREATE TABLE IF NOT EXISTS usuario (
    usuario_id         		INT PRIMARY KEY AUTO_INCREMENT,
    nombre             		VARCHAR(100) NOT NULL,
    correo_electronico 		VARCHAR(100) NOT NULL UNIQUE,
    contrasena         		VARCHAR(255) NOT NULL,
    saldo              		DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    saldo_moneda_id			INT NOT NULL
);

-- 2. Tabla moneda: representa las diferentes monedas que se pueden usar en el monedero.
CREATE TABLE IF NOT EXISTS moneda (
    moneda_id               INT PRIMARY KEY AUTO_INCREMENT,
    moneda_iso              CHAR(3) NOT NULL UNIQUE, -- en que las primeras dos letras código representan el país (iso 3166) 2da y 3ra letra se relacionan con el nombre de la moneda
    moneda_nombre           VARCHAR(100) NOT NULL UNIQUE,
    moneda_simbolo          VARCHAR(10) NOT NULL,
    tasa                    DECIMAL(10,6) NOT NULL DEFAULT 1.000000  -- tasa respecto a una moneda base
);

-- 3. Tabla transaccion: representa cada transacción realizada por los usuarios.
CREATE TABLE IF NOT EXISTS transaccion (
    transaccion_id          INT PRIMARY KEY AUTO_INCREMENT,
	transaccion_fecha       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_remitente_id    INT NOT NULL,
    usuario_destinatario_id INT NOT NULL,
    importe                 DECIMAL(15, 2) NOT NULL,
    importe_moneda_id		INT NOT NULL
);

-- ============================================================================
-- Modificación de tablas
-- ============================================================================


-- Añade la columna fecha_creacion de tipo TIMESTAMP a la tabla usuario usando ALTER,
-- su valor por defecto es la estampa de tiempo actual al momento de insertar un registro.
ALTER TABLE usuario
  ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Añade una clave foránea llamada fk_u_divisa a la tabla usuario que relaciona
-- la columna saldo_moneda_id con moneda_id de la tabla moneda
ALTER TABLE usuario
  ADD CONSTRAINT fk_u_divisa 
      FOREIGN KEY (saldo_moneda_id) REFERENCES moneda(moneda_id);

-- Añade tres claves foráneas a la tabla transaccion:
-- fk_t_envia  relaciona usuario_remitente_id    con usuario(usuario_id),
-- fk_t_recibe relaciona usuario_destinatario_id con usuario(usuario_id),
-- fk_t_divisa relaciona importe_moneda_id       con moneda(moneda_id).
ALTER TABLE transaccion
  ADD CONSTRAINT fk_t_envia 
      FOREIGN KEY (usuario_remitente_id) REFERENCES usuario(usuario_id),
  ADD CONSTRAINT fk_t_recibe
      FOREIGN KEY (usuario_destinatario_id) REFERENCES usuario(usuario_id),
  ADD CONSTRAINT fk_t_divisa 
      FOREIGN KEY (importe_moneda_id) REFERENCES moneda(moneda_id);

-- muestra todas las tablas de existentes dentro de AlkeWAllet (la base de datos activa)
SHOW TABLES;

-- Muestra la estructura de la tabla transaccion: columnas, tipos de dato, claves, etc.
DESCRIBE transaccion; 

-- Muestra la estructura de la tabla usuario
DESCRIBE usuario;

-- Muestra la estructura de la tabla moneda
DESCRIBE moneda;


-- ============================================================================
-- Datos de prueba
-- ============================================================================

-- inserta registro en moneda
INSERT INTO moneda (moneda_iso, moneda_nombre, moneda_simbolo, tasa) VALUES
('USD', 'Dólar estadounidense', '$',     950.000000),
('EUR', 'Euro',                 '€',    1035.000000),
('CLP', 'Peso chileno',         '$',       1.000000),
('ARS', 'Peso argentino',       '$',       0.826000),
('BRL', 'Real brasileño',       'R$',    191.000000),
('MXN', 'Peso mexicano',        '$',      47.260000),
('COP', 'Peso colombiano',      '$',       0.229000),
('PEN', 'Sol peruano',          'S/',    254.700000),
('GBP', 'Libra esterlina',      '£',    1202.500000),
('JPY', 'Yen japonés',          '¥',       6.350000);

SELECT * FROM moneda;

-- insercion usuario demo
INSERT INTO usuario  (nombre, correo_electronico, contrasena, saldo, saldo_moneda_id) VALUES
('demo', 'demo@demo.com', '1234', 500000.00, 3);

-- insercion usuarios de prueba
INSERT INTO usuario  (nombre, correo_electronico, contrasena, saldo, saldo_moneda_id) VALUES
('Juan Pérez',       'juan.perez@mail.com',       'pass123hash',  5000.00,  1),
('María García',     'maria.garcia@mail.com',     'pass456hash',  3000.00,  2),
('Carlos López',     'carlos.lopez@mail.com',     'pass789hash',  7500.50,  3),
('Ana Martínez',     'ana.martinez@mail.com',     'pass321hash',  1200.75,  4),
('Luis Rodríguez',   'luis.rodriguez@mail.com',   'pass654hash',  4300.00,  5),
('Sofia Fernández',  'sofia.fernandez@mail.com',  'pass987hash',  8900.25,  6),
('Pedro Sánchez',    'pedro.sanchez@mail.com',    'pass147hash',  2150.00,  7),
('Laura González',   'laura.gonzalez@mail.com',   'pass258hash',  6700.80,  8),
('Diego Torres',     'diego.torres@mail.com',     'pass369hash',     0.00,  9),
('Valentina Díaz',   'valentina.diaz@mail.com',   'pass741hash', 12500.00, 10);

SELECT * FROM usuario;

-- inserccion transacciones de prueba
INSERT INTO transaccion (transaccion_fecha, usuario_remitente_id, usuario_destinatario_id, importe, importe_moneda_id) VALUES
('2026-01-20 10:30:00',  1, 2 ,  500.00, 1),
('2026-01-21 14:15:00',  2,  3, 1200.50, 1),
('2026-01-22 09:45:00',  3,  1,  300.00, 1),
('2026-01-22 16:20:00',  1,  4,  750.25, 2),
('2026-01-23 11:00:00',  4,  5, 2000.00, 1),
('2026-01-23 13:30:00',  5,  2,  450.75, 1),
('2026-01-24 08:50:00',  2,  6, 1500.00, 3),
('2026-01-24 15:10:00',  6,  7,  800.00, 1),
('2026-01-25 10:25:00',  7,  8,  650.50, 2),
('2026-01-25 17:40:00',  8,  1, 1100.00, 1),
('2026-01-26 12:15:00',  1,  9,  950.30, 1),
('2026-01-26 14:55:00',  9, 10, 3200.00, 1),
('2026-01-27 09:30:00', 10,  3,  575.80, 2),
('2026-01-27 11:20:00',  3,  6,  420.00, 1),
('2026-01-27 13:45:00',  5,  4, 1800.50, 1);

SELECT * FROM transaccion;

-- ============================================================================
-- Consultas
-- ============================================================================

-- Obtiene la cuenta, saldo y la moneda que utiliza del usuario específico.
       SELECT u.usuario_id AS id, u.nombre, u.correo_electronico AS email, u.saldo, m.moneda_nombre AS divisa, m.moneda_simbolo AS simbolo 
         FROM usuario u
   INNER JOIN moneda m ON u.saldo_moneda_id = m.moneda_id
	    WHERE u.usuario_id = 1;
   
-- Obtiene todas las transacciones registradas.
SELECT 
     transaccion_id      AS tx,
     u1.nombre           AS envia, 
     u2.nombre           AS recibe, 
     round(t.importe)    AS cuanto, 
     m.moneda_nombre     AS divisa, 
     t.transaccion_fecha AS fecha 
FROM transaccion t
INNER JOIN usuario u1    ON t.usuario_remitente_id    = u1.usuario_id
INNER JOIN usuario u2    ON t.usuario_destinatario_id = u2.usuario_id
INNER JOIN moneda m      ON t.importe_moneda_id       = m.moneda_id
ORDER BY transaccion_id ASC;

-- Obtiene todas las transacciones registradas realizadas por un usuario específico.
SELECT 
     transaccion_id      AS tx,
     u1.nombre           AS envia, 
     u2.nombre           AS recibe, 
     round(t.importe)    AS cuanto, 
     m.moneda_nombre     AS divisa, 
     t.transaccion_fecha AS fecha 
FROM transaccion t
INNER JOIN usuario u1    ON t.usuario_remitente_id    = u1.usuario_id
INNER JOIN usuario u2    ON t.usuario_destinatario_id = u2.usuario_id
INNER JOIN moneda m      ON t.importe_moneda_id       = m.moneda_id
WHERE u1.usuario_id = 1 
ORDER BY transaccion_id ASC;

-- ============================================================================
-- Otras Consultas
-- ============================================================================

-- Sentencia DML para modificar el campo correo electronico de un usuario especifico
UPDATE usuario SET correo_electronico = 'demo@prueba.com' 
 WHERE usuario_id = 1;
 

-- Elimina los datos de una transacción (eliminando la fila completa)
-- borra registro de envio de 950.30 dolares a Laura González 
DELETE FROM transaccion WHERE transaccion_id = 11;

-- Sub consulta que trae al usuario que nunca a recibido dinero por medio de una transferencia o deposito
SELECT 
     u.usuario_id,
     u.nombre,
     u.correo_electronico,
     u.saldo
 FROM usuario u
WHERE u.usuario_id NOT IN (
    SELECT DISTINCT usuario_destinatario_id
    FROM transaccion
)
ORDER BY u.saldo DESC;


-- Vista muestra un resumen completo de cada usuario con datos del: usuario, moneda asignada a la cuenta, transacciones enviadas, recibidas, actividad de la cuenta.
CREATE VIEW resumen_cuenta AS
SELECT 
    u.usuario_id,
    u.nombre,
    u.correo_electronico,
    u.saldo                               AS saldo_actual,
    m.moneda_simbolo,
    m.moneda_nombre,
    COUNT(DISTINCT t1.transaccion_id)     AS transacciones_enviadas,
    COUNT(DISTINCT t2.transaccion_id)     AS transacciones_recibidas,
    COALESCE(SUM(DISTINCT t1.importe), 0) AS total_enviado,
    COALESCE(SUM(DISTINCT t2.importe), 0) AS total_recibido,
    u.fecha_creacion,
    DATEDIFF(CURDATE(), u.fecha_creacion) AS dias_activo
      FROM usuario u
INNER JOIN moneda m       ON u.saldo_moneda_id = m.moneda_id
 LEFT JOIN transaccion t1 ON u.usuario_id      = t1.usuario_remitente_id
 LEFT JOIN transaccion t2 ON u.usuario_id      = t2.usuario_destinatario_id
  GROUP BY u.usuario_id, u.nombre, u.correo_electronico, u.saldo, 
           m.moneda_simbolo, m.moneda_nombre, u.fecha_creacion;

-- Obtiene lo que tiene la vista    
SELECT * FROM resumen_cuenta;
         
-- ============================================================================
-- Ejemplos de transacción ACID de transferencia de fondos entre ususarios
-- ============================================================================
USE AlkeWallet;
-- ============================================================================
-- Estado inicial de los usuarios que se usan en los ejemplos
-- ============================================================================
--   usuario_id | nombre       | saldo      | moneda
--   1          | demo         | 500000.00  | CLP (moneda_id=3, tasa=1)
--   2          | Juan Pérez   |   5000.00  | USD (moneda_id=1, tasa=950)
--   3          | María García |   3000.00  | EUR (moneda_id=2, tasa=1035)
--   4          | Carlos López |   7500.50  | CLP (moneda_id=3, tasa=1)

-- ============================================================================
-- CASO 1: Transferencia exitosa entre la misma moneda
-- Usuario 1 (demo, CLP) envía $200.000 CLP al Usuario 4 (Carlos López, CLP)
-- No requiere conversión porque ambas cuentas están en CLP.
-- ============================================================================
START TRANSACTION;

-- Paso 1: Resta $200.000 CLP del remitente, solo si tiene saldo suficiente
UPDATE usuario
   SET saldo = saldo - 200000.00
 WHERE usuario_id = 1 AND saldo >= 200000.00;

-- Paso 2: Suma $200.000 CLP al destinatario
UPDATE usuario
   SET saldo = saldo + 200000.00
 WHERE usuario_id = 4;

-- Paso 3: Registra la transacción en CLP (moneda_id=3)
INSERT INTO transaccion (usuario_remitente_id, usuario_destinatario_id, importe, importe_moneda_id)
VALUES (1, 4, 200000.00, 3);

COMMIT;

-- Verificación
-- Esperado:
--   Usuario 1: 500000.00 - 200000.00 = 300000.00 CLP
--   Usuario 4:   7500.50 + 200000.00 = 207500.50 CLP

-- ============================================================================
-- CASO 2: Transferencia exitosa entre monedas distintas
-- Usuario 1 (demo, CLP) envía $500 USD al Usuario 2 (Juan Pérez, USD)
-- Conversión necesaria solo en el remitente:
--   500 USD * 950 (tasa USD) = 475.000 CLP se restar de la cuenta de demo
--   El destinatario recibe directamente 500 USD en su cuenta
-- ============================================================================
START TRANSACTION;

-- Paso 1: Resta el equivalente en CLP del importe en USD al remitente,
--         solo si tiene saldo suficiente para cubrir la conversión
UPDATE usuario
   SET saldo = saldo -               (500.00 * (SELECT tasa FROM moneda WHERE moneda_iso = 'USD'))
 WHERE usuario_id = 1 AND saldo >=   (500.00 * (SELECT tasa FROM moneda WHERE moneda_iso = 'USD'));

-- Paso 2: Suma $500 USD directamente al destinatario (su cuenta ya está en USD)
UPDATE usuario
   SET saldo = saldo + 500.00
 WHERE usuario_id = 2;

-- Paso 3: Registra la transacción en USD (moneda_id=1), que es la moneda del importe enviado
INSERT INTO transaccion (usuario_remitente_id, usuario_destinatario_id, importe, importe_moneda_id)
VALUES (1, 2, 500.00, 1);

COMMIT;

-- Verificación
-- Esperado (saldo de usuario 1 ya fue 300000 tras el Caso 1):
--   Usuario 1: 300000.00 - 475000.00 ... saldo insuficiente → no se ejecuta el UPDATE
--   Usuario 2: 5000.00 + 500.00 = 5500.00 USD
SELECT usuario_id, nombre, saldo, saldo_moneda_id 
  FROM usuario 
 WHERE usuario_id IN (1, 2);
 
-- ============================================================================
-- CASO 3: Transferencia fallida por saldo insuficiente (misma moneda)
-- Usuario 2 (Juan Pérez, USD, saldo 5000) intenta enviar $10.000 USD
-- al Usuario 3 (María García, EUR). El saldo no alcanza → ROLLBACK.
-- ============================================================================
START TRANSACTION;

-- Paso 1: Intenta restar $10.000 USD al remitente
--         La condición saldo >= 10000 es FALSE (5000 < 10000) → no se modifica
UPDATE usuario
   SET saldo = saldo - 10000.00
 WHERE usuario_id = 2 AND saldo >= 10000.00;

-- Paso 2: Sumaría al destinatario, pero en la aplicación real se verificaría
--         que el Paso 1 afectó filas antes de continuar. Aquí se ejecuta de igual
--         forma para demostrar que el ROLLBACK revierte todo.
UPDATE usuario
   SET saldo = saldo + (10000.00 * (SELECT tasa FROM moneda WHERE moneda_iso = 'USD') / (SELECT tasa FROM moneda WHERE moneda_iso = 'EUR'))
 WHERE usuario_id = 3;

-- ROLLBACK: cancela ambos UPDATEs, ningún saldo cambia
ROLLBACK;

-- Verificación
-- Esperado: los saldos no cambiaron respecto al estado anterior
--   Usuario 2: 5000.00 USD (sin cambio)
--   Usuario 3: 3000.00 EUR (sin cambio)
--   si se corren los casos unos tras otro en ves en forma aislada, Usuario 2 aparecerá 5500.00 USD en ves de 5000.00 USD. 
      SELECT usuario_id, nombre, saldo, moneda_iso 
        FROM usuario
  INNER JOIN moneda 
          ON saldo_moneda_id = moneda_id
       WHERE usuario_id 
          IN (2, 3);

 
 -- ============================================================================
-- CASO 4: Transferencia fallida por saldo insuficiente (monedas distintas)
-- Usuario 3 (María García, EUR, saldo 3000) intenta enviar $4.000 USD
-- al Usuario 1 (demo, CLP). Al convertir, el importe en EUR supera el saldo → ROLLBACK.
-- Conversión:
--   4000 USD → CLP:  4000 * 950           = 3.800.000 CLP
--   CLP     → EUR:   3800000 / 1035       = 3671.01 EUR
--   El saldo de María es 3000 EUR < 3671.01 EUR → no alcanza
-- ============================================================================
START TRANSACTION;

-- Paso 1: Intenta restar el equivalente en EUR de los 4000 USD al remitente.
--         Convierte: (4000 * tasa_USD) / tasa_EUR = 3671.01 EUR
--         La condición saldo >= 3671.01 es FALSE (3000 < 3671.01) → no se modifica
UPDATE usuario
   SET saldo = saldo - ((4000.00 * (SELECT tasa FROM moneda WHERE moneda_iso = 'USD')) / (SELECT tasa FROM moneda WHERE moneda_iso = 'EUR'))
 WHERE usuario_id = 3 AND saldo >= ((4000.00 * (SELECT tasa FROM moneda WHERE moneda_iso = 'USD')) / (SELECT tasa FROM moneda WHERE moneda_iso = 'EUR'));

-- Paso 2: Sumaría los 4000 USD convertidos a CLP al destinatario.
--         En la aplicación real se verificaría el Paso 1 antes. Aquí se ejecuta
--         para demostrar que el ROLLBACK revierte todo.
UPDATE usuario
   SET saldo = saldo + (4000.00 * (SELECT tasa FROM moneda WHERE moneda_iso = 'USD'))
 WHERE usuario_id = 1;

-- ROLLBACK: cancela ambos UPDATEs, ningún saldo cambia
ROLLBACK;

-- Verificación
-- Esperado: los saldos no cambiaron
--   Usuario 3: 3000.00 EUR (sin cambio)
--   Usuario 1: saldo anterior sin cambio (CLP)
      SELECT usuario_id, nombre, saldo, moneda_iso 
		FROM usuario
  INNER JOIN moneda 
          ON saldo_moneda_id = moneda_id
	   WHERE usuario_id 
          IN (1, 3)
	ORDER BY usuario_id DESC;
 
-- ============================================================================
-- Ejemplo de funcion: convierte de una moneda a otra 
-- ============================================================================
DELIMITER //

CREATE FUNCTION IF NOT EXISTS convertir_moneda(
    p_importe            DECIMAL(15, 2),
    p_moneda_origen_id   INT,
    p_moneda_destino_id  INT
)
RETURNS DECIMAL(15, 2)
DETERMINISTIC
BEGIN
    DECLARE v_tasa_origen   DECIMAL(10, 6);
    DECLARE v_tasa_destino  DECIMAL(10, 6);

    -- Obtiene la tasa de la moneda de origen, copia valor a v_tasa_origen
    SELECT tasa INTO v_tasa_origen
      FROM moneda
     WHERE moneda_id = p_moneda_origen_id;

    -- Obtiene la tasa de la moneda de destino, copia valor a v_tasa_destino
    SELECT tasa INTO v_tasa_destino
      FROM moneda
     WHERE moneda_id = p_moneda_destino_id;

    -- Si alguna moneda no existe, retorna NULL
    IF v_tasa_origen IS NULL OR v_tasa_destino IS NULL THEN
        RETURN NULL;
    END IF;

    -- Convierte: origen → CLP → destino
    RETURN ROUND((p_importe * v_tasa_origen) / v_tasa_destino, 2);
END //

DELIMITER ;

-- Pruebas:
-- 500 USD → CLP: 500 * 950 / 1    = 475000.00 CLP
SELECT convertir_moneda(500.00, 1, 3) AS 'USD → CLP';

-- 475000 CLP → USD: 475000 * 1 / 950 = 500.00 USD
SELECT convertir_moneda(475000.00, 3, 1) AS 'CLP → USD';

-- ============================================================================
-- Ejemplo de procedimiento almacenado basado en el caso 1 de transaccion ACID
-- ============================================================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS transferir_fondos(
    IN  p_remitente_id       INT,
    IN  p_destinatario_id    INT,
    IN  p_importe            DECIMAL(15, 2),
    IN  p_moneda_importe_id  INT
)
BEGIN
    -- Variables para las monedas de cada cuenta
    DECLARE v_moneda_remitente    INT;
    DECLARE v_moneda_destinatario INT;

    -- Variables para los importes convertidos a cada moneda
    DECLARE v_importe_remitente   DECIMAL(15, 2);
    DECLARE v_importe_destino     DECIMAL(15, 2);

    -- Variable para el saldo actual del remitente
    DECLARE v_saldo_remitente     DECIMAL(15, 2);

    -- Manejador de errores: si algo falla, hace ROLLBACK automáticamente
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: la transferencia falló y se revertió.' AS resultado;
    END;

    -- Inicia la transacción
    START TRANSACTION;

    -- ── Paso 1: Obtiene la moneda asignada a cada usuario ──────────────────
    SELECT saldo_moneda_id INTO v_moneda_remitente
      FROM usuario WHERE usuario_id = p_remitente_id;

    SELECT saldo_moneda_id INTO v_moneda_destinatario
      FROM usuario WHERE usuario_id = p_destinatario_id;

    -- ── Paso 2: Convierte el importe a la moneda de cada cuenta ────────────
    -- Ej: si p_importe es 200000 CLP y el remitente tiene CLP → 200000 CLP
    SET v_importe_remitente  = convertir_moneda(p_importe, p_moneda_importe_id, v_moneda_remitente);
    -- Ej: si el destinatario tiene CLP → 200000 CLP
    SET v_importe_destino    = convertir_moneda(p_importe, p_moneda_importe_id, v_moneda_destinatario);

    -- ── Paso 3: Verifica saldo suficiente del remitente ────────────────────
    SELECT saldo INTO v_saldo_remitente
      FROM usuario WHERE usuario_id = p_remitente_id;

    IF v_saldo_remitente < v_importe_remitente THEN
        ROLLBACK;
        SELECT CONCAT(
            'ERROR: saldo insuficiente. ',
            'Saldo actual: ', v_saldo_remitente, ' | ',
            'Importe requerido: ', v_importe_remitente
        ) AS resultado;
        -- LEAVE no es necesario porque el IF ya sale del flujo normal
        -- pero detenemos la ejecución con SIGNAL
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
    END IF;

    -- ── Paso 4: Resta al remitente ──────────────────────────────────────────
    UPDATE usuario
       SET saldo = saldo - v_importe_remitente
     WHERE usuario_id = p_remitente_id;

    -- ── Paso 5: Suma al destinatario ────────────────────────────────────────
    UPDATE usuario
       SET saldo = saldo + v_importe_destino
     WHERE usuario_id = p_destinatario_id;

    -- ── Paso 6: Registra la transacción ─────────────────────────────────────
    INSERT INTO transaccion (usuario_remitente_id, usuario_destinatario_id, importe, importe_moneda_id)
    VALUES (p_remitente_id, p_destinatario_id, p_importe, p_moneda_importe_id);

    -- ── Paso 7: Confirma todo ───────────────────────────────────────────────
    COMMIT;

    SELECT 'OK: transferencia completada.' AS resultado;
END //

DELIMITER ;

-- ============================================================================
-- Pruebas
-- ============================================================================

-- Estado antes de las pruebas
SELECT usuario_id, nombre, saldo, moneda_iso 
		FROM usuario
  INNER JOIN moneda 
          ON saldo_moneda_id = moneda_id
	   WHERE usuario_id 
          IN (1, 2, 4);


-- transferencia ACID caso 1:
-- demo (CLP) envía 200.000 CLP a Carlos López (CLP)
-- Esperado:
--   demo:   500000.00 - 200000.00 = 300000.00 CLP
--   Carlos:   7500.50 + 200000.00 = 207500.50 CLP
CALL transferir_fondos(1, 4, 200000.00, 3);