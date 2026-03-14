USE MicrofinanceDB


SELECT COUNT(*) AS total_clientes
FROM Clientes.clientes;

SELECT COUNT(*) AS total_creditos
FROM Negocio.creditos;

SELECT COUNT(*) AS total_cuotas
FROM Negocio.cuotas;

SELECT COUNT(*) AS total_pagos
FROM Negocio.pagos;

SELECT 
    MIN(fecha_desembolso) AS min_desembolso,
    MAX(fecha_desembolso) AS max_desembolso
FROM Negocio.creditos;

SELECT 
    estado,
    COUNT(*) AS total_cuotas
FROM Negocio.cuotas
GROUP BY estado
ORDER BY total_cuotas DESC;


