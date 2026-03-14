USE MicrofinanceDB

--Crear una tabla lista para construir la matriz vintage en Power BI.
IF OBJECT_ID('dbo.pbi_vintage_matrix', 'V') IS NOT NULL
    DROP VIEW dbo.pbi_vintage_matrix;
GO

CREATE VIEW dbo.pbi_vintage_matrix AS
SELECT
    cohorte_desembolso,
    loan_age,
    pct_monto_vencido,
    pct_cuotas_vencidas,
    monto_vencido,
    monto_total_cuotas,
    cuotas_vencidas,
    cuotas_totales
FROM dbo.vintage_resumen;
GO

--Analizar riesgo por tipo de producto financiero.
IF OBJECT_ID('dbo.pbi_mora_producto', 'V') IS NOT NULL
    DROP VIEW dbo.pbi_mora_producto;
GO

CREATE VIEW dbo.pbi_mora_producto AS
SELECT
    producto,
    SUM(monto_total) AS monto_total,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_mora
FROM dbo.base_vintage_detalle
GROUP BY producto;
GO

--Analizar riesgo geográfico
IF OBJECT_ID('dbo.pbi_mora_zona', 'V') IS NOT NULL
    DROP VIEW dbo.pbi_mora_zona;
GO

CREATE VIEW dbo.pbi_mora_zona AS
SELECT
    zona,
    region,
    SUM(monto_total) AS monto_total,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_mora
FROM dbo.base_vintage_detalle
GROUP BY zona, region;
GO

--Analizar calidad de cartera por asesor de crédito.
IF OBJECT_ID('dbo.pbi_mora_asesor', 'V') IS NOT NULL
    DROP VIEW dbo.pbi_mora_asesor;
GO

CREATE VIEW dbo.pbi_mora_asesor AS
SELECT
    asesor,
    agencia,
    zona,
    SUM(monto_total) AS monto_total,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_mora
FROM dbo.base_vintage_detalle
GROUP BY asesor, agencia, zona;
GO

--Total de credito por cohorte
IF OBJECT_ID('dbo.pbi_mora_cohorte', 'V') IS NOT NULL
DROP VIEW dbo.pbi_mora_cohorte;
GO

CREATE VIEW dbo.pbi_mora_cohorte AS
SELECT
    cohorte_desembolso,

    COUNT(DISTINCT id_credito) AS creditos_total,

    SUM(monto_total) AS monto_total,

    SUM(CASE WHEN flag_mora = 1 
        THEN monto_total ELSE 0 END) AS monto_vencido,

    CAST(
        SUM(CASE WHEN flag_mora = 1 
            THEN monto_total ELSE 0 END) * 100.0
        /
        NULLIF(SUM(monto_total),0)
    AS DECIMAL(10,2)) AS pct_mora

FROM dbo.base_vintage_detalle

GROUP BY cohorte_desembolso;
GO




--QUERY EXTRA
--detecta créditos que tuvieron al menos una cuota vencida.
SELECT
    cohorte_desembolso,
    COUNT(DISTINCT id_credito) AS creditos_total,
    COUNT(DISTINCT CASE WHEN flag_mora = 1 THEN id_credito END) AS creditos_con_mora,
    CAST(COUNT(DISTINCT CASE WHEN flag_mora = 1 THEN id_credito END) * 100.0
         / NULLIF(COUNT(DISTINCT id_credito), 0) AS DECIMAL(10,2)) AS pct_creditos_con_mora
FROM dbo.base_vintage_detalle
GROUP BY cohorte_desembolso
ORDER BY cohorte_desembolso;