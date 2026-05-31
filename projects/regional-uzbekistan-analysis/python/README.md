# Python Analysis — Regional Economic Analysis of Uzbekistan

## Overview

This module handles **data cleaning, preprocessing, and exploratory data analysis (EDA)**
for the Regional Economic Analysis of Uzbekistan project.

The raw data is sourced from **[Stat.uz](https://stat.uz)** — the official statistics portal of Uzbekistan,
covering **14 regions × 15 years (2010–2024)** with 20+ economic, demographic, and labor market indicators.

---

## 📁 Folder Structure

```
python/
├── cleaner.py              ← DataCleaner class (reusable preprocessing utility)
├── stat_uz_analysis.ipynb  ← Main EDA notebook (Bronze → Silver → Gold pipeline)
├── data.xlsx               ← Raw source data from Stat.uz (multi-sheet Excel)
└── README.md               ← This file
```

---

## 🔄 Data Pipeline

```
data.xlsx (Raw)
    │
    ▼
Bronze Layer  →  Raw file copied as-is (no changes)
    │
    ▼
Silver Layer  →  Sheets merged on region_year_id primary key
                 DataCleaner.clean() applied
                 Missing values handled
    │
    ▼
Gold Layer    →  column_split() → region + year columns extracted
                 income_segment (Q1–Q4) added
                 Final clean DataFrame ready for SQL & Power BI
```

---

## 🧹 DataCleaner — `cleaner.py`

Reusable preprocessing class with 4 methods:

| Method | Description |
|--------|-------------|
| `clean(df)` | Standardizes column names, replaces `..`, `N/A`, `-` with `pd.NA`, drops empty rows & duplicates |
| `column_split(df)` | Splits `region_year_id` (e.g. `Toshkentsh2024`) into `region` + `year` columns |
| `add_income_segment(df)` | Adds `income_segment` column: Q1 (lowest) → Q4 (highest) by year |
| `summary(df)` | Prints shape, duplicate count, missing values summary |

### Usage Example

```python
from cleaner import DataCleaner
import pandas as pd

cleaner = DataCleaner()

df = pd.read_excel("data.xlsx", sheet_name="income")
df = cleaner.clean(df)
df = cleaner.column_split(df)
df = cleaner.add_income_segment(df)
cleaner.summary(df)
```

---

## 📓 Notebook — `stat_uz_analysis.ipynb`

### Sections

| # | Section | Description |
|---|---------|-------------|
| 1 | **Column Dictionary** | Full description of all 20+ columns in Uzbekian |
| 2 | **Bronze Layer** | Raw file copied to data lake |
| 3 | **Silver Layer** | All Excel sheets merged on `region_year_id` |
| 4 | **Gold Layer** | Cleaned, split, segmented final DataFrame |
| 5 | **EDA** | Exploratory analysis — income trends, sector analysis, correlations |

---

## 📊 Dataset — `data.xlsx`

| Field | Detail |
|-------|--------|
| **Source** | [Stat.uz](https://stat.uz) — official statistics of Uzbekistan |
| **Coverage** | 14 regions + national total, 2010–2024 |
| **Format** | Multi-sheet Excel (one sheet per indicator group) |
| **Key** | `region_year_id` — composite primary key (e.g. `Toshkentsh2024`) |

### Key Columns

| Column | Type | Description |
|--------|------|-------------|
| `region_year_id` | object | Composite key: region + year |
| `income_pc` | float64 | Income per capita (mln UZS) |
| `grp` | float64 | Gross Regional Product |
| `inv_fixed_capital_pc` | float64 | Investment per capita |
| `construction` | float64 | Construction output |
| `agriculture_output` | float64 | Agricultural output |
| `retail_trade` | float64 | Retail trade turnover |
| `wholesale_trade` | float64 | Wholesale trade turnover |
| `employed_thousand` | float64 | Employed population (thousands) |
| `employement_rate_pct` | float64 | Employment rate (%) |
| `population_permanent` | float64 | Permanent population |
| `births_total` | int64 | Total registered births |
| `active_enterprises_count` | int64 | Active registered enterprises |
| `air_pollutants_emitted` | float64 | Air pollutants (thousand tonnes) |

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
| [`../power_bi/`](../power_bi/) | Power BI dashboard (.pbix) |

---

## 🛠️ Tools & Libraries

| Tool | Version | Purpose |
|------|---------|---------|
| **Python** | 3.10+ | Core language |
| **Pandas** | 2.x | Data manipulation & cleaning |
| **Matplotlib** | 3.x | Static visualizations |
| **Seaborn** | 0.13+ | Statistical visualizations |
| **Jupyter Notebook** | — | Interactive analysis environment |
| **openpyxl** | — | Excel file reading |
