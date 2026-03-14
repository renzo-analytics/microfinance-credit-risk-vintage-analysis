USE MicrofinanceDB


IF OBJECT_ID('dbo.vintage_resumen', 'V') IS NOT NULL
    DROP VIEW dbo.vintage_resumen;
GO

CREATE VIEW dbo.vintage_resumen AS
SELECT
    cohorte_desembolso,
    loan_age,
    COUNT(DISTINCT id_credito) AS creditos_total,
    SUM(monto_total) AS monto_total_cuotas,
    SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) AS monto_vencido,
    SUM(CASE WHEN flag_mora = 1 THEN 1 ELSE 0 END) AS cuotas_vencidas,
    COUNT(*) AS cuotas_totales,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN monto_total ELSE 0 END) * 100.0 
         / NULLIF(SUM(monto_total), 0) AS DECIMAL(10,2)) AS pct_monto_vencido,
    CAST(SUM(CASE WHEN flag_mora = 1 THEN 1 ELSE 0 END) * 100.0 
         / NULLIF(COUNT(*), 0) AS DECIMAL(10,2)) AS pct_cuotas_vencidas
FROM dbo.base_vintage_detalle
GROUP BY
    cohorte_desembolso,
    loan_age;
GO

SELECT *
FROM dbo.vintage_resumen
ORDER BY cohorte_desembolso, loan_age;