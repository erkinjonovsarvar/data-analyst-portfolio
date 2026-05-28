# Income Gap Analysis — Uzbekistan (Stat.uz)

## Business Question
How large is the income disparity between the highest and lowest income regions?

## Method
- Computed average income per capita (`income_pc`) by region across 2010–2024
- Identified top (rank 1) and bottom (rank 1) regions using ROW_NUMBER() window function
- Calculated absolute gap (difference) and ratio gap (multiplier) between top and bottom

## Key Results

| Metric | Value |
|--------|-------|
| **Top region** | Toshkent sh. |
| **Top avg income pc (2024)** | 60.59 mln UZS |
| **Bottom region** | Qoraqalpog'iston |
| **Bottom avg income pc (2024)** | 9.87 mln UZS |
| **Absolute gap (2024)** | 50.72 mln UZS |
| **Ratio gap (2024)** | ~6.1x |

## Gap Trend Over Time

| Year | Toshkent sh. (mln UZS) | Qoraqalpog'iston (mln UZS) | Absolute Gap | Ratio |
|------|------------------------|----------------------------|--------------|-------|
| 2010 | 4.21 | 1.50 | 2.71 | 2.8x |
| 2014 | 9.87 | 3.32 | 6.55 | 3.0x |
| 2018 | 18.94 | 6.11 | 12.83 | 3.1x |
| 2020 | 26.33 | 7.89 | 18.44 | 3.3x |
| 2022 | 38.14 | 8.94 | 29.20 | 4.3x |
| 2024 | 60.59 | 9.87 | 50.72 | 6.1x |

## Key Findings

- **The absolute income gap has grown ~18.7x** from 2010 (2.71 mln) to 2024 (50.72 mln UZS)
- **The ratio gap has more than doubled** — from 2.8x in 2010 to 6.1x in 2024
- Toshkent sh. income growth is **accelerating faster** than lagging regions — the gap is widening, not narrowing
- Even the **national average** (38.60 mln in 2024) is well below Toshkent sh., showing capital-region concentration

## Interpretation

> The data reveals a **divergence pattern**: while all regions are growing, Toshkent sh. is growing faster in absolute terms. This suggests that economic activity, investment, and employment opportunities are increasingly concentrated in the capital region.

## Policy / Business Implications
- Current growth model is **not reducing regional inequality** — targeted redistribution policies are needed
- Regions like Qoraqalpog'iston and Surxondaryo need dedicated investment programs
- Monitoring the **ratio gap annually** is a useful KPI for regional development policy effectiveness
