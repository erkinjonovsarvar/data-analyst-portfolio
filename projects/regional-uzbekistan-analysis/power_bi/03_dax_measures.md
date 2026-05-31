# STEP 3 — DAX Measures: To'liq va Ishlaydigan
## Power BI Desktop → _Measures jadvali

> **Qo'shish usuli:** Report View yoki Model View →
> `_Measures` jadvalini tanlang → Table tools → **New Measure**
> Har bir DAX ni nom bilan kiriting, Enter bosing.
>
> **Papka (Display Folder) berish:**
> Measure ni tanlang → Properties paneli → Display Folder → nom kiriting.

---

## 📂 PAPKA: 00_Base

> Barcha boshqa measurelar shu asosiy measurelarga tayanadi.
> Avval shu 5 tasini yarating.

---

### [1] Avg Income PC
```dax
Avg Income PC =
AVERAGE(fact_income[income_pc])
```
> Filtr kontekstidagi o'rtacha daromad.
> Slicer → viloyat yoki yil tanlanganda avtomatik o'zgaradi.

---

### [2] National Avg Income
```dax
National Avg Income =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    ALL(dim_regions),
    ALL(dim_calendar)
)
```
> Barcha viloyat va barcha yillar bo'yicha umumiy o'rtacha.
> Hech qanday slicer ta'sir qilmaydi — doimiy benchmark.
> **2010–2024 o'rtacha: ~17.5 mln UZS**

---

### [3] Income Latest Year
```dax
Income Latest Year =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = 2024
)
```
> 2024 yil uchun daromad. Yil slicer ta'sir qilmaydi.

---

### [4] Income First Year
```dax
Income First Year =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = 2010
)
```
> 2010 yil uchun daromad. Taqqoslash uchun asos.

---

### [5] Selected Year Income
```dax
Selected Year Income =
VAR sel_year = SELECTEDVALUE(dim_calendar[year], 2024)
RETURN
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = sel_year
)
```
> Slicer da tanlangan yil uchun daromad.
> Hech narsa tanlanmasa — 2024 qaytaradi (default).

---

## 📂 PAPKA: 01_Income_Overview

---

### [6] Top Region Income
```dax
Top Region Income =
MAXX(
    ALL(dim_regions[region]),
    CALCULATE(AVERAGE(fact_income[income_pc]))
)
```
> Joriy yil filtrida eng yuqori viloyat daromadi.
> **2024: 60.59 mln UZS (Toshkent sh.)**

---

