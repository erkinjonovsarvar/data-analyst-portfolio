# 🛒 Superstore Sales Analysis

## Project Overview

End-to-end sales data analysis of a US-based retail superstore to identify profit drivers, loss areas, and strategic business opportunities.

| Field | Detail |
|-------|--------|
| **Dataset** | [Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) (Kaggle) |
| **Records** | ~10,000 orders |
| **Period** | 2014 – 2017 |
| **Region** | United States (4 regions) |
| **Tools** | Python · Pandas · NumPy · Matplotlib · Seaborn · Power BI |

---

## Business Questions Answered

1. How does discount level affect profitability?
2. Which product categories and sub-categories are most/least profitable?
3. Which regions and customer segments generate the most profit?
4. What is the monthly/yearly sales trend?
5. Why did profit margin drop in 2017?
6. Which shipping mode is most efficient?

---

## Key KPIs

| Metric | Value |
|--------|-------|
| **Total Sales** | $2,297,201 |
| **Total Profit** | $286,397 |
| **Avg Profit Margin** | ~12.5% |
| **Total Orders** | 9,994 |
| **Top Category (Sales)** | Technology — $836,154 |
| **Top Category (Profit)** | Technology — $145,455 |
| **Worst Sub-Category** | Tables — $(−17,725) loss |

---

## Analysis Sections

### 📊 1. Profit vs Discount
- **Correlation:** Discount vs Profit = **−0.22** (negative — higher discount = lower profit)
- Orders with **discount > 0.4** consistently generate **negative profit**
- Zero-discount orders have avg profit margin of **~18%**
- Discounts above **20%** should be avoided for most product lines

| Discount Range | Total Profit |
|----------------|-------------|
| 0% | $340,000+ |
| 0–20% | $120,000+ |
| 20–40% | $(−15,000) |
| 40%+ | $(−80,000) |

---

### 📊 2. Category Analysis

| Category | Total Sales | Total Profit | Margin |
|----------|-------------|--------------|--------|
| **Technology** | $836,154 | $145,455 | 17.4% |
| **Office Supplies** | $719,047 | $122,491 | 17.0% |
| **Furniture** | $741,999 | $18,451 | 2.5% |

> ⚠️ **Furniture has near-zero margin** despite being the 2nd highest revenue category — driven by heavy discounting on Tables and Bookcases.

---

### 📊 3. Sub-Category Analysis

**Top 5 (Profitable):**

| Sub-Category | Profit |
|-------------|--------|
| Copiers | $55,618 |
| Phones | $44,516 |
| Accessories | $41,937 |
| Paper | $34,054 |
| Binders | $30,222 |

**Bottom 5 (Loss-making):**

| Sub-Category | Profit |
|-------------|--------|
| Tables | $(−17,725) |
| Bookcases | $(−3,473) |
| Supplies | $(−1,189) |
| Fasteners | $950 |
| Labels | $5,546 |

---

### 📊 4. Region Analysis

| Region | Total Sales | Total Profit |
|--------|-------------|--------------|
| **West** | $725,458 | $108,418 |
| **East** | $678,781 | $91,523 |
| **South** | $391,722 | $46,749 |
| **Central** | $501,240 | $39,706 |

> Central region has the **lowest profit margin (~7.9%)** despite moderate sales — high discounting issue.

---

### 📊 5. Segment Analysis

| Segment | Total Sales | Total Profit |
|---------|-------------|--------------|
| **Consumer** | $1,161,401 | $134,119 |
| **Corporate** | $706,146 | $91,979 |
| **Home Office** | $429,653 | $60,299 |

> Consumer segment drives 50%+ of revenue and profit.

---

### 📊 6. Time Series Analysis

| Year | Total Sales | YoY Growth |
|------|-------------|------------|
| 2014 | $484,247 | — |
| 2015 | $470,533 | −2.8% |
| 2016 | $609,206 | +29.5% |
| 2017 | $733,215 | +20.4% |

**Monthly pattern:** Sales peak in **November–December** (holiday season) and dip in **January–February**.

**2017 Profit Margin Drop — Root Cause:**
- Average discount increased from 15.4% → 17.3% in 2017
- Furniture category discounts spiked in Q3 2017
- Copiers showed strong recovery but couldn't offset Furniture losses

---

### 📊 7. Shipping Analysis

| Ship Mode | Avg Ship Duration | Avg Profit per Order |
|-----------|-------------------|----------------------|
| Same Day | 0 days | $28.40 |
| First Class | 2.2 days | $31.60 |
| Second Class | 3.4 days | $28.90 |
| Standard Class | 5.0 days | $28.10 |

> Ship mode has minimal impact on profit — customer preference is the main driver.

---

## Star Schema (Power BI Data Model)

The notebook builds a full **star schema** for Power BI:

```
                    ┌─────────────┐
                    │  Fact_Sales │
                    └──────┬──────┘
          ┌─────────┬───────┼───────┬─────────┐
          ▼         ▼       ▼       ▼         ▼
   Dim_Customer  Dim_Product  Dim_Location  Dim_Date  Dim_ShipMode
```

| Table | Key Columns |
|-------|-------------|
| **Fact_Sales** | Order ID, Sales, Profit, Discount, Quantity, Profit Margin |
| **Dim_Customer** | Customer ID, Customer Name, Segment |
| **Dim_Product** | Product ID, Product Name, Category, Sub-Category |
| **Dim_Location** | City, State, Region, Postal Code |
| **Dim_Date** | Date Key, Year, Month, Quarter, Day of Week |
| **Dim_ShipMode** | Ship Mode, Avg Ship Duration |

---

## Key Findings & Recommendations

| # | Finding | Recommendation |
|---|---------|----------------|
| 1 | Discounts > 20% destroy profitability | Cap discounts at 20% for non-strategic products |
| 2 | Tables sub-category loses $17K | Consider discontinuing or repricing |
| 3 | Central region has lowest margin | Audit discount practices in Central region |
| 4 | Technology has 17.4% margin | Prioritize Technology upselling |
| 5 | Q4 (Nov–Dec) is peak season | Increase inventory and marketing in Q3 prep |
| 6 | Consumer segment = 50% of revenue | Build loyalty programs for Consumer segment |

---

## Project Structure

```
superstore-sales-analysis/
├── Superstore_Sales_Final_Portfolio.ipynb   ← Full analysis notebook
└── README.md                                ← This file
```

## Status
✅ **Completed**
