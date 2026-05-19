CREATE TABLE revendedoras (
    id INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(20) NOT NULL,
    nombres_apellidos VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    distrito_ciudad VARCHAR(100) NOT NULL,
    fecha_afiliacion DATE NOT NULL,
    ingresos_mensuales DECIMAL(18,2) NOT NULL CHECK (ingresos_mensuales >= 0),
    ocupacion VARCHAR(100) NOT NULL,
    referencias_personales VARCHAR(255) NULL,
    historial_crediticio VARCHAR(255) NULL,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Activa', 'Bloqueada', 'Inactiva')),
    
    CONSTRAINT UQ_revendedoras_dni UNIQUE (dni),
    CONSTRAINT CK_revendedoras_edad CHECK (DATEDIFF(year, fecha_nacimiento, fecha_afiliacion) >= 18)
);

CREATE TABLE evaluaciones_crediticias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    revendedora_id INT NOT NULL,
    fecha_evaluacion DATETIME NOT NULL,
    score_crediticio DECIMAL(5,2) NOT NULL CHECK (score_crediticio BETWEEN 0 AND 100), 
    linea_credito_asignada DECIMAL(18,2) NOT NULL CHECK (linea_credito_asignada >= 0),
    clasificacion_riesgo VARCHAR(50) NOT NULL CHECK (clasificacion_riesgo IN ('Bajo', 'Medio', 'Alto')),
    resultado_final VARCHAR(50) NOT NULL CHECK (resultado_final IN ('Aprobado', 'Rechazado')),
    analista_responsable VARCHAR(100) NOT NULL,
    observaciones VARCHAR(500) NULL,
    
    CONSTRAINT FK_evaluaciones_revendedoras FOREIGN KEY (revendedora_id) REFERENCES revendedoras(id)
);

CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    revendedora_id INT NOT NULL,
    campana_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    monto_total DECIMAL(18,2) NOT NULL CHECK (monto_total > 0),
    tipo_pago VARCHAR(50) NOT NULL CHECK (tipo_pago IN ('Contado', 'Crédito')),
    estado_pedido VARCHAR(50) NOT NULL CHECK (estado_pedido IN ('Pendiente', 'Aprobado', 'Entregado')),
    
    CONSTRAINT FK_pedidos_revendedoras FOREIGN KEY (revendedora_id) REFERENCES revendedoras(id)
);

CREATE TABLE detalle_pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(18,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(18,2) NOT NULL CHECK (subtotal >= 0),
    
    CONSTRAINT FK_detalle_pedidos_pedidos FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
);

CREATE TABLE creditos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL,
    monto_financiado DECIMAL(18,2) NOT NULL CHECK (monto_financiado > 0),
    numero_cuotas INT NOT NULL CHECK (numero_cuotas > 0),
    tasa_interes DECIMAL(5,2) NOT NULL CHECK (tasa_interes >= 0),
    fecha_vencimiento DATE NOT NULL,
    saldo_pendiente DECIMAL(18,2) NOT NULL CHECK (saldo_pendiente >= 0),
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Vigente', 'Pagado', 'Atrasado')),
    
    CONSTRAINT FK_creditos_pedidos FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    CONSTRAINT CK_creditos_saldos CHECK (saldo_pendiente <= monto_financiado)
);

CREATE TABLE cuotas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    credito_id INT NOT NULL,
    numero_cuota INT NOT NULL CHECK (numero_cuota > 0),
    fecha_vencimiento DATE NOT NULL,
    monto_cuota DECIMAL(18,2) NOT NULL CHECK (monto_cuota > 0),
    capital DECIMAL(18,2) NOT NULL CHECK (capital >= 0),
    intereses DECIMAL(18,2) NOT NULL CHECK (intereses >= 0),
    saldo_cuota DECIMAL(18,2) NOT NULL CHECK (saldo_cuota >= 0),
    estado_pago VARCHAR(50) NOT NULL CHECK (estado_pago IN ('Pendiente', 'Pagada', 'Vencida')),
    
    CONSTRAINT FK_cuotas_creditos FOREIGN KEY (credito_id) REFERENCES creditos(id),
    CONSTRAINT CK_cuotas_componentes CHECK (monto_cuota = (capital + intereses))
);

CREATE TABLE pagos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    credito_id INT NOT NULL,
    fecha_pago DATETIME NOT NULL,
    monto_pagado DECIMAL(18,2) NOT NULL CHECK (monto_pagado > 0),
    medio_pago VARCHAR(50) NOT NULL CHECK (medio_pago IN ('Efectivo', 'Transferencia', 'Tarjeta', 'Billetera Digital')),
    numero_operacion VARCHAR(100) NOT NULL,
    estado_pago VARCHAR(50) NOT NULL CHECK (estado_pago IN ('Aplicado', 'Extornado', 'En Proceso')),
    
    CONSTRAINT UQ_pagos_operacion UNIQUE (numero_operacion),
    CONSTRAINT FK_pagos_creditos FOREIGN KEY (credito_id) REFERENCES creditos(id)
);