
CREATE DATABASE PeruBeautyDB;
GO
USE PeruBeautyDB;
GO

-- 1. Tabla Cadastro
CREATE TABLE TABLA_CADASTRO (
    codigo_cliente INT PRIMARY KEY,
    documento VARCHAR(20) NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    modalidad_pago VARCHAR(20) CHECK (modalidad_pago IN ('prepago', 'credito', 'rechazo')),
    linea_inicio DECIMAL(10,2) NOT NULL,
    distrito VARCHAR(50),
    provincia VARCHAR(50),
    resultado_buro VARCHAR(5) CHECK (resultado_buro IN ('R1','R2','R3','R4')),
    resultado_antifraude VARCHAR(10) CHECK (resultado_antifraude IN ('Alto', 'Medio', 'Bajo')),
    score_inicio INT CHECK (score_inicio BETWEEN 0 AND 1000)
);

-- 2. Tabla Revendedora
CREATE TABLE TABLA_REVENDEDORA (
    codigo_cliente INT PRIMARY KEY,
    documento VARCHAR(20) NOT NULL,
    nivel INT CHECK (nivel BETWEEN 1 AND 6),
    fecha_inicio DATE NOT NULL,
    ciclo_actual INT NOT NULL,
    gerencia VARCHAR(5) CHECK (gerencia IN ('A','B','C','D')),
    grupo INT CHECK (grupo BETWEEN 1 AND 8),
    Estado VARCHAR(20) CHECK (Estado IN ('Activa', 'Sin_pedido1', 'Sin_pedido2', 'Sin_pedido3')),
    CONSTRAINT FK_Revendedora_Cadastro FOREIGN KEY (codigo_cliente) REFERENCES TABLA_CADASTRO(codigo_cliente)
);

-- 3. Tabla Pedidos
CREATE TABLE TABLA_PEDIDOS (
    numero_pedido VARCHAR(20) PRIMARY KEY,
    codigo_cliente INT NOT NULL,
    monto_pedido DECIMAL(10,2) NOT NULL,
    modalidad_pedido VARCHAR(20) CHECK (modalidad_pedido IN ('prepago', 'contado', 'credito')), -- Ajustado para lógica comercial
    fecha_pedido DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    situacion_pedido VARCHAR(20) CHECK (situacion_pedido IN ('pendiente', 'pagado', 'vencido', 'anulado')),
    dias_atraso INT DEFAULT 0,
    saldo_pedido DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Pedidos_Revendedora FOREIGN KEY (codigo_cliente) REFERENCES TABLA_REVENDEDORA(codigo_cliente)
);

-- 4. Tabla Movimientos
CREATE TABLE TABLA_MOVIMIENTOS (
    id_movimiento INT IDENTITY(1,1) PRIMARY KEY,
    codigo_cliente INT NOT NULL,
    monto_abonado DECIMAL(10,2) NOT NULL,
    pedido_receptor VARCHAR(20) NOT NULL,
    fecha_movimiento DATE NOT NULL,
    entidad_pago VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Movimientos_Revendedora FOREIGN KEY (codigo_cliente) REFERENCES TABLA_REVENDEDORA(codigo_cliente),
    CONSTRAINT FK_Movimientos_Pedido FOREIGN KEY (pedido_receptor) REFERENCES TABLA_PEDIDOS(numero_pedido)
);

-- 5. Tabla Riesgo
CREATE TABLE TABLA_RIESGO (
    id_riesgo INT IDENTITY(1,1) PRIMARY KEY,
    codigo_cliente INT NOT NULL,
    nivel_riesgo VARCHAR(10) CHECK (nivel_riesgo IN ('Bajo', 'Medio', 'Alto', 'Crítico')),
    score_riesgo INT CHECK (score_riesgo BETWEEN 0 AND 1000),
    linea_credito_nueva DECIMAL(10,2) NOT NULL,
    fecha_calificacion DATE NOT NULL,
    CONSTRAINT FK_Riesgo_Revendedora FOREIGN KEY (codigo_cliente) REFERENCES TABLA_REVENDEDORA(codigo_cliente)
);
GO

