/*
Project: Sector Structure Analysis – Uzbekistan
Data source: Stat.uz
Author: Sarvar Erkinjonov 

Goal:
Analyze the contribution of major economic sectors by region.
*/

-- ======================================
-- 1) Combine sector indicators
-- ======================================

;WITH sectors AS (
    SELECT
        region,
        'Industry' AS sector,
        CAST(industry_output AS FLOAT) AS value
    FROM dbo.fact_industry
    WHERE industry_output IS NOT NULL

    UNION ALL

    SELECT
        region,
        'Agriculture' AS sector,
        CAST(agriculture_output AS FLOAT) AS value
    FROM dbo.fact_agriculture
    WHERE agriculture_output IS NOT NULL

    UNION ALL

    SELECT
        region,
        'Business' AS sector,
        CAST(business_activity AS FLOAT) AS value
    FROM dbo.fact_business
    WHERE business_activity IS NOT NULL
),

-- ======================================
-- 2) Sector share by region
-- ======================================

sector_share AS (
    SELECT
        region,
        sector,
        value,
        SUM(value) OVER (PARTITION BY region) AS total_value
    FROM sectors
)

SELECT
    region,
    sector,
    value,
    total_value,
    ROUND(value / NULLIF(total_value, 0) * 100, 2) AS sector_share_pct
FROM sector_share
ORDER BY region, sector_share_pct DESC;