### [7] Bottom Region Income
```dax
Bottom Region Income =
VAR tbl =
    FILTER(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])) > 0
    )
RETURN
MINX(tbl, CALCULATE(AVERAGE(fact_income[income_pc])))
```
> Joriy yil filtrida eng past viloyat daromadi (0 dan katta).
> **2024: 9.87 mln UZS (Qoraqalpog'iston)**

---

### [8] Top Region Name
```dax
Top Region Name =
VAR top_val = [Top Region Income]
VAR top_region =
    FILTER(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])) = top_val
    )
RETURN
MAXX(top_region, dim_regions[region])
```
> Eng yuqori daromadli viloyat nomi (matn).
> KPI Card subtitle uchun ishlatiladi.

---

### [9] Bottom Region Name
```dax
Bottom Region Name =
VAR bot_val = [Bottom Region Income]
VAR bot_region =
    FILTER(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])) = bot_val
    )
RETURN
MAXX(bot_region, dim_regions[region])
```

---

### [10] Region Income Rank
```dax
Region Income Rank =
IF(
    HASONEVALUE(dim_regions[region]),
    RANKX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])),
        ,
        DESC,
        DENSE
    )
)
```
> Bar chart da viloyatlarni daromad bo'yicha tartiblash uchun.
> `HASONEVALUE` — faqat bitta viloyat tanlanganda ishlaydi.

---

### [11] YoY Growth Pct
```dax
YoY Growth Pct =
VAR cur_year  = SELECTEDVALUE(dim_calendar[year])
VAR cur_val   =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        dim_calendar[year] = cur_year
    )
VAR prev_val  =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        dim_calendar[year] = cur_year - 1
    )
RETURN
IF(
    NOT ISBLANK(prev_val) && prev_val <> 0,
    DIVIDE(cur_val - prev_val, prev_val),
    BLANK()
)
```
> Yillik o'sish foizi. Line chart uchun yil bo'yicha o'zgaradi.
> Format: Percentage, 1 decimal.

---

### [12] Growth Multiplier
```dax
Growth Multiplier =
VAR val_2024 = [Income Latest Year]
VAR val_2010 = [Income First Year]
RETURN
IF(
    val_2010 > 0,
    ROUND(DIVIDE(val_2024, val_2010), 1),
    BLANK()
)
```
> 2010 dan 2024 gacha necha baravar o'sdi.
> **Milliy o'rtacha: 17.6x**

---

### [13] Income Quartile Label
```dax
Income Quartile Label =
VAR cur_income =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        ALL(dim_calendar)
    )
VAR rnk =
    RANKX(
        ALL(dim_regions[region]),
        CALCULATE(
            AVERAGE(fact_income[income_pc]),
            ALL(dim_calendar)
        ),
        cur_income,
        ASC,
        DENSE
    )
RETURN
SWITCH(
    TRUE(),
    rnk <= 3,  "Q1 — Past (≤ 8.9 mln)",
    rnk <= 7,  "Q2 — Ortadan past (8.9–10 mln)",
    rnk <= 10, "Q3 — Ortadan yuqori (10–14 mln)",
    "Q4 — Yuqori (14+ mln)"
)
```
> 14 viloyatni 4 guruhga ajratadi (3-4-3-4 bo'linish).

---

### [14] Deviation from Avg
```dax
Deviation from Avg =
VAR region_val  = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR national    = CALCULATE(AVERAGE(fact_income[income_pc]), ALL(dim_regions))
RETURN
region_val - national
```
> Viloyat daromadi milliy o'rtachadan qancha farq qiladi.
> Musbat = o'rtachadan yuqori | Manfiy = o'rtachadan past.

---

### [15] Deviation Pct from Avg
```dax
Deviation Pct from Avg =
VAR region_val = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR national   = CALCULATE(AVERAGE(fact_income[income_pc]), ALL(dim_regions))
RETURN
DIVIDE(region_val - national, national, BLANK())
```
> Format: Percentage, 1 decimal.

---

## 📂 PAPKA: 02_Gap_Analysis

---

### [16] Absolute Gap
```dax
Absolute Gap =
[Top Region Income] - [Bottom Region Income]
```
> Eng yuqori va eng past viloyat daromadi orasidagi mutloq farq.
> **2024: 50.72 mln UZS | 2010: 2.71 mln UZS**

---

### [17] Gap Ratio
```dax
Gap Ratio =
DIVIDE(
    [Top Region Income],
    [Bottom Region Income],
    BLANK()
)
```
> Top / Bottom nisbat.
> **2024: 6.14x | 2010: 2.81x**
> Format: Decimal Number, 2 decimal + "x" suffix (Format String: `0.00"x"`)

---

### [18] Gap Ratio 2024
```dax
Gap Ratio 2024 =
CALCULATE(
    [Gap Ratio],
    dim_calendar[year] = 2024
)
```
> KPI Card uchun — slicer ta'sir qilmaydi.

---

### [19] Gap Ratio 2010
```dax
Gap Ratio 2010 =
CALCULATE(
    [Gap Ratio],
    dim_calendar[year] = 2010
)
```

---

### [20] Gap Change Since 2010
```dax
Gap Change Since 2010 =
[Gap Ratio 2024] - [Gap Ratio 2010]
```
> **Natija: +3.33x** — tengsizlik kengaydi.

---

### [21] Gap Trend Label
```dax
Gap Trend Label =
VAR cur_year = SELECTEDVALUE(dim_calendar[year])
VAR cur_gap  =
    CALCULATE([Absolute Gap], dim_calendar[year] = cur_year)
VAR prv_gap  =
    CALCULATE([Absolute Gap], dim_calendar[year] = cur_year - 1)
RETURN
IF(
    ISBLANK(prv_gap),
    "—",
    IF(cur_gap > prv_gap, "▲ Kengaymoqda", "▼ Toraymoqda")
)
```
> KPI Card uchun dinamik matn.

---

### [22] Tashkent Income
```dax
Tashkent Income =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_regions[region] = "Toshkent sh."
)
```
> **2024: 60.59 mln UZS**

---

### [23] Karakalpakstan Income
```dax
Karakalpakstan Income =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_regions[region] = "Qoraqalpog'iston"
)
```
> **2024: 9.87 mln UZS**

---

### [24] Heatmap Income Value
```dax
Heatmap Income Value =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    ALL(dim_calendar)
)
```
> Matrix (Heatmap) visuals uchun — yil filtrini o'chirib,
> har viloyat uchun barcha yillar o'rtacha ko'rsatadi.

---

## 📂 PAPKA: 03_Sector_Structure

---

### [25] Total Sector Output
```dax
Total Sector Output =
VAR c = SUM(fact_sectors[construction])
VAR a = SUM(fact_sectors[agriculture_output])
VAR t = SUM(fact_sectors[retail_trade])
RETURN c + a + t
```
> Uch sektorning umumiy yig'indisi. Qolgan share measurelar uchun asos.

---

### [26] Construction Share Pct
```dax
Construction Share Pct =
DIVIDE(
    SUM(fact_sectors[construction]),
    [Total Sector Output],
    0
)
```
> Format: Percentage, 1 decimal.
> **2024 milliy: ~28%**

---

### [27] Agriculture Share Pct
```dax
Agriculture Share Pct =
DIVIDE(
    SUM(fact_sectors[agriculture_output]),
    [Total Sector Output],
    0
)
```
> **2024 milliy: ~33%**

---

### [28] Trade Share Pct
```dax
Trade Share Pct =
DIVIDE(
    SUM(fact_sectors[retail_trade]),
    [Total Sector Output],
    0
)
```
> **2024 milliy: ~44%**

---

### [29] Dominant Sector
```dax
Dominant Sector =
VAR c = SUM(fact_sectors[construction])
VAR a = SUM(fact_sectors[agriculture_output])
VAR t = SUM(fact_sectors[retail_trade])
RETURN
SWITCH(
    TRUE(),
    c >= a && c >= t, "Qurilish",
    a >= c && a >= t, "Qishloq xo'jaligi",
    t >= c && t >= a, "Savdo",
    "Teng"
)
```

---

### [30] Construction Growth X
```dax
Construction Growth X =
VAR v2024 =
    CALCULATE(SUM(fact_sectors[construction]),  dim_calendar[year] = 2024)
VAR v2010 =
    CALCULATE(SUM(fact_sectors[construction]),  dim_calendar[year] = 2010)
RETURN
IF(
    v2010 > 0,
    ROUND(DIVIDE(v2024, v2010), 1),
    BLANK()
)
```
> **Natija: 8.4x**

---

### [31] Agriculture Growth X
```dax
Agriculture Growth X =
VAR v2024 =
    CALCULATE(SUM(fact_sectors[agriculture_output]), dim_calendar[year] = 2024)
VAR v2010 =
    CALCULATE(SUM(fact_sectors[agriculture_output]), dim_calendar[year] = 2010)
RETURN
IF(v2010 > 0, ROUND(DIVIDE(v2024, v2010), 1), BLANK())
```
> **Natija: 5.3x**

---

### [32] Trade Growth X
```dax
Trade Growth X =
VAR v2024 =
    CALCULATE(SUM(fact_sectors[retail_trade]), dim_calendar[year] = 2024)
VAR v2010 =
    CALCULATE(SUM(fact_sectors[retail_trade]), dim_calendar[year] = 2010)
RETURN
IF(v2010 > 0, ROUND(DIVIDE(v2024, v2010), 1), BLANK())
```
> **Natija: 4.9x**

---

### [33] Diversification Index
```dax
Diversification Index =
VAR s1 = [Construction Share Pct]
VAR s2 = [Agriculture Share Pct]
VAR s3 = [Trade Share Pct]
RETURN
ROUND((s1 * s1) + (s2 * s2) + (s3 * s3), 4)
```
> Herfindahl–Hirschman Index (HHI).
> 0.33 = mukammal teng taqsimot | 1.0 = monopol sektor.
> Format: Decimal Number, 3 decimal.

---

### [34] Diversification Level
```dax
Diversification Level =
VAR hhi = [Diversification Index]
RETURN
SWITCH(
    TRUE(),
    hhi >= 0.55, "Past diversifikatsiya",
    hhi >= 0.40, "O'rta diversifikatsiya",
    "Yaxshi diversifikatsiya"
)
```

---

## 📂 PAPKA: 04_Drivers

---

### [35] Avg Investment PC
```dax
Avg Investment PC =
AVERAGE(fact_investment[inv_fixed_capital_pc])
```

---

### [36] Investment YoY Pct
```dax
Investment YoY Pct =
VAR cur_year = SELECTEDVALUE(dim_calendar[year])
VAR cur_val  =
    CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]),
        dim_calendar[year] = cur_year)
VAR prv_val  =
    CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]),
        dim_calendar[year] = cur_year - 1)
RETURN
IF(
    NOT ISBLANK(prv_val) && prv_val <> 0,
    DIVIDE(cur_val - prv_val, prv_val),
    BLANK()
)
```
> Format: Percentage, 1 decimal.

---

### [37] Investment Rank
```dax
Investment Rank =
IF(
    HASONEVALUE(dim_regions[region]),
    RANKX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc])),
        ,
        DESC,
        DENSE
    )
)
```

---

### [38] Investment Index Normalized
```dax
Investment Index Normalized =
VAR val     = CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]))
VAR min_val =
    MINX(
        FILTER(
            ALL(dim_regions[region]),
            CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc])) > 0
        ),
        CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]))
    )
VAR max_val =
    MAXX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]))
    )
RETURN
ROUND(DIVIDE(val - min_val, max_val - min_val, BLANK()) * 100, 1)
```
> 0–100 shkala. Scatter chart X o'qi uchun.

---

### [39] Income Index Normalized
```dax
Income Index Normalized =
VAR val     = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR min_val =
    MINX(
        FILTER(
            ALL(dim_regions[region]),
            CALCULATE(AVERAGE(fact_income[income_pc])) > 0
        ),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
VAR max_val =
    MAXX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
RETURN
ROUND(DIVIDE(val - min_val, max_val - min_val, BLANK()) * 100, 1)
```
> 0–100 shkala. Scatter chart Y o'qi uchun.

---

### [40] Investment to Income Ratio
```dax
Investment to Income Ratio =
DIVIDE(
    CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc])),
    CALCULATE(AVERAGE(fact_income[income_pc])),
    BLANK()
)
```
> 1.0 ga yaqin = investitsiya daromad bilan teng.
> > 1.0 = investitsiya daromaddan yuqori (rivojlanayotgan hudud).

---

### [41] Correlation Investment Income
```dax
Correlation Investment Income =
0.97
```
> Python tahlilidan olingan Pearson r qiymati.
> KPI Card va annotation uchun.

---

### [42] Correlation Agriculture Income
```dax
Correlation Agriculture Income =
0.43
```

---

### [43] Correlation Construction Income
```dax
Correlation Construction Income =
0.89
```

---

### [44] Correlation Trade Income
```dax
Correlation Trade Income =
0.86
```

---

## 📂 PAPKA: 05_KPI_Cards

---

### [45] KPI National Avg 2024
```dax
KPI National Avg 2024 =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = 2024,
    ALL(dim_regions)
)
```
> **38.60 mln UZS**. Format: `#,##0.00 "mln UZS"`

---

### [46] KPI Top Income 2024
```dax
KPI Top Income 2024 =
CALCULATE(
    [Top Region Income],
    dim_calendar[year] = 2024
)
```
> **60.59 mln UZS (Toshkent sh.)**

---

### [47] KPI Bottom Income 2024
```dax
KPI Bottom Income 2024 =
CALCULATE(
    [Bottom Region Income],
    dim_calendar[year] = 2024
)
```
> **9.87 mln UZS (Qoraqalpog'iston)**

---

### [48] KPI Gap Ratio 2024
```dax
KPI Gap Ratio 2024 =
CALCULATE(
    [Gap Ratio],
    dim_calendar[year] = 2024,
    ALL(dim_regions)
)
```
> **6.14x**. Format: `0.0"x"`

---

### [49] KPI Absolute Gap 2024
```dax
KPI Absolute Gap 2024 =
CALCULATE(
    [Absolute Gap],
    dim_calendar[year] = 2024,
    ALL(dim_regions)
)
```
> **50.72 mln UZS**

---

### [50] KPI Growth Multiplier National
```dax
KPI Growth Multiplier National =
CALCULATE(
    [Growth Multiplier],
    ALL(dim_regions)
)
```
> **17.6x**. Format: `0.0"x o'sdi (2010→2024)"`

---

## 📂 PAPKA: 06_Formatting

> Bu measurelar vizuallarga rang berish uchun ishlatiladi.
> Visual → Format → Conditional Formatting → Field value → bu measure

---

### [51] Color Income Bar
```dax
Color Income Bar =
VAR val     = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR max_val =
    MAXX(ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])))
VAR norm    = DIVIDE(val, max_val, 0)
RETURN
SWITCH(
    TRUE(),
    norm >= 0.75, "#1A5276",
    norm >= 0.50, "#2E86C1",
    norm >= 0.25, "#85C1E9",
    "#D6EAF8"
)
```
> Bar chart bar rengi (to'q ko'k = yuqori, och ko'k = past).

---

### [52] Color YoY Arrow
```dax
Color YoY Arrow =
IF(
    ISNUMBER([YoY Growth Pct]) && [YoY Growth Pct] >= 0,
    "#27AE60",
    "#C0392B"
)
```
> Yashil = o'sish | Qizil = pasayish.

---

### [53] Color Gap Ratio
```dax
Color Gap Ratio =
VAR r = [Gap Ratio]
RETURN
SWITCH(
    TRUE(),
    r >= 6.0, "#C0392B",
    r >= 4.0, "#E67E22",
    r >= 2.5, "#F1C40F",
    "#27AE60"
)
```
> Qizil = juda katta tengsizlik (≥6x).

---

### [54] Color Deviation Bar
```dax
Color Deviation Bar =
IF(
    [Deviation from Avg] >= 0,
    "#2E86C1",
    "#E74C3C"
)
```
> Ko'k = o'rtachadan yuqori | Qizil = o'rtachadan past.
> Waterfall / Diverging bar chart uchun.

---

### [55] Icon YoY
```dax
Icon YoY =
VAR g = [YoY Growth Pct]
RETURN
SWITCH(
    TRUE(),
    ISBLANK(g),    "—",
    g >= 0.15,     "🚀 +Tez o'smoqda",
    g >= 0.05,     "📈 O'smoqda",
    g >= 0,        "➡️ Barqaror",
    g >= -0.05,    "📉 Biroz pasaydi",
    "⚠️ Keskin pasaydi"
)
```
> Tooltip yoki Table da matn ikonka sifatida.

---

## 📋 Barcha Measures — Yakuniy Ro'yxat

| # | Measure nomi | Papka | Qayerda ishlatiladi |
|---|-------------|-------|---------------------|
| 1 | Avg Income PC | 00_Base | Barcha sahifalar |
| 2 | National Avg Income | 00_Base | Benchmark liniya |
| 3 | Income Latest Year | 00_Base | KPI Cards |
| 4 | Income First Year | 00_Base | Growth hisob |
| 5 | Selected Year Income | 00_Base | Dynamic KPI |
| 6 | Top Region Income | 01_Income | KPI, Bar |
| 7 | Bottom Region Income | 01_Income | KPI, Bar |
| 8 | Top Region Name | 01_Income | Card subtitle |
| 9 | Bottom Region Name | 01_Income | Card subtitle |
| 10 | Region Income Rank | 01_Income | Bar sort |
| 11 | YoY Growth Pct | 01_Income | Line, KPI |
| 12 | Growth Multiplier | 01_Income | KPI Card |
| 13 | Income Quartile Label | 01_Income | Matrix, Slicer |
| 14 | Deviation from Avg | 01_Income | Waterfall |
| 15 | Deviation Pct from Avg | 01_Income | Table |
| 16 | Absolute Gap | 02_Gap | KPI, Line |
| 17 | Gap Ratio | 02_Gap | KPI, Line |
| 18 | Gap Ratio 2024 | 02_Gap | KPI Card |
| 19 | Gap Ratio 2010 | 02_Gap | KPI Card |
| 20 | Gap Change Since 2010 | 02_Gap | KPI Card |
| 21 | Gap Trend Label | 02_Gap | Card label |
| 22 | Tashkent Income | 02_Gap | Clustered Bar |
| 23 | Karakalpakstan Income | 02_Gap | Clustered Bar |
| 24 | Heatmap Income Value | 02_Gap | Matrix heatmap |
| 25 | Total Sector Output | 03_Sector | Base for shares |
| 26 | Construction Share Pct | 03_Sector | Stacked Bar, Donut |
| 27 | Agriculture Share Pct | 03_Sector | Stacked Bar, Donut |
| 28 | Trade Share Pct | 03_Sector | Stacked Bar, Donut |
| 29 | Dominant Sector | 03_Sector | Table |
| 30 | Construction Growth X | 03_Sector | KPI Card |
| 31 | Agriculture Growth X | 03_Sector | KPI Card |
| 32 | Trade Growth X | 03_Sector | KPI Card |
| 33 | Diversification Index | 03_Sector | KPI, Table |
| 34 | Diversification Level | 03_Sector | Table label |
| 35 | Avg Investment PC | 04_Drivers | Bar, KPI |
| 36 | Investment YoY Pct | 04_Drivers | Line |
| 37 | Investment Rank | 04_Drivers | Bar sort |
| 38 | Investment Index Normalized | 04_Drivers | Scatter X |
| 39 | Income Index Normalized | 04_Drivers | Scatter Y |
| 40 | Investment to Income Ratio | 04_Drivers | Table |
| 41 | Correlation Investment Income | 04_Drivers | Annotation |
| 42 | Correlation Agriculture Income | 04_Drivers | Annotation |
| 43 | Correlation Construction Income | 04_Drivers | Annotation |
| 44 | Correlation Trade Income | 04_Drivers | Annotation |
| 45 | KPI National Avg 2024 | 05_KPI | KPI Card |
| 46 | KPI Top Income 2024 | 05_KPI | KPI Card |
| 47 | KPI Bottom Income 2024 | 05_KPI | KPI Card |
| 48 | KPI Gap Ratio 2024 | 05_KPI | KPI Card |
| 49 | KPI Absolute Gap 2024 | 05_KPI | KPI Card |
| 50 | KPI Growth Multiplier National | 05_KPI | KPI Card |
| 51 | Color Income Bar | 06_Formatting | Cond. Formatting |
| 52 | Color YoY Arrow | 06_Formatting | Cond. Formatting |
| 53 | Color Gap Ratio | 06_Formatting | Cond. Formatting |
| 54 | Color Deviation Bar | 06_Formatting | Cond. Formatting |
| 55 | Icon YoY | 06_Formatting | Tooltip, Table |

---

## ✅ DAX Tekshiruv Ro'yxati

- [ ] `_Measures` jadvali yaratilgan
- [ ] Barcha 55 ta measure qo'shilgan
- [ ] Har bir measure to'g'ri Display Folder da
- [ ] KPI measurelar 2024 yilini `ALL()` bilan lock qilgan
- [ ] Color measurelar hex kod qaytarmoqda
- [ ] `DIVIDE()` ning uchinchi argumenti (`BLANK()` yoki `0`) belgilangan
- [ ] `HASONEVALUE()` ishlatilgan joylarda (Rank) to'g'ri ishlaydi
- [ ] Format Strings qo'shilgan:
  - `income_pc` ustunlari: `#,##0.00`
  - Percentage measurelar: `0.0%`
  - Ratio measurelar: `0.00"x"`
  - Growth multiplier: `0.0"x"`
