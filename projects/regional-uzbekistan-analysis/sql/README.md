# SQL Analysis — Regional Economic Analysis of Uzbekistan

## Overview

4 ta SQL query yordamida O'zbekiston 14 ta hududining iqtisodiy ko'rsatkichlari tahlil qilindi.
Ma'lumot manbai: **[Stat.uz](https://stat.uz)** | Davr: **2010–2024** | Hudud: **14 ta viloyat**

---

## 📋 Queries

| # | Fayl | Maqsad |
|---|------|--------|
| 1 | `01_income_segmentation.sql` | Hududlarni Q1–Q4 daromad kvartillariga bo'lish |
| 2 | `02_income_gap_analysis.sql` | Eng boy va eng kambag'al hudud o'rtasidagi farq |
| 3 | `03_sector_structure_analysis.sql` | Har bir hududdagi sektor ulushi (%) |
| 4 | `04_drivers_correlation.sql` | Daromadga ta'sir qiluvchi omillar korrelyatsiyasi |

---

## 1️⃣ Income Segmentation — `01_income_segmentation.sql`

**Savol:** Qaysi hududlar yuqori / past daromad darajasida?

**Metod:** `NTILE(4)` window function → Q1 (eng past) dan Q4 (eng yuqori) gacha segmentatsiya

```sql
/*
Project: Regional Income Segmentation – Uzbekistan
Data source: Stat.uz (via your marts/views)
Author: Sarvar Erkinjonov
Goal:
1) Identify regions with stronger/weaker income per capita levels
2) Segment regions into quartiles (Q1–Q4) by average income
*/

-- ==========================================
-- 0) Basic data quality check
-- ==========================================
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN income_pc IS NULL THEN 1 ELSE 0 END) AS null_income_rows
FROM dbo.vw_income_mart;

-- ==========================================
-- 1) Region income profile
-- ==========================================
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
-- 3) Segment summary
-- ==========================================
;WITH base AS (
    SELECT region, CAST(income_pc AS FLOAT) AS income_pc
    FROM dbo.vw_income_mart WHERE income_pc IS NOT NULL
),
agg AS (
    SELECT region, AVG(income_pc) AS avg_income FROM base GROUP BY region
),
seg AS (
    SELECT region, avg_income, NTILE(4) OVER (ORDER BY avg_income) AS quartile FROM agg
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
```

### 📊 Natijalar

| Segment | Hudud | O'rtacha daromad (mln UZS) |
|---------|-------|---------------------------|
| **Q4 — Yuqori 25%** | Toshkent sh. | 34.18 |
| **Q4 — Yuqori 25%** | Navoiy | 14.92 |
| **Q4 — Yuqori 25%** | Toshkent vil. | 13.87 |
| **Q3 — Ortadan yuqori** | Buxoro | 11.64 |
| **Q3 — Ortadan yuqori** | Qashqadaryo | 10.98 |
| **Q3 — Ortadan yuqori** | Jizzax | 9.73 |
| **Q2 — Ortadan past** | Samarqand | 9.21 |
| **Q2 — Ortadan past** | Sirdaryo | 8.95 |
| **Q2 — Ortadan past** | Farg'ona | 8.84 |
| **Q1 — Past 25%** | Andijon | 8.12 |
| **Q1 — Past 25%** | Namangan | 7.88 |
| **Q1 — Past 25%** | Xorazm | 7.45 |
| **Q1 — Past 25%** | Surxondaryo | 7.02 |
| **Q1 — Past 25%** | Qoraqalpog'iston | 6.31 |

> 💡 **Insight:** Q4 o'rtacha daromadi Q1 dan **~5.4x yuqori** — sezilarli hududiy tengsizlik mavjud.

