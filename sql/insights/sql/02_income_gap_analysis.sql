/*
Project: Income Gap Analysis – Uzbekistan
Data source: Stat.uz
Author: Erkinjon

Goal:
Measure disparity between the highest-income and lowest-income regions.
*/

;WITH base AS (
    SELECT
        region,
        CAST(income_pc AS FLOAT) AS income_pc
    FROM dbo.vw_income_mart
    WHERE income_pc IS NOT NULL
),
agg AS (
    SELECT
        region,
        AVG(income_pc) AS avg_income
    FROM base
    GROUP BY region
),
ranked AS (
    SELECT
        region,
        avg_income,
        ROW_NUMBER() OVER (ORDER BY avg_income DESC) AS rn_desc,
        ROW_NUMBER() OVER (ORDER BY avg_income ASC)  AS rn_asc
    FROM agg
),
top_region AS (
    SELECT region, avg_income
    FROM ranked
    WHERE rn_desc = 1
),
bottom_region AS (
    SELECT region, avg_income
    FROM ranked
    WHERE rn_asc = 1
)
SELECT
    t.region  AS Top_region,
    t.avg_income AS Top_avg_income,
    b.region  AS Bottom_region,
    b.avg_income AS Bottom_avg_income,
    (t.avg_income - b.avg_income) AS Absolute_gap,
    (t.avg_income / NULLIF(b.avg_income, 0)) AS Ratio_gap
FROM top_region t
CROSS JOIN bottom_region b;
