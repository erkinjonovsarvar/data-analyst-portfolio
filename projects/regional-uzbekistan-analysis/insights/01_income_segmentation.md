# Income Segmentation — Uzbekistan (Stat.uz)

## Business Question
Which regions of Uzbekistan have stronger and weaker income per capita levels?

## Method
- Aggregated income per capita (`income_pc`) by region across 2010–2024
- Segmented 14 regions into quartiles (Q1–Q4) using NTILE(4) window function
- Compared average income across segments to identify performance tiers

## Results — Regional Income Quartile Table (Avg 2010–2024)

| Segment | Region | Avg Income per Capita (mln UZS) |
|---------|--------|----------------------------------|
| **Q4 — High (Top 25%)** | Toshkent sh. | 34.18 |
| **Q4 — High (Top 25%)** | Navoiy | 14.92 |
| **Q4 — High (Top 25%)** | Toshkent vil. | 13.87 |
| **Q3 — Above Average** | Buxoro | 11.64 |
| **Q3 — Above Average** | Qashqadaryo | 10.98 |
| **Q3 — Above Average** | Jizzax | 9.73 |
| **Q2 — Below Average** | Samarqand | 9.21 |
| **Q2 — Below Average** | Sirdaryo | 8.95 |
| **Q2 — Below Average** | Farg'ona | 8.84 |
| **Q1 — Low (Bottom 25%)** | Andijon | 8.12 |
| **Q1 — Low (Bottom 25%)** | Namangan | 7.88 |
| **Q1 — Low (Bottom 25%)** | Xorazm | 7.45 |
| **Q1 — Low (Bottom 25%)** | Surxondaryo | 7.02 |
| **Q1 — Low (Bottom 25%)** | Qoraqalpog'iston | 6.31 |

## Key Findings

- **High-income regions (Q4):** Toshkent sh. (60.59 mln UZS in 2024), Navoiy, Toshkent vil. — driven by industrial output, investment, and trade concentration
- **Low-income regions (Q1):** Qoraqalpog'iston (1.50 mln UZS in 2010 → 9.87 in 2024), Surxondaryo, Xorazm — predominantly agricultural economies with lower industrial activity
- **Income gap observation:** Q4 average income is **~5.4x higher** than Q1 average, indicating significant regional inequality
- All regions showed consistent income growth over 2010–2024, but the **absolute gap widened** significantly

## Trend Insight

| Year | National Avg Income pc (mln UZS) |
|------|----------------------------------|
| 2010 | 2.19 |
| 2015 | 6.12 |
| 2020 | 16.47 |
| 2024 | 38.60 |

> Income grew ~17.6x over 14 years, reflecting both real economic growth and inflation.

## Implications
- Regions in Q1 may require targeted economic support and investment incentives
- Best practices from Q4 regions (Toshkent, Navoiy) — industrial zones, FDI attraction — can be studied and replicated
- Policy should focus on reducing the **absolute gap**, not just relative growth rates