-- DATA EN TABLA_CADASTRO
INSERT INTO TABLA_CADASTRO VALUES 
(1001, '40000001', '2025-01-10', 'credito', 1500.00, 'Lima', 'Lima', 'R1', 'Bajo', 750),
(1002, '40000002', '2025-01-15', 'credito', 1200.00, 'Miraflores', 'Lima', 'R2', 'Bajo', 620),
(1003, '40000003', '2025-02-01', 'prepago', 0.00, 'Comas', 'Lima', 'R4', 'Alto', 250),
(1004, '40000004', '2025-02-15', 'credito', 2000.00, 'San Isidro', 'Lima', 'R1', 'Bajo', 850),
(1005, '40000005', '2025-03-01', 'credito', 1000.00, 'Los Olivos', 'Lima', 'R3', 'Medio', 480);

-- DATA EN TABLA_REVENDEDORA
INSERT INTO TABLA_REVENDEDORA VALUES 
(1001, '40000001', 3, '2025-01-12', 5, 'A', 2, 'Activa'),
(1002, '40000002', 2, '2025-01-18', 5, 'B', 4, 'Activa'),
(1003, '40000003', 1, '2025-02-05', 4, 'C', 1, 'Sin_pedido1'),
(1004, '40000004', 5, '2025-02-20', 5, 'A', 3, 'Activa'),
(1005, '40000005', 2, '2025-03-05', 5, 'D', 6, 'Sin_pedido2');

-- DATA EN TABLA_PEDIDOS
INSERT INTO TABLA_PEDIDOS VALUES 
('PED-001', 1001, 800.00, 'credito', '2026-04-01', '2026-04-30', 'pagado', 0, 0.00),
('PED-002', 1001, 1200.00, 'credito', '2026-05-01', '2026-05-30', 'pendiente', 15, 400.00),
('PED-003', 1002, 600.00, 'credito', '2026-04-10', '2026-05-10', 'vencido', 35, 600.00),
('PED-004', 1004, 1800.00, 'credito', '2026-05-02', '2026-06-02', 'pendiente', 12, 1800.00),
('PED-005', 1005, 500.00, 'credito', '2026-03-10', '2026-04-10', 'vencido', 65, 500.00);

-- DATA EN TABLA_MOVIMIENTOS
INSERT INTO TABLA_MOVIMIENTOS VALUES 
(1001, 800.00, 'PED-001', '2026-04-28', 'BCP'),
(1001, 800.00, 'PED-002', '2026-05-28', 'BBVA'),
(1004, 0.00, 'PED-004', '2026-06-10', 'Banco de la Nacion'); -- Intento o control interno

-- DATA EN TABLA_RIESGO
INSERT INTO TABLA_RIESGO VALUES 
(1001, 'Bajo', 800, 2000.00, '2026-05-01'),
(1002, 'Alto', 450, 600.00, '2026-05-15'),
(1005, 'Crítico', 180, 0.00, '2026-05-20');
GO


--EJERCICIOS
--1. Listar todas las revendedoras activas en la compañía.
SELECT * FROM TABLA_REVENDEDORA WHERE Estado = 'Activa';

--2. Mostrar los distritos únicos donde residen las consultoras evaluadas.
SELECT DISTINCT distrito FROM TABLA_CADASTRO;

--3. Encontrar pedidos con un monto estrictamente mayor a 1,000 soles.
SELECT numero_pedido, monto_pedido FROM TABLA_PEDIDOS WHERE monto_pedido > 1000;

--4. Contar la cantidad total de pedidos registrados según su situación actual.
SELECT situacion_pedido, COUNT(*) AS total_pedidos 
FROM TABLA_PEDIDOS 
GROUP BY situacion_pedido;

--5. Mostrar los abonos realizados mapeando la fecha y la entidad bancaria ordenada de forma descendente.
SELECT pedido_receptor, monto_abonado, fecha_movimiento, entidad_pago 
FROM TABLA_MOVIMIENTOS 
ORDER BY fecha_movimiento DESC;

--6. Seleccionar las revendedoras incorporadas durante el primer trimestre del año 2025.
SELECT codigo_cliente, fecha_inicio 
FROM TABLA_REVENDEDORA 
WHERE fecha_inicio BETWEEN '2025-01-01' AND '2025-03-31';

