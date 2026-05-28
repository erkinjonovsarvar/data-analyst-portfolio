# Power BI Dashboard — Regional Economic Analysis of Uzbekistan

## Overview

This dashboard visualizes the results of the **Regional Economic Analysis of Uzbekistan** project.
It is built on top of the SQL analysis and Python-cleaned data (source: **Stat.uz**), covering **14 regions × 15 years (2010–2024)**.

The dashboard is designed for **policy analysts, regional managers, and business intelligence professionals** who need a quick, visual overview of regional economic performance.

---

## Dashboard Pages

### 📄 Page 1 — Income Overview
**Purpose:** Snapshot of income per capita across all regions

| Visual | Type | Description |
|--------|------|-------------|
| Income by Region (2024) | Bar Chart | Ranked income per capita — Toshkent sh. (60.59) vs Qoraqalpog'iston (9.87 mln UZS) |
| Income Trend (2010–2024) | Line Chart | National avg grew from 2.19 → 38.60 mln UZS (~17.6x) |
| Region Segmentation | Map / Matrix | Q1–Q4 income quartile classification |
| KPI Cards | Card Visuals | National avg, top region, bottom region, Q4/Q1 ratio |

---

### 📄 Page 2 — Income Gap Analysis
**Purpose:** Show how regional inequality has evolved over time

| Visual | Type | Description |
|--------|------|-------------|
| Gap Trend Line | Line Chart | Absolute gap: 2.71 mln (2010) → 50.72 mln UZS (2024) |
| Ratio Trend | Line Chart | Ratio: 2.8x (2010) → 6.1x (2024) — divergence visible |
| Top vs Bottom | Clustered Bar | Toshkent sh. vs Qoraqalpog'iston side-by-side each year |
| Inequality Heatmap | Matrix | Regions × Years — income_pc color coded |

---

### 📄 Page 3 — Sector Structure
**Purpose:** Understand which sectors dominate each region

| Visual | Type | Description |
|--------|------|-------------|
| Sector Share by Region | Stacked Bar | Agriculture / Construction / Trade share per region |
| National Sector Trend | Area Chart | All 3 sectors 2010–2024 (Construction +8.4x, Agriculture +5.3x) |
| Region Type Matrix | Table | Urban / Mixed / Agricultural / Trade-oriented classification |
| Sector vs Income Scatter | Scatter Plot | Agriculture dominance vs income_pc — weak correlation visible |

---

### 📄 Page 4 — Economic Drivers
**Purpose:** Show which factors are most correlated with income growth

| Visual | Type | Description |
|--------|------|-------------|
| Correlation Summary | Bar Chart | Investment r=0.97 · GRP r=0.91 · Agriculture r=0.43 |
| Investment vs Income | Scatter Plot | Strong linear relationship (r=0.97) across all regions |
| GRP per Capita by Region | Horizontal Bar | Ranked by GRP pc — mirrors income ranking closely |
| Driver Ranking Card | KPI Table | Top driver: Investment per capita → strongest income predictor |

---

## Key Metrics Displayed

| KPI | Value (2024) |
|-----|--------------|
| National avg income pc | 38.60 mln UZS |
| Highest region | Toshkent sh. — 60.59 mln UZS |
| Lowest region | Qoraqalpog'iston — 9.87 mln UZS |
| Income gap ratio | 6.1x |
| Absolute gap | 50.72 mln UZS |
| Strongest income driver | Investment per capita (r = 0.97) |
| Weakest driver | Employment rate (r = 0.31) |
| Fastest growing sector | Construction (+8.4x, 2010–2024) |

---

## Filters & Slicers

| Slicer | Options |
|--------|---------|
| **Year** | 2010 – 2024 (single or range) |
| **Region** | All 14 regions + national total |
| **Sector** | Agriculture / Construction / Trade |
| **Income Segment** | Q1 / Q2 / Q3 / Q4 |

---

## Data Source

| Field | Detail |
|-------|--------|
| Source | Stat.uz — official statistics portal of Uzbekistan |
| Coverage | 14 regions, 2010–2024 |
| Refresh | Manual (annual data release) |
| Preparation | Python (Pandas) → cleaned Gold layer → Power BI |

---

## How to Use

1. Open the `.pbix` file in **Power BI Desktop** (version 2.0+)
2. Use the **Year slicer** to filter a specific period
3. Use the **Region slicer** to drill into a specific region
4. **Page 4 (Drivers)** is best used without region filter — shows full correlation across all regions
5. Screenshots of each page are provided below for quick review

---

## Screenshots

> 📌 *Dashboard screenshots will be added after final Power BI file export.*
> 
> Planned visuals:
> - `page1_income_overview.png`
> - `page2_income_gap.png`
> - `page3_sector_structure.png`
> - `page4_economic_drivers.png`

---

## Tools Used

- **Power BI Desktop** — dashboard development
- **DAX** — calculated measures (gap ratio, YoY growth, quartile logic)
- **Python (Pandas)** — data cleaning and Gold layer preparation
- **SQL (PostgreSQL)** — analytical queries (segmentation, correlation, gap analysis)
