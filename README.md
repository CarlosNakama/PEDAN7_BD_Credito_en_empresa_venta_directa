Caso Propuesto :Empresa de Venta Directa – Análisis Crediticio de Revendedoras
Nombre de la empresa : Comercial NovaBelle S.A.C.
* Giro del negocio
Comercial NovaBelle S.A.C. es una empresa ficticia dedicada a la comercialización de productos de belleza, cuidado personal, hogar y accesorios mediante el modelo de venta directa por catálogo.
La empresa trabaja con miles de revendedoras independientes, quienes realizan pedidos periódicos y venden los productos a clientes finales en distintas ciudades del país.
________________________________________
*Contexto del problema
Actualmente, la empresa presenta dificultades para controlar el nivel de riesgo financiero de sus revendedoras.
El proceso de evaluación crediticia se realiza de manera manual y descentralizada, lo que genera problemas como:
•	Aprobaciones de crédito sin sustento suficiente.
•	Revendedoras con deudas vencidas que continúan realizando pedidos.
•	Falta de historial consolidado de pagos.
•	Retrasos en la cobranza.
•	Incremento de morosidad.
•	Información duplicada o inconsistente.
La gerencia desea implementar un Sistema de Gestión y Análisis Crediticio que permita:
•	Registrar revendedoras y su información personal.
•	Evaluar el perfil crediticio de cada revendedora.
•	Asignar líneas de crédito.
•	Registrar pedidos y pagos.
•	Controlar cuotas y vencimientos.
•	Clasificar el riesgo crediticio.
•	Generar reportes para la toma de decisiones.
________________________________________
Objetivo del sistema
Diseñar una base de datos que permita administrar de manera eficiente la información relacionada con:
•	Revendedoras.
•	Campañas de venta.
•	Pedidos.
•	Créditos.
•	Pagos.
•	Evaluaciones crediticias.
•	Historial financiero.
•	Estados de cobranza.
El sistema deberá facilitar el análisis de riesgo y mejorar el control financiero de la empresa.
________________________________________
Descripción del negocio
Registro de revendedoras
Cuando una persona desea convertirse en revendedora, la empresa registra información como:
•	DNI
•	Nombres y apellidos
•	Fecha de nacimiento
•	Dirección
•	Teléfono
•	Correo electrónico
•	Distrito y ciudad
•	Fecha de afiliación
•	Estado de la revendedora
Además, se registra información financiera básica:
•	Ingresos mensuales aproximados
•	Ocupación
•	Referencias personales
•	Historial crediticio interno
________________________________________
Evaluación crediticia
Antes de aprobar compras al crédito, el área financiera realiza una evaluación considerando:
•	Antigüedad como revendedora
•	Nivel de ventas
•	Historial de pagos
•	Número de atrasos
•	Deuda vigente
•	Score crediticio
•	Capacidad de pago
Como resultado de la evaluación:
•	Se aprueba o rechaza el crédito.
•	Se asigna una línea de crédito.
•	Se define una clasificación de riesgo:
o	Bajo
o	Medio
o	Alto
Cada evaluación debe quedar registrada con:
•	Fecha de evaluación
•	Analista responsable
•	Puntaje obtenido
•	Observaciones
•	Resultado final
________________________________________
Gestión de campañas
La empresa trabaja por campañas mensuales o quincenales.
Cada campaña tiene:
•	Código
•	Nombre
•	Fecha de inicio
•	Fecha de fin
•	Estado
Las revendedoras realizan pedidos dentro de una campaña específica.
________________________________________
Registro de pedidos
Las revendedoras pueden realizar uno o varios pedidos por campaña.
Cada pedido contiene:
•	Fecha del pedido
•	Monto total
•	Estado del pedido
•	Tipo de pago:
o	Contado
o	Crédito
Un pedido puede incluir varios productos.
________________________________________
Productos
La empresa comercializa diferentes categorías:
•	Cosméticos
•	Perfumes
•	Cuidado personal
•	Accesorios
•	Hogar
De cada producto se registra:
•	Código
•	Nombre
•	Categoría
•	Precio
•	Stock
•	Estado
________________________________________
Créditos y financiamiento
Cuando un pedido es aprobado al crédito:
•	Se genera un crédito asociado al pedido.
•	El crédito puede pagarse en cuotas.
•	Se establece:
o	Monto financiado
o	Número de cuotas
o	Tasa de interés
o	Fecha de vencimiento
________________________________________
Pagos
Las revendedoras realizan pagos parciales o completos.
Cada pago registra:
•	Fecha
•	Monto pagado
•	Medio de pago
•	Número de operación
•	Estado del pago
El sistema debe permitir conocer:
•	Saldo pendiente
•	Cuotas vencidas
•	Historial de pagos
•	Nivel de morosidad
________________________________________
Cobranza
Cuando existen retrasos:
•	Se generan acciones de cobranza.
•	Se registran llamadas, mensajes o visitas.
•	Se actualiza el estado de recuperación de deuda.
________________________________________
Reglas de negocio
1.	Una revendedora puede tener muchos pedidos.
2.	Un pedido pertenece a una sola campaña.
3.	Un pedido puede pagarse al contado o al crédito.
4.	Solo las revendedoras aprobadas pueden acceder a crédito.
5.	Una evaluación crediticia pertenece a una sola revendedora.
6.	Un crédito se genera únicamente para pedidos aprobados al crédito.
7.	Un crédito puede tener varias cuotas.
8.	Una cuota puede recibir varios pagos parciales.
9.	Una revendedora no puede exceder su línea de crédito disponible.
10.	Una revendedora con morosidad alta puede ser bloqueada temporalmente.
11.	Un producto puede aparecer en muchos pedidos.
12.	Cada pedido debe contener al menos un producto.
