/*
Project: Regional Income Segmentation – Uzbekistan
Data source: Stat.uz (via your marts/views)
Author: Sarvar Erkinjonov 
Goal:
1) Identify regions with stronger/weaker income per capita levels
2) Segment regions into quartiles (Q1–Q4) by average income
Notes:
- This script assumes vw_income_mart contains: region, income_pc
- If your table also has a year column, you can extend to region-year segmentation (optional)
*/

-- ==========================================
-- 0) Basic data quality check (optional)
-- ==========================================
-- How many rows are usable?
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN income_pc IS NULL THEN 1 ELSE 0 END) AS null_income_rows
FROM dbo.vw_income_mart;

-- ==========================================
-- 1) Region income profile (strength overview)
-- ==========================================
-- Purpose: compare regions by avg income, see min/max and sample size
SELECT
    region AS Viloyat,
    AVG(CAST(income_pc AS FLOAT)) AS Ortacha_daromad,
    MIN(CAST(income_pc AS FLOAT)) AS Eng_past,
    MAX(CAST(income_pc AS FLOAT)) AS Eng_yuqori,
    COUNT(*) AS Kuzatuv_soni
FROM dbo.vw_income_mart
WHERE income_pc IS NOT NULL
GROUP BY region
ORDER BY Ortacha_daromad DESC;

-- ==========================================
-- 2) Income quartile segmentation (Q1–Q4)
-- ==========================================
-- IMPORTANT:
-- In the original version you used SELECT DISTINCT in base.
-- DISTINCT can accidentally drop valid rows and distort averages.
-- Here we avoid DISTINCT and aggregate directly.

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
seg AS (
    SELECT
        region,
        avg_income,
        NTILE(4) OVER (ORDER BY avg_income) AS quartile
    FROM agg
)
SELECT
    region AS Viloyat,
    avg_income AS Ortacha_daromad,
    CASE quartile
        WHEN 1 THEN 'Q1: Past 25%'
        WHEN 2 THEN 'Q2: Ortadan past'
        WHEN 3 THEN 'Q3: Ortadan yuqori'
        WHEN 4 THEN 'Q4: Yuqori 25%'
    END AS Segment
FROM seg
ORDER BY avg_income DESC;

-- ==========================================
-- 3) Segment summary (how many regions in each quartile)
-- ==========================================
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
seg AS (
    SELECT
        region,
        avg_income,
        NTILE(4) OVER (ORDER BY avg_income) AS quartile
    FROM agg
)
SELECT
    CASE quartile
        WHEN 1 THEN 'Q1: Past 25%'
        WHEN 2 THEN 'Q2: Ortadan past'
        WHEN 3 THEN 'Q3: Ortadan yuqori'
        WHEN 4 THEN 'Q4: Yuqori 25%'
    END AS Segment,
    COUNT(*) AS Regions_count,
    AVG(avg_income) AS Segment_avg_income
FROM seg
GROUP BY quartile
ORDER BY quartile;
