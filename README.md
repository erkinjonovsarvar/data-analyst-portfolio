# Data Analyst Portfolio

## 👤 About Me

I am a passionate and detail-oriented Data Analyst with strong skills in SQL, Power BI, Excel, and Python. I enjoy transforming raw data into meaningful insights that help businesses make smarter decisions and improve performance.

I have experience working with data cleaning, KPI analysis, dashboard development, reporting automation, and business intelligence solutions. My projects include sales analysis, employee KPI tracking, customer segmentation, financial reporting, and data visualization dashboards designed for managers and executives.

I am continuously improving my analytical and technical skills by working on real-world projects and exploring modern data tools and technologies. I focus on creating clear, efficient, and business-oriented solutions that provide real value.

Currently, I am building professional portfolio projects in Data Analytics, Business Intelligence, and Accounting Analytics while also improving my expertise in SQL databases, Power BI dashboards, Excel automation, and Python-based data analysis.

I am highly motivated to grow as a Data Analyst and contribute to companies by turning complex data into actionable insights.

---

## 🛠️ Skills & Tools

| Category | Tools |
|----------|-------|
| **Query & Database** | SQL (PostgreSQL, MySQL) · CTEs · Window Functions |
| **Visualization** | Power BI · Excel Charts |
| **Programming** | Python (Pandas, Matplotlib, Seaborn) · Jupyter Notebook |
| **Analytics** | KPI Analysis · Data Cleaning · Customer Segmentation · Financial Reporting |

---

## 📁 Projects

### 1. 🗺️ Regional Economic Analysis of Uzbekistan
> **SQL · Python · Power BI** | Data: Stat.uz | 14 regions × 15 years (2010–2024)

End-to-end regional economic analysis covering income disparities, sector structure, and growth drivers across all 14 regions of Uzbekistan.

| Highlight | Result |
|-----------|--------|
| 📊 Income gap (2024) | Toshkent sh. **6.1x** higher than Qoraqalpog'iston |
| 💹 Strongest income driver | Investment per capita (r = **0.97**) |
| 🏗️ Fastest growing sector | Construction (**+8.4x**, 2010–2024) |
| 📈 National income growth | 2.19 → 38.60 mln UZS (**+17.6x**) |

#### 📂 Project Structure

| Folder | Contents |
|--------|----------|
| [`projects/regional-uzbekistan-analysis/sql/`](projects/regional-uzbekistan-analysis/sql/) | 4 SQL analytical queries |
| [`projects/regional-uzbekistan-analysis/insights/`](projects/regional-uzbekistan-analysis/insights/) | 4 written insight reports |
| [`projects/regional-uzbekistan-analysis/power_bi/`](projects/regional-uzbekistan-analysis/power_bi/) | Power BI dashboard (`.pbix`) |
| [`python/stat_uz_analysis/`](python/stat_uz_analysis/) | Python data cleaning & EDA |

#### 🗂️ SQL Analyses

| # | File | Description |
|---|------|-------------|
| 1 | [`01_income_segmentation.sql`](projects/regional-uzbekistan-analysis/sql/01_income_segmentation.sql) | Quartile segmentation of 14 regions |
| 2 | [`02_income_gap_analysis.sql`](projects/regional-uzbekistan-analysis/sql/02_income_gap_analysis.sql) | Top vs bottom region gap trend |
| 3 | [`03_sector_structure_analysis.sql`](projects/regional-uzbekistan-analysis/sql/03_sector_structure_analysis.sql) | Sector share by region |
| 4 | [`04_drivers_correlation.sql`](projects/regional-uzbekistan-analysis/sql/04_drivers_correlation.sql) | Income driver correlation |

#### 📊 Power BI Dashboard

4-page interactive dashboard built on cleaned Stat.uz data:

| Page | Focus |
|------|-------|
| Page 1 | Income Overview — ranked bar chart, trend line, KPI cards |
| Page 2 | Income Gap — absolute & ratio gap trend, inequality heatmap |
| Page 3 | Sector Structure — stacked bar, area chart, region type matrix |
| Page 4 | Economic Drivers — correlation chart, scatter plots, driver ranking |

📁 [`power_bi/`](projects/regional-uzbekistan-analysis/power_bi/) · 📥 [Download `.pbix`](projects/regional-uzbekistan-analysis/power_bi/uzbekistan%20stat%20uz.pbix)

**Status: ✅ Completed**

---

### 2. 🛒 Superstore Sales Analysis
> **Python · Pandas · Matplotlib · Seaborn** | Data: Kaggle | ~10,000 orders (2014–2017)

End-to-end US retail sales analysis covering profitability, discounting impact, regional performance, and customer segmentation.

| Highlight | Result |
|-----------|--------|
| 💰 Total Sales | **$2,297,201** |
| 📈 Total Profit | **$286,397** (avg margin 12.5%) |
| 📉 Worst sub-category | Tables: **−$17,725 loss** |
| 🔍 Key finding | Discounts > 20% → **always unprofitable** |

📂 [`projects/superstore-sales-analysis/`](projects/superstore-sales-analysis/) · 📓 [Jupyter Notebook](projects/superstore-sales-analysis/Superstore_Sales_Final_Portfolio.ipynb)

**Status: ✅ Completed**

---

## 🗺️ Roadmap

- [x] Regional Economic Analysis of Uzbekistan (SQL + Python + Power BI)
- [x] Superstore Sales Analysis (Python + EDA)
- [ ] Add year-over-year income growth analysis (Uzbekistan)
- [ ] Build regional inequality index (Gini-style proxy)
- [ ] Add HR / Employee KPI Tracking project
- [ ] Add Financial Reporting & Accounting Analytics project
- [ ] Deploy Power BI dashboard to Power BI Service (cloud)