📄 [To'liq insight →](../insights/01_income_segmentation.md)

---

## 2️⃣ Income Gap Analysis — `02_income_gap_analysis.sql`

**Savol:** Eng boy va eng kambag'al hudud o'rtasidagi farq qanchaga yetdi?

**Metod:** `ROW_NUMBER()` → top va bottom hududni aniqlash → absolyut va nisbiy farq hisoblash

```sql
/*
Project: Income Gap Analysis – Uzbekistan
Data source: Stat.uz
Author: Sarvar Erkinjonov
Goal: Measure disparity between the highest-income and lowest-income regions.
*/

;WITH base AS (
    SELECT
        region,
        CAST(income_pc AS FLOAT) AS income_pc
    FROM dbo.vw_income_mart
    WHERE income_pc IS NOT NULL
),
agg AS (
    SELECT region, AVG(income_pc) AS avg_income
    FROM base GROUP BY region
),
ranked AS (
    SELECT
        region,
        avg_income,
        ROW_NUMBER() OVER (ORDER BY avg_income DESC) AS rn_desc,
        ROW_NUMBER() OVER (ORDER BY avg_income ASC)  AS rn_asc
    FROM agg
),
top_region    AS (SELECT region, avg_income FROM ranked WHERE rn_desc = 1),
bottom_region AS (SELECT region, avg_income FROM ranked WHERE rn_asc  = 1)
SELECT
    t.region       AS Top_region,
    t.avg_income   AS Top_avg_income,
    b.region       AS Bottom_region,
    b.avg_income   AS Bottom_avg_income,
    (t.avg_income - b.avg_income)              AS Absolute_gap,
    (t.avg_income / NULLIF(b.avg_income, 0))   AS Ratio_gap
FROM top_region t
CROSS JOIN bottom_region b;
```

### 📊 Natijalar

| Ko'rsatkich | Qiymat |
|-------------|--------|
| 🔝 Top hudud | **Toshkent sh.** — 60.59 mln UZS (2024) |
| 🔻 Bottom hudud | **Qoraqalpog'iston** — 9.87 mln UZS (2024) |
| 📏 Absolyut farq | **50.72 mln UZS** |
| ⚖️ Nisbiy farq | **6.1x** |

### Farq dinamikasi (2010–2024)

| Yil | Toshkent sh. | Qoraqalpog'iston | Absolyut farq | Nisbat |
|-----|-------------|-----------------|---------------|--------|
| 2010 | 4.21 | 1.50 | 2.71 | 2.8x |
| 2015 | 12.40 | 4.10 | 8.30 | 3.0x |
| 2020 | 26.33 | 7.89 | 18.44 | 3.3x |
| 2024 | 60.59 | 9.87 | 50.72 | **6.1x** |

> 💡 **Insight:** Absolyut farq 2010 yildan beri **~18.7x oshdi** — tengsizlik kamaymasdan o'sib bormoqda.

📄 [To'liq insight →](../insights/02_income_gap_analysis.md)

---

## 3️⃣ Sector Structure Analysis — `03_sector_structure_analysis.sql`

**Savol:** Qaysi sektorlar har bir hududda ustunlik qiladi?

**Metod:** `UNION ALL` orqali 3 sektor birlashtirish → `SUM() OVER (PARTITION BY region)` → ulush (%) hisoblash

```sql
/*
Project: Sector Structure Analysis – Uzbekistan
Data source: Stat.uz
Author: Sarvar Erkinjonov
Goal: Analyze the contribution of major economic sectors by region.
*/

;WITH sectors AS (
    SELECT region, 'Industry'    AS sector, CAST(industry_output   AS FLOAT) AS value
    FROM dbo.fact_industry    WHERE industry_output IS NOT NULL
    UNION ALL
    SELECT region, 'Agriculture' AS sector, CAST(agriculture_output AS FLOAT) AS value
    FROM dbo.fact_agriculture WHERE agriculture_output IS NOT NULL
    UNION ALL
    SELECT region, 'Business'    AS sector, CAST(business_activity  AS FLOAT) AS value
    FROM dbo.fact_business    WHERE business_activity IS NOT NULL
),
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
```

### 📊 Natijalar

| Hudud turi | Dominant sektor | Ulush | Misollar |
|------------|-----------------|-------|----------|
| **Urban / Industrial** | Construction + Trade | 60–70% | Toshkent sh., Navoiy |
| **Mixed** | Trade + Agriculture | 50–55% | Toshkent vil., Buxoro, Samarqand |
| **Agricultural** | Agriculture | 55–70% | Qoraqalpog'iston, Surxondaryo, Xorazm |
| **Trade-oriented** | Retail + Wholesale | 50–60% | Farg'ona, Andijon, Namangan |

### Sektor o'sishi (2010–2024)

| Sektor | 2010 | 2024 | O'sish |
|--------|------|------|--------|
| Qurilish | 8.2T UZS | 69.0T UZS | **+8.4x** 🏆 |
| Qishloq xo'jaligi | 30.9T UZS | 162.0T UZS | **+5.3x** |
| Chakana savdo | 21.9T UZS | 108.2T UZS | **+4.9x** |

> 💡 **Insight:** Qurilish eng tez o'suvchi sektor (+8.4x) — urbanizatsiya va investitsiyalar natijasida.

📄 [To'liq insight →](../insights/03_sector_structure_analysis.md)

---

## 4️⃣ Income Drivers Correlation — `04_drivers_correlation.sql`

**Savol:** Qaysi iqtisodiy ko'rsatkich daromad bilan eng kuchli bog'liq?

**Metod:** Har bir hudud uchun ko'rsatkichlarni aggregatsiya → `CORR()` orqali Pearson korrelyatsiyasi

```sql
/*
Project: Income Drivers Correlation – Uzbekistan
Data source: Stat.uz
Author: Sarvar Erkinjonov
Goal: Assess the relationship between income per capita and key economic sectors.
*/

;WITH income AS (
    SELECT region, AVG(CAST(income_pc AS FLOAT)) AS avg_income
    FROM dbo.vw_income_mart WHERE income_pc IS NOT NULL GROUP BY region
),
industry AS (
    SELECT region, AVG(CAST(industry_output AS FLOAT)) AS avg_industry
    FROM dbo.fact_industry WHERE industry_output IS NOT NULL GROUP BY region
),
business AS (
    SELECT region, AVG(CAST(business_activity AS FLOAT)) AS avg_business
    FROM dbo.fact_business WHERE business_activity IS NOT NULL GROUP BY region
),
agriculture AS (
    SELECT region, AVG(CAST(agriculture_output AS FLOAT)) AS avg_agriculture
    FROM dbo.fact_agriculture WHERE agriculture_output IS NOT NULL GROUP BY region
),
combined AS (
    SELECT
        i.region,
        i.avg_income,
        ind.avg_industry,
        b.avg_business,
        a.avg_agriculture
    FROM income i
    LEFT JOIN industry    ind ON i.region = ind.region
    LEFT JOIN business    b   ON i.region = b.region
    LEFT JOIN agriculture a   ON i.region = a.region
)
SELECT
    COUNT(*) AS regions_count,
    CORR(avg_income, avg_industry)    AS corr_income_industry,
    CORR(avg_income, avg_business)    AS corr_income_business,
    CORR(avg_income, avg_agriculture) AS corr_income_agriculture
FROM combined
WHERE avg_income IS NOT NULL;
```

### 📊 Natijalar

| Omil | Korrelyatsiya | Kuch | Yo'nalish |
|------|--------------|------|-----------|
| 💹 **Investitsiyalar (Fixed Capital pc)** | **+0.97** | Juda kuchli | Ijobiy |
| 📈 **GRP (Yalpi hududiy mahsulot)** | **+0.91** | Juda kuchli | Ijobiy |
| 🏗️ **Qurilish** | **+0.89** | Kuchli | Ijobiy |
| 🛒 **Chakana savdo** | **+0.86** | Kuchli | Ijobiy |
| 🏪 **Ulgurji savdo** | **+0.84** | Kuchli | Ijobiy |
| 🌾 **Qishloq xo'jaligi** | **+0.43** | O'rtacha | Ijobiy |
| 👷 **Bandlik darajasi** | **+0.31** | Zaif | Ijobiy |

> 💡 **Insight:** **Investitsiyalar per capita (r=0.97)** — daromad bilan eng kuchli bog'liq omil. Qishloq xo'jaligi esa ko'p hududda ustun bo'lsa-da, daromad bilan bog'liqligi zaif (r=0.43).

📄 [To'liq insight →](../insights/04_drivers_correlation.md)

---

## 🔗 Bog'liq fayllar

| Bo'lim | Havola |
|--------|--------|
| 🐍 Python (data pipeline) | [`../python/`](../python/) |
| 📊 Power BI Dashboard | [`../power_bi/`](../power_bi/) |
| 📝 Insight 1 — Segmentation | [`../insights/01_income_segmentation.md`](../insights/01_income_segmentation.md) |
| 📝 Insight 2 — Gap Analysis | [`../insights/02_income_gap_analysis.md`](../insights/02_income_gap_analysis.md) |
| 📝 Insight 3 — Sector Structure | [`../insights/03_sector_structure_analysis.md`](../insights/03_sector_structure_analysis.md) |
| 📝 Insight 4 — Drivers | [`../insights/04_drivers_correlation.md`](../insights/04_drivers_correlation.md) |

---

## 🛠️ Stack

| Vosita | Maqsad |
|--------|--------|
| **SQL Server / T-SQL** | Asosiy query tili |
| **CTEs** | Murakkab querylarni tuzilmalashtirish |
| **Window Functions** | `NTILE`, `ROW_NUMBER`, `SUM OVER` |
| **CORR()** | Pearson korrelyatsiya hisoblash |
