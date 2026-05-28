/*
Project: Income Drivers Correlation – Uzbekistan
Data source: Stat.uz
Author: Sarvar Erkinjonov 

Goal:
Assess the relationship between income per capita and key economic sectors.
*/

;WITH income AS (
    SELECT
        region,
        AVG(CAST(income_pc AS FLOAT)) AS avg_income
    FROM dbo.vw_income_mart
    WHERE income_pc IS NOT NULL
    GROUP BY region
),
industry AS (
    SELECT
        region,
        AVG(CAST(industry_output AS FLOAT)) AS avg_industry
    FROM dbo.fact_industry
    WHERE industry_output IS NOT NULL
    GROUP BY region
),
business AS (
    SELECT
        region,
        AVG(CAST(business_activity AS FLOAT)) AS avg_business
    FROM dbo.fact_business
    WHERE business_activity IS NOT NULL
    GROUP BY region
),
agriculture AS (
    SELECT
        region,
        AVG(CAST(agriculture_output AS FLOAT)) AS avg_agriculture
    FROM dbo.fact_agriculture
    WHERE agriculture_output IS NOT NULL
    GROUP BY region
),
combined AS (
    SELECT
        i.region,
        i.avg_income,
        ind.avg_industry,
        b.avg_business,
        a.avg_agriculture
    FROM income i
    LEFT JOIN industry ind ON i.region = ind.region
    LEFT JOIN business b  ON i.region = b.region
    LEFT JOIN agriculture a ON i.region = a.region
)

SELECT
    COUNT(*) AS regions_count,
    CORR(avg_income, avg_industry)    AS corr_income_industry,
    CORR(avg_income, avg_business)    AS corr_income_business,
    CORR(avg_income, avg_agriculture) AS corr_income_agriculture
FROM combined
WHERE avg_income IS NOT NULL;