--7. Obtener el score de inicio máximo y mínimo de los registros de prospección.
SELECT MAX(score_inicio) AS max_score, MIN(score_inicio) AS min_score FROM TABLA_CADASTRO;


--8. Mostrar el consolidado de deuda total (saldo) y días de atraso promedio por cliente.
SELECT codigo_cliente, SUM(saldo_pedido) AS saldo_total, AVG(dias_atraso) AS promedio_atraso
FROM TABLA_PEDIDOS
GROUP BY codigo_cliente;

--9. Cruzar los datos básicos de la revendedora con su ubicación geográfica (distrito/provincia) registrada en el Cadastro.
SELECT r.codigo_cliente, r.documento, c.distrito, c.provincia, r.Estado
FROM TABLA_REVENDEDORA r
INNER JOIN TABLA_CADASTRO c ON r.codigo_cliente = c.codigo_cliente;

--10. Listar los pedidos con estado "vencido" junto con el teléfono/documento de la revendedora y su gerencia asignada.
SELECT p.numero_pedido, p.saldo_pedido, p.dias_atraso, r.documento, r.gerencia
FROM TABLA_PEDIDOS p
JOIN TABLA_REVENDEDORA r ON p.codigo_cliente = r.codigo_cliente
WHERE p.situacion_pedido = 'vencido';

--11. Encontrar las revendedoras cuya última calificación de riesgo sea 'Alto' o 'Crítico'.
SELECT codigo_cliente, nivel_riesgo, score_riesgo, fecha_calificacion
FROM TABLA_RIESGO
WHERE nivel_riesgo IN ('Alto', 'Crítico');

--12. Calcular el porcentaje de abono realizado sobre cada pedido que aún se encuentra pendiente.
SELECT numero_pedido, monto_pedido, saldo_pedido,
       ((monto_pedido - saldo_pedido) / monto_pedido) * 100 AS porcentaje_amortizado
FROM TABLA_PEDIDOS
WHERE situacion_pedido = 'pendiente';

--13. Obtener el total de dinero recaudado segmentado por entidad de pago bancario.
SELECT entidad_pago, SUM(monto_abonado) AS total_recaudado
FROM TABLA_MOVIMIENTOS
GROUP BY entidad_pago;

--14. Identificar revendedoras que tienen asignada una línea de crédito nueva menor que su línea inicial.
SELECT r.codigo_cliente, c.linea_inicio, ri.linea_credito_nueva
FROM TABLA_REVENDEDORA r
JOIN TABLA_CADASTRO c ON r.codigo_cliente = c.codigo_cliente
JOIN TABLA_RIESGO ri ON r.codigo_cliente = ri.codigo_cliente
WHERE ri.linea_credito_nueva < c.linea_inicio;

--15. Encontrar revendedoras que tengan más de un pedido registrado en situación 'vencido'.
SELECT codigo_cliente, COUNT(*) AS pedidos_vencidos
FROM TABLA_PEDIDOS
WHERE situacion_pedido = 'vencido'
GROUP BY codigo_cliente
HAVING COUNT(*) > 1;

--16. Ranking de revendedoras con mayor facturación (monto_pedido acumulado) utilizando funciones de ventana.
SELECT codigo_cliente, SUM(monto_pedido) AS facturacion_total,
       DENSE_RANK() OVER (ORDER BY SUM(monto_pedido) DESC) AS ranking_ventas
FROM TABLA_PEDIDOS
GROUP BY codigo_cliente;

--17. Determinar el comportamiento temporal: Mostrar el histórico de riesgo agregando el cambio de score frente a la calificación anterior usando LAG().
SELECT codigo_cliente, fecha_calificacion, score_riesgo,
       score_riesgo - LAG(score_riesgo, 1, score_riesgo) OVER (PARTITION BY codigo_cliente ORDER BY fecha_calificacion) AS variacion_score
FROM TABLA_RIESGO;

--18. Encontrar los clientes que ingresaron bajo la modalidad de pago 'credito' pero que nunca han realizado un solo pedido.
SELECT c.codigo_cliente, c.documento
FROM TABLA_CADASTRO c
LEFT JOIN TABLA_PEDIDOS p ON c.codigo_cliente = p.codigo_cliente
WHERE c.modalidad_pago = 'credito' AND p.numero_pedido IS NULL;

