# Power BI Dashboard — Regional Economic Analysis of Uzbekistan

## Overview

This dashboard visualizes the results of the **Regional Economic Analysis of Uzbekistan** project.
It is built on top of SQL analytical queries and Python-cleaned data (source: **Stat.uz**), covering **14 regions × 15 years (2010–2024)**.

The dashboard is designed for **policy analysts, regional managers, and business intelligence professionals** who need a quick, visual overview of regional economic performance.

📁 **Dashboard file:** [`uzbekistan stat uz.pbix`](./uzbekistan%20stat%20uz.pbix)

---

## 📊 Key Metrics at a Glance

| KPI | Value (2024) |
|-----|-------------|
| 🏆 National avg income pc | **38.60 mln UZS** |
| 🔝 Highest region | **Toshkent sh. — 60.59 mln UZS** |
| 🔻 Lowest region | **Qoraqalpog'iston — 9.87 mln UZS** |
| ⚖️ Income gap ratio | **6.1x** |
| 📉 Absolute gap | **50.72 mln UZS** |
| 💹 Strongest income driver | **Investment per capita (r = 0.97)** |
| 📉 Weakest driver | **Employment rate (r = 0.31)** |
| 🏗️ Fastest growing sector | **Construction (+8.4x, 2010–2024)** |

---

## 📄 Dashboard Pages

### Page 1 — Income Overview
**Purpose:** Snapshot of income per capita across all regions

| Visual | Type | Description |
|--------|------|-------------|
| Income by Region (2024) | Bar Chart | Ranked income per capita — Toshkent sh. (60.59) vs Qoraqalpog'iston (9.87 mln UZS) |
| Income Trend (2010–2024) | Line Chart | National avg grew from 2.19 → 38.60 mln UZS (~17.6x) |
| Region Segmentation | Matrix | Q1–Q4 income quartile classification |
| KPI Cards | Card Visuals | National avg, top region, bottom region, Q4/Q1 ratio |

> 📸 Screenshot: [`screenshots/page1_income_overview.png`](./screenshots/page1_income_overview.png)

---

### Page 2 — Income Gap Analysis
**Purpose:** Show how regional inequality has evolved over time

| Visual | Type | Description |
|--------|------|-------------|
| Gap Trend Line | Line Chart | Absolute gap: 2.71 mln (2010) → 50.72 mln UZS (2024) |
| Ratio Trend | Line Chart | Ratio: 2.8x (2010) → 6.1x (2024) — divergence visible |
| Top vs Bottom | Clustered Bar | Toshkent sh. vs Qoraqalpog'iston side-by-side each year |
| Inequality Heatmap | Matrix | Regions × Years — income_pc color coded |

> 📸 Screenshot: [`screenshots/page2_income_gap.png`](./screenshots/page2_income_gap.png)

---

### Page 3 — Sector Structure
**Purpose:** Understand which sectors dominate each region

| Visual | Type | Description |
|--------|------|-------------|
| Sector Share by Region | Stacked Bar | Agriculture / Construction / Trade share per region |
| National Sector Trend | Area Chart | All 3 sectors 2010–2024 (Construction +8.4x, Agriculture +5.3x) |
| Region Type Matrix | Table | Urban / Mixed / Agricultural / Trade-oriented classification |
| Sector vs Income Scatter | Scatter Plot | Agriculture dominance vs income_pc — weak correlation visible |

> 📸 Screenshot: [`screenshots/page3_sector_structure.png`](./screenshots/page3_sector_structure.png)

---

### Page 4 — Economic Drivers
**Purpose:** Show which factors are most correlated with income growth

| Visual | Type | Description |
|--------|------|-------------|
| Correlation Summary | Bar Chart | Investment r=0.97 · GRP r=0.91 · Agriculture r=0.43 |
| Investment vs Income | Scatter Plot | Strong linear relationship (r=0.97) across all regions |
| GRP per Capita by Region | Horizontal Bar | Ranked by GRP pc — mirrors income ranking closely |
| Driver Ranking Card | KPI Table | Top driver: Investment per capita → strongest income predictor |

> 📸 Screenshot: [`screenshots/page4_economic_drivers.png`](./screenshots/page4_economic_drivers.png)

---

## 🎛️ Filters & Slicers

| Slicer | Options |
|--------|---------|
| **Year** | 2010 – 2024 (single or range) |
| **Region** | All 14 regions + national total |
| **Sector** | Agriculture / Construction / Trade |
| **Income Segment** | Q1 / Q2 / Q3 / Q4 |

---

## 🗄️ Data Source

| Field | Detail |
|-------|--------|
| Source | [Stat.uz](https://stat.uz) — official statistics portal of Uzbekistan |
| Coverage | 14 regions, 2010–2024 |
| Refresh | Manual (annual data release) |
| Preparation | Python (Pandas) → cleaned Gold layer → Power BI |

---

## 🚀 How to Use

1. Download [`uzbekistan stat uz.pbix`](./uzbekistan%20stat%20uz.pbix)
2. Open it in **Power BI Desktop** (version 2.0+)
3. Use the **Year slicer** to filter a specific period
4. Use the **Region slicer** to drill into a specific region
5. **Page 4 (Drivers)** is best used without region filter — shows full correlation across all regions

---

## 🖼️ Screenshots

> 📌 *Screenshots will be added after dashboard export from Power BI Desktop.*
> 
> To add screenshots:
> 1. Open each page in Power BI Desktop
> 2. Go to **File → Export → Export to PNG** (or use Snipping Tool)
> 3. Save files to `screenshots/` folder with the names below:

| Page | File |
|------|------|
| Page 1 — Income Overview | `screenshots/page1_income_overview.png` |
| Page 2 — Income Gap | `screenshots/page2_income_gap.png` |
| Page 3 — Sector Structure | `screenshots/page3_sector_structure.png` |
| Page 4 — Economic Drivers | `screenshots/page4_economic_drivers.png` |

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **Power BI Desktop** | Dashboard development & visualization |
| **DAX** | Calculated measures (gap ratio, YoY growth, quartile logic) |
| **Python (Pandas)** | Data cleaning and Gold layer preparation |
| **SQL (PostgreSQL)** | Analytical queries (segmentation, correlation, gap analysis) |

---

## 🔗 Related Files

| File | Description |
|------|-------------|
| [`../sql/01_income_segmentation.sql`](../sql/01_income_segmentation.sql) | SQL — Income quartile segmentation |
| [`../sql/02_income_gap_analysis.sql`](../sql/02_income_gap_analysis.sql) | SQL — Gap trend analysis |
| [`../sql/03_sector_structure_analysis.sql`](../sql/03_sector_structure_analysis.sql) | SQL — Sector share by region |
| [`../sql/04_drivers_correlation.sql`](../sql/04_drivers_correlation.sql) | SQL — Correlation with income |
| [`../insights/01_income_segmentation.md`](../insights/01_income_segmentation.md) | Insight — Segmentation findings |
| [`../insights/02_income_gap_analysis.md`](../insights/02_income_gap_analysis.md) | Insight — Gap analysis findings |
| [`../insights/03_sector_structure_analysis.md`](../insights/03_sector_structure_analysis.md) | Insight — Sector structure findings |
| [`../insights/04_drivers_correlation.md`](../insights/04_drivers_correlation.md) | Insight — Driver correlation findings |
