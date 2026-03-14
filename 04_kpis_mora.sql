USE MicrofinanceDB



-- KPI 1: total cartera en cuotas
SELECT
    SUM(monto_total) AS cartera_total_cuotas
FROM dbo.base_vintage_detalle;

-- KPI 2: monto vencido
SELECT
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido
FROM dbo.base_vintage_detalle;

-- KPI 3: porcentaje de monto vencido
SELECT
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_monto_vencido
FROM dbo.base_vintage_detalle;

-- KPI 4: porcentaje de cuotas vencidas
SELECT
    CAST(SUM(CASE WHEN flag_mora = 1 THEN 1 ELSE 0 END) * 100.0
         / NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS pct_cuotas_vencidas
FROM dbo.base_vintage_detalle;


-- KPI 5: porcentaje de créditos con al menos una cuota vencida
SELECT
    COUNT(DISTINCT CASE WHEN flag_mora = 1 THEN id_credito END) AS creditos_con_mora,
    COUNT(DISTINCT id_credito) AS creditos_totales,
    CAST(
        COUNT(DISTINCT CASE WHEN flag_mora = 1 THEN id_credito END) * 100.0
        / NULLIF(COUNT(DISTINCT id_credito), 0)
        AS DECIMAL(10,2)
    ) AS pct_creditos_con_mora
FROM dbo.base_vintage_detalle;


-- KPI 6: mora por producto
SELECT
    producto,
    SUM(monto_total) AS monto_total,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_mora
FROM dbo.base_vintage_detalle
GROUP BY producto
ORDER BY pct_mora DESC;

-- KPI 7: mora por zona
SELECT
    zona,
    region,
    SUM(monto_total) AS monto_total,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_mora
FROM dbo.base_vintage_detalle
GROUP BY zona, region
ORDER BY pct_mora DESC;

-- KPI 8: mora por asesor
SELECT
    asesor,
    SUM(monto_total) AS monto_total,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_mora
FROM dbo.base_vintage_detalle
GROUP BY asesor
ORDER BY pct_mora DESC;