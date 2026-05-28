# Income Drivers Correlation — Uzbekistan (Stat.uz)

## Business Question
Which economic sectors are most strongly associated with regional income levels?

## Method
- Aggregated `income_pc`, `construction`, `agriculture_output`, `retail_trade`, and `inv_fixed_capital_pc` by region
- Used Pearson correlation to measure the linear relationship between income and each sector indicator
- Data covers 14 regions × 15 years (2010–2024) = 210 observations

## Correlation Results

| Driver | Correlation with Income pc | Strength | Direction |
|--------|-----------------------------|----------|-----------|
| **Investment (Fixed Capital pc)** | **+0.97** | Very Strong | Positive |
| **Construction** | **+0.89** | Strong | Positive |
| **Retail Trade** | **+0.86** | Strong | Positive |
| **Wholesale Trade** | **+0.84** | Strong | Positive |
| **GRP (Gross Regional Product)** | **+0.91** | Very Strong | Positive |
| **Agriculture Output** | **+0.43** | Moderate | Positive |
| **Employment Rate** | **+0.31** | Weak | Positive |

> Correlation scale: 0.9–1.0 = Very Strong | 0.7–0.9 = Strong | 0.4–0.7 = Moderate | < 0.4 = Weak

## Scatter Insight — Top vs Bottom Region

| Metric | Toshkent sh. (2024) | Qoraqalpog'iston (2024) |
|--------|---------------------|--------------------------|
| Income pc (mln UZS) | 60.59 | 9.87 |
| Investment pc (mln UZS) | 60.59 | 9.87 |
| Construction (mln UZS) | 69,012,300 | 4,100,000 |
| Agriculture Output | ~0 | 4,200,000 |
| Retail Trade | 108,188,000 | 6,300,000 |

## Key Findings

- **Investment per capita** has the strongest correlation with income (r = +0.97) — regions that attract more capital investment consistently show higher income levels
- **GRP** is also very strongly correlated (r = +0.91) — confirming that economic productivity directly translates to income
- **Construction and trade** (r = +0.86–0.89) are strong income drivers — reflecting urbanization and commercial activity
- **Agriculture has only moderate correlation** (r = +0.43) — despite being the dominant sector in many regions, it does not translate as strongly into higher per-capita income
- **Employment rate has weak correlation** (r = +0.31) — having more employed people doesn't guarantee higher income without productivity growth

## Interpretation

> The strongest income drivers are **investment and industrial/commercial activity**, not agricultural output. This suggests that regions relying primarily on agriculture face a structural ceiling on income growth unless they diversify into higher-value sectors.

## Policy / Business Implications
- **Prioritize investment attraction** (FDI, infrastructure, SEZs) in low-income regions — it has the highest income payoff
- **Agriculture modernization** (agro-processing, export-oriented farming) could raise agriculture's income correlation from moderate to strong
- **Trade infrastructure** (logistics hubs, wholesale markets) in regions like Qoraqalpog'iston and Surxondaryo could boost income
- Monitor **investment per capita as a leading KPI** for regional development — it predicts income growth better than any other single indicator