--19. Segmentar los montos de pedidos en categorías analíticas de riesgo de saldo mediante un condicional CASE.
SELECT numero_pedido, saldo_pedido,
       CASE 
            WHEN saldo_pedido = 0 THEN 'Sin Riesgo'
            WHEN saldo_pedido BETWEEN 1 AND 500 THEN 'Riesgo Bajo'
            WHEN saldo_pedido BETWEEN 501 AND 1500 THEN 'Riesgo Moderado'
            ELSE 'Riesgo Alto'
       END AS categoria_exposicion
FROM TABLA_PEDIDOS;

--20. Extraer un reporte consolidado utilizando Subconsultas Correlacionadas que muestre el monto del último abono realizado por cada cliente.
SELECT m.codigo_cliente, m.monto_abonado, m.fecha_movimiento
FROM TABLA_MOVIMIENTOS m
WHERE m.fecha_movimiento = (
    SELECT MAX(sub.fecha_movimiento) 
    FROM TABLA_MOVIMIENTOS sub 
    WHERE sub.codigo_cliente = m.codigo_cliente

--Funciones

--21. Vista de Control de Morosidad
CREATE VIEW VW_CONTROL_MOROSIDAD AS
SELECT r.codigo_cliente, r.documento, r.gerencia, p.numero_pedido, p.saldo_pedido, p.dias_atraso
FROM TABLA_REVENDEDORA r
JOIN TABLA_PEDIDOS p ON r.codigo_cliente = p.codigo_cliente
WHERE p.situacion_pedido IN ('pendiente', 'vencido') AND p.saldo_pedido > 0;
GO

--22. Vista de Perfil de Riesgo Consolidado
CREATE VIEW VW_PERFIL_RIESGO_CLIENTE AS
SELECT c.codigo_cliente, c.score_inicio, r.score_riesgo AS score_actual, r.nivel_riesgo, r.linea_credito_nueva
FROM TABLA_CADASTRO c
LEFT JOIN TABLA_RIESGO r ON c.codigo_cliente = r.codigo_cliente;
GO

--23. Vista Resumen de Canales de Recaudación Financiera
CREATE VIEW VW_RESUMEN_BANCOS AS
SELECT entidad_pago, COUNT(*) AS transacciones, SUM(monto_abonado) AS volumen_total
FROM TABLA_MOVIMIENTOS
GROUP BY entidad_pago;
GO

--Funciones

--24. Función Escalar para Calcular el Máximo de Días de Atraso de un Cliente
CREATE FUNCTION FN_MAX_ATRASO_CLIENTE (@codigo_cliente INT)
RETURNS INT
AS
BEGIN
    DECLARE @max_atraso INT;
    SELECT @max_atraso = ISNULL(MAX(dias_atraso), 0) 
    FROM TABLA_PEDIDOS 
    WHERE codigo_cliente = @codigo_cliente;
    RETURN @max_atraso;
END;
GO

--25. Función Escalar para Evaluar Capacidad de Compra Disponible
CREATE FUNCTION FN_CREDITO_DISPONIBLE (@codigo_cliente INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @linea_actual DECIMAL(10,2);
    DECLARE @deuda_actual DECIMAL(10,2);
    
    -- Tomamos la última línea de crédito asignada o la inicial si no tiene reevaluación
    SELECT @linea_actual = ISNULL(
        (SELECT TOP 1 linea_credito_nueva FROM TABLA_RIESGO WHERE codigo_cliente = @codigo_cliente ORDER BY fecha_calificacion DESC),
        (SELECT linea_inicio FROM TABLA_CADASTRO WHERE codigo_cliente = @codigo_cliente)
    );
    
    SELECT @deuda_actual = ISNULL(SUM(saldo_pedido), 0) FROM TABLA_PEDIDOS WHERE codigo_cliente = @codigo_cliente;
    
    RETURN (@linea_actual - @deuda_actual);
END;
GO

--26. Función de Tabla: Historial Operativo Completo por Cliente
CREATE FUNCTION FN_REPORTE_CLIENTE (@codigo_cliente INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.numero_pedido, p.monto_pedido, p.saldo_pedido, p.situacion_pedido, p.fecha_vencimiento
    FROM TABLA_PEDIDOS p
    WHERE p.codigo_cliente = @codigo_cliente
);
GO

--Procedimientos Almacenado

--27. SP para Registrar un Pago Amortizando el Saldo del Pedido
CREATE PROCEDURE SP_REGISTRAR_PAGO
    @codigo_cliente INT,
    @monto_pago DECIMAL(10,2),
    @numero_pedido VARCHAR(20),
    @banco VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION
    BEGIN TRY
        -- Insertar movimiento
        INSERT INTO TABLA_MOVIMIENTOS (codigo_cliente, monto_abonado, pedido_receptor, fecha_movimiento, entidad_pago)
        VALUES (@codigo_cliente, @monto_pago, @numero_pedido, GETDATE(), @banco);
        
        -- Actualizar saldo en pedidos
        UPDATE TABLA_PEDIDOS
        SET saldo_pedido = saldo_pedido - @monto_pago
        WHERE numero_pedido = @numero_pedido;
        
        -- Cambiar estado si se canceló en su totalidad
        UPDATE TABLA_PEDIDOS
        SET situacion_pedido = 'pagado', dias_atraso = 0
        WHERE numero_pedido = @numero_pedido AND saldo_pedido <= 0;
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

--28. SP de Evaluación Automática para Castigo de Línea por Mora Vencida
CREATE PROCEDURE SP_CALIFICAR_RIESGO_MORA
    @codigo_cliente INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @dias_mora INT = dbo.FN_MAX_ATRASO_CLIENTE(@codigo_cliente);
    
    IF @dias_mora > 60
    BEGIN
        INSERT INTO TABLA_RIESGO (codigo_cliente, nivel_riesgo, score_riesgo, linea_credito_nueva, fecha_calificacion)
        VALUES (@codigo_cliente, 'Crítico', 100, 0.00, GETDATE());
        
        UPDATE TABLA_REVENDEDORA SET Estado = 'Sin_pedido3' WHERE codigo_cliente = @codigo_cliente;
    END
    ELSE IF @dias_mora > 30
    BEGIN
        INSERT INTO TABLA_RIESGO (codigo_cliente, nivel_riesgo, score_riesgo, linea_credito_nueva, fecha_calificacion)
        VALUES (@codigo_cliente, 'Alto', 300, 500.00, GETDATE());
    END
END;
GO

--29. SP de Inserción Controlada de Nuevas Consultoras (Cadastro Seguro)
CREATE PROCEDURE SP_NUEVO_CADASTRO
    @id INT, @doc VARCHAR(20), @tipo VARCHAR(20), @linea DECIMAL(10,2), @distrito VARCHAR(50), @provincia VARCHAR(50), @buro VARCHAR(5), @fraude VARCHAR(10), @score INT
AS
BEGIN
    IF @fraude = 'Alto' OR @buro = 'R4'
    BEGIN
        INSERT INTO TABLA_CADASTRO VALUES (@id, @doc, GETDATE(), 'rechazo', 0.00, @distrito, @provincia, @buro, @fraude, @score);
    END
    ELSE
    BEGIN
        INSERT INTO TABLA_CADASTRO VALUES (@id, @doc, GETDATE(), @tipo, @linea, @distrito, @provincia, @buro, @fraude, @score);
        -- Se genera alta automática en revendedora activa
        INSERT INTO TABLA_REVENDEDORA VALUES (@id, @doc, 1, GETDATE(), 1, 'A', 1, 'Activa');
    END
END;
GO

--30. SP para Depurar y Automatizar la Actualización Diaria de Días de Atraso
CREATE PROCEDURE SP_BATCH_ACTUALIZAR_MORA
AS
BEGIN
    SET NOCOUNT ON;
    -- Incrementar días de atraso para pedidos vencidos no pagados
    UPDATE TABLA_PEDIDOS
    SET dias_atraso = DATEDIFF(DAY, fecha_vencimiento, GETDATE()),
        situacion_pedido = 'vencido'
    WHERE GETDATE() > fecha_vencimiento AND situacion_pedido IN ('pendiente', 'vencido') AND saldo_pedido > 0;
END;
GO

