USE MicrofinanceDB

--crear la base analítica vintage
IF OBJECT_ID('dbo.base_vintage', 'V') IS NOT NULL
    DROP VIEW dbo.base_vintage;
GO

CREATE VIEW dbo.base_vintage AS
SELECT
    c.id_credito,
    c.id_cliente,
    c.fecha_desembolso,
    DATEFROMPARTS(YEAR(c.fecha_desembolso), MONTH(c.fecha_desembolso), 1) AS cohorte_desembolso,
    cu.id_cuota,
    cu.nro_cuota,
    cu.fecha_vencimiento,
    DATEDIFF(MONTH, c.fecha_desembolso, cu.fecha_vencimiento) AS loan_age,
    cu.monto_capital,
    cu.monto_interes,
    cu.monto_total,
    cu.estado,
    CASE WHEN cu.estado = 'VENCIDO' THEN 1 ELSE 0 END AS flag_mora,
    CASE WHEN cu.estado = 'PAGADO' THEN 1 ELSE 0 END AS flag_pagado,
    CASE WHEN cu.estado = 'PENDIENTE' THEN 1 ELSE 0 END AS flag_pendiente
FROM Negocio.creditos c
INNER JOIN Negocio.cuotas cu
    ON c.id_credito = cu.id_credito;
GO

SELECT TOP 20 *
FROM dbo.base_vintage
ORDER BY cohorte_desembolso, id_credito, loan_age;

--Enriquecer con producto, asesor, agencia y zona

IF OBJECT_ID('dbo.base_vintage_detalle', 'V') IS NOT NULL
    DROP VIEW dbo.base_vintage_detalle;
GO

CREATE VIEW dbo.base_vintage_detalle AS
SELECT
    bv.id_credito,
    bv.id_cliente,
    bv.fecha_desembolso,
    bv.cohorte_desembolso,
    bv.id_cuota,
    bv.nro_cuota,
    bv.fecha_vencimiento,
    bv.loan_age,
    bv.monto_capital,
    bv.monto_interes,
    bv.monto_total,
    bv.estado,
    bv.flag_mora,
    bv.flag_pagado,
    bv.flag_pendiente,
    p.id_producto,
    p.nombre AS producto,
    p.tipo_producto,
    s.id_asesor,
    e.nombre + ' ' + e.apellidos AS asesor,
    a.id_agencia,
    a.nombre AS agencia,
    z.id_zona,
    z.nombre AS zona,
    z.region,
    cl.genero,
    cl.ingreso_mensual
FROM dbo.base_vintage bv
INNER JOIN Negocio.creditos c
    ON bv.id_credito = c.id_credito
INNER JOIN Negocio.solicitudes s
    ON c.id_solicitud = s.id_solicitud
INNER JOIN Productos.catalogo p
    ON s.id_producto = p.id_producto
INNER JOIN Personal.empleados e
    ON s.id_asesor = e.id_empleado
INNER JOIN Infra.agencias a
    ON e.id_agencia = a.id_agencia
INNER JOIN Infra.zonas z
    ON a.id_zona = z.id_zona
INNER JOIN Clientes.clientes cl
    ON bv.id_cliente = cl.id_cliente;
GO

SELECT TOP 20 *
FROM dbo.base_vintage_detalle