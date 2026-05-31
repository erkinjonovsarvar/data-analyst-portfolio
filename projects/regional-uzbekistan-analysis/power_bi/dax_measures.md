# DAX Measures — Regional Economic Dashboard (Uzbekistan)

> **Jadval nomlari:**
> - `fact_income` — region, year, income_pc
> - `fact_sectors` — region, year, construction, agriculture_output, retail_trade
> - `fact_investment` — region, year, inv_fixed_capital_pc
> - `dim_regions` — region, region_type (Urban/Mixed/Agricultural/Trade)
> - `dim_calendar` — year

---

## 📦 BASE MEASURES (Asosiy o'lchovlar)

```dax
-- Joriy yil uchun tanlangan / filtr bo'yicha o'rtacha daromad
Avg Income PC =
AVERAGE(fact_income[income_pc])

-- Barcha yillar bo'yicha davlat o'rtachasi
National Avg Income =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    ALL(dim_regions),
    ALL(dim_calendar)
)

-- Tanlangan kontekst bo'yicha jami daromad
Total Income =
SUM(fact_income[income_pc])

-- Oxirgi yil (2024) uchun daromad
Income 2024 =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = 2024
)

-- Birinchi yil (2010) uchun daromad
Income 2010 =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = 2010
)
```

---

## 📄 PAGE 1 — Income Overview (Daromad Ko'rinishi)

```dax
-- Eng yuqori daromadli viloyat nomi
Top Region =
CALCULATE(
    SELECTEDVALUE(dim_regions[region]),
    TOPN(1, ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])), DESC
    )
)

-- Eng past daromadli viloyat nomi
Bottom Region =
CALCULATE(
    SELECTEDVALUE(dim_regions[region]),
    TOPN(1, ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])), ASC
    )
)

-- Eng yuqori viloyat daromadi (2024)
Top Region Income =
MAXX(
    ALL(dim_regions[region]),
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        dim_calendar[year] = 2024
    )
)

-- Eng past viloyat daromadi (2024)
Bottom Region Income =
MINX(
    FILTER(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc]), dim_calendar[year] = 2024) > 0
    ),
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        dim_calendar[year] = 2024
    )
)

-- Viloyat daromadi reytingi (har bir viloyat uchun)
Region Income Rank =
RANKX(
    ALL(dim_regions[region]),
    CALCULATE(AVERAGE(fact_income[income_pc])),
    ,
    DESC,
    DENSE
)

-- YoY (Yillik) o'sish foizi
YoY Growth % =
VAR current_year_income =
    CALCULATE(AVERAGE(fact_income[income_pc]))
VAR prev_year_income =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        DATEADD(dim_calendar[date], -1, YEAR)
    )
RETURN
    DIVIDE(current_year_income - prev_year_income, prev_year_income, 0)

-- Alternativa (agar dim_calendar[year] ishlatilsa):
YoY Growth % v2 =
VAR selected_year = SELECTEDVALUE(dim_calendar[year])
VAR cur =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        dim_calendar[year] = selected_year
    )
VAR prev =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        dim_calendar[year] = selected_year - 1
    )
RETURN
    DIVIDE(cur - prev, prev, BLANK())

-- O'sish multiplier (2010 dan 2024 gacha necha baravar o'sdi)
Growth Multiplier 2010_2024 =
DIVIDE([Income 2024], [Income 2010], BLANK())

-- Daromad kvartili (Q1–Q4 segmentatsiya)
Income Quartile =
VAR avg_income =
    CALCULATE(
        AVERAGE(fact_income[income_pc]),
        ALL(dim_calendar)
    )
VAR quartile_rank =
    RANKX(
        ALL(dim_regions[region]),
        CALCULATE(
            AVERAGE(fact_income[income_pc]),
            ALL(dim_calendar)
        ),
        avg_income,
        ASC,
        DENSE
    )
VAR total_regions = COUNTROWS(ALL(dim_regions[region]))
RETURN
    SWITCH(
        TRUE(),
        quartile_rank <= total_regions * 0.25, "Q1 — Past",
        quartile_rank <= total_regions * 0.50, "Q2 — Ortadan past",
        quartile_rank <= total_regions * 0.75, "Q3 — Ortadan yuqori",
        "Q4 — Yuqori"
    )
```

---

## 📄 PAGE 2 — Income Gap Analysis (Tengsizlik Tahlili)

```dax
-- Mutloq farq (Top − Bottom viloyat)
Absolute Gap =
VAR top_income =
    MAXX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
VAR bottom_income =
    MINX(
        FILTER(
            ALL(dim_regions[region]),
            CALCULATE(AVERAGE(fact_income[income_pc])) > 0
        ),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
RETURN
    top_income - bottom_income

-- Nisbiy farq (Gap Ratio = Top / Bottom)
Gap Ratio =
VAR top_income =
    MAXX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
VAR bottom_income =
    MINX(
        FILTER(
            ALL(dim_regions[region]),
            CALCULATE(AVERAGE(fact_income[income_pc])) > 0
        ),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
RETURN
    DIVIDE(top_income, bottom_income, BLANK())

-- Gap Ratio rangini belgilash (conditional formatting uchun)
Gap Ratio Color =
VAR ratio = [Gap Ratio]
RETURN
    SWITCH(
        TRUE(),
        ratio >= 6,  "#C0392B",  -- Qizil: juda katta tengsizlik
        ratio >= 4,  "#E67E22",  -- To'q sariq: o'rta tengsizlik
        ratio >= 2,  "#F1C40F",  -- Sariq: me'yoriy
        "#27AE60"                -- Yashil: yaxshi
    )

-- Toshkent sh. daromadi (yil bo'yicha)
Tashkent Income =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_regions[region] = "Toshkent sh."
)

-- Qoraqalpog'iston daromadi (yil bo'yicha)
Karakalpakstan Income =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_regions[region] = "Qoraqalpog'iston"
)

-- Davlat o'rtachasidan farq (viloyat uchun)
Deviation from National Avg =
VAR region_income = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR national_avg = CALCULATE(AVERAGE(fact_income[income_pc]), ALL(dim_regions))
RETURN
    region_income - national_avg

-- Deviation foizi
Deviation % from Avg =
VAR region_income = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR national_avg = CALCULATE(AVERAGE(fact_income[income_pc]), ALL(dim_regions))
RETURN
    DIVIDE(region_income - national_avg, national_avg, BLANK())

-- Gap trend yo'nalishi (o'sib bormoqdami yoki kamaymoqdami)
Gap Trend Label =
VAR current_gap = [Absolute Gap]
VAR prev_gap =
    CALCULATE(
        [Absolute Gap],
        FILTER(
            ALL(dim_calendar[year]),
            dim_calendar[year] = SELECTEDVALUE(dim_calendar[year]) - 1
        )
    )
RETURN
    IF(current_gap > prev_gap, "▲ Kengaymoqda", "▼ Toraymoqda")
```

---

## 📄 PAGE 3 — Sector Structure (Sektor Tuzilmasi)

```dax
-- Qurilish ulushi (%)
Construction Share % =
VAR construction = SUM(fact_sectors[construction])
VAR agri = SUM(fact_sectors[agriculture_output])
VAR trade = SUM(fact_sectors[retail_trade])
VAR total = construction + agri + trade
RETURN
    DIVIDE(construction, total, 0) * 100

-- Qishloq xo'jaligi ulushi (%)
Agriculture Share % =
VAR construction = SUM(fact_sectors[construction])
VAR agri = SUM(fact_sectors[agriculture_output])
VAR trade = SUM(fact_sectors[retail_trade])
VAR total = construction + agri + trade
RETURN
    DIVIDE(agri, total, 0) * 100

-- Savdo ulushi (%)
Trade Share % =
VAR construction = SUM(fact_sectors[construction])
VAR agri = SUM(fact_sectors[agriculture_output])
VAR trade = SUM(fact_sectors[retail_trade])
VAR total = construction + agri + trade
RETURN
    DIVIDE(trade, total, 0) * 100

-- Ustun sektor (dominant sector per region)
Dominant Sector =
VAR construction = SUM(fact_sectors[construction])
VAR agri = SUM(fact_sectors[agriculture_output])
VAR trade = SUM(fact_sectors[retail_trade])
RETURN
    SWITCH(
        TRUE(),
        construction >= agri && construction >= trade, "🏗️ Qurilish",
        agri >= construction && agri >= trade,         "🌾 Qishloq xo'jaligi",
        "🛒 Savdo"
    )

-- Qurilish o'sish multiplier (2010 dan 2024 gacha)
Construction Growth x =
VAR v2024 =
    CALCULATE(SUM(fact_sectors[construction]), dim_calendar[year] = 2024)
VAR v2010 =
    CALCULATE(SUM(fact_sectors[construction]), dim_calendar[year] = 2010)
RETURN
    DIVIDE(v2024, v2010, BLANK())

-- Qishloq xo'jaligi o'sish multiplier
Agriculture Growth x =
VAR v2024 =
    CALCULATE(SUM(fact_sectors[agriculture_output]), dim_calendar[year] = 2024)
VAR v2010 =
    CALCULATE(SUM(fact_sectors[agriculture_output]), dim_calendar[year] = 2010)
RETURN
    DIVIDE(v2024, v2010, BLANK())

-- Savdo o'sish multiplier
Trade Growth x =
VAR v2024 =
    CALCULATE(SUM(fact_sectors[retail_trade]), dim_calendar[year] = 2024)
VAR v2010 =
    CALCULATE(SUM(fact_sectors[retail_trade]), dim_calendar[year] = 2010)
RETURN
    DIVIDE(v2024, v2010, BLANK())

-- Iqtisodiy diversifikatsiya indeksi (Herfindahl–Hirschman asosida)
-- 0 = to'liq diversifikatsiyalashgan, 1 = monopol sektor
Diversification Index =
VAR s1 = [Construction Share %] / 100
VAR s2 = [Agriculture Share %] / 100
VAR s3 = [Trade Share %] / 100
RETURN
    (s1 * s1) + (s2 * s2) + (s3 * s3)

-- Diversifikatsiya darajasi (matn)
Diversification Level =
VAR hhi = [Diversification Index]
RETURN
    SWITCH(
        TRUE(),
        hhi >= 0.5,  "🔴 Past diversifikatsiya (xavfli)",
        hhi >= 0.35, "🟡 O'rta diversifikatsiya",
        "🟢 Yaxshi diversifikatsiya"
    )
```

---

## 📄 PAGE 4 — Economic Drivers (Iqtisodiy Harakatlantiruvchilar)

```dax
-- Investitsiya per capita (joriy)
Avg Investment PC =
AVERAGE(fact_investment[inv_fixed_capital_pc])

-- Investitsiya o'sish (YoY)
Investment YoY % =
VAR selected_year = SELECTEDVALUE(dim_calendar[year])
VAR cur =
    CALCULATE(
        AVERAGE(fact_investment[inv_fixed_capital_pc]),
        dim_calendar[year] = selected_year
    )
VAR prev =
    CALCULATE(
        AVERAGE(fact_investment[inv_fixed_capital_pc]),
        dim_calendar[year] = selected_year - 1
    )
RETURN
    DIVIDE(cur - prev, prev, BLANK())

-- Investitsiya reytingi (viloyatlar bo'yicha)
Investment Rank =
RANKX(
    ALL(dim_regions[region]),
    CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc])),
    ,
    DESC,
    DENSE
)

-- Eng kuchli harakatlantiruvchi (hardcoded yoki dinamik)
Top Driver Label =
"💡 Eng kuchli omil: Investitsiya (r = 0.97)"

-- Investment vs Income Ratio (relative positioning)
Investment to Income Ratio =
DIVIDE(
    CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc])),
    CALCULATE(AVERAGE(fact_income[income_pc])),
    BLANK()
)

-- Investment indeksi (xarita yoki scatter uchun normalizatsiya)
Investment Index (0-100) =
VAR val = CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]))
VAR min_val =
    MINX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]))
    )
VAR max_val =
    MAXX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_investment[inv_fixed_capital_pc]))
        )
RETURN
    DIVIDE(val - min_val, max_val - min_val, BLANK()) * 100

-- Income indeksi (scatter uchun)
Income Index (0-100) =
VAR val = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR min_val =
    MINX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
VAR max_val =
    MAXX(
        ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
RETURN
    DIVIDE(val - min_val, max_val - min_val, BLANK()) * 100

-- Korrelyatsiya matni (informatsion karta uchun)
Correlation Summary Text =
"Investitsiya: r=0.97 | GRP: r=0.91 | Savdo: r=0.86 | Qurilish: r=0.89 | Q/X: r=0.43 | Bandlik: r=0.31"
```

---

## 🎨 CONDITIONAL FORMATTING MEASURES

```dax
-- Daromad rangi (heat map uchun)
Income Color =
VAR val = CALCULATE(AVERAGE(fact_income[income_pc]))
VAR max_val =
    MAXX(ALL(dim_regions[region]), CALCULATE(AVERAGE(fact_income[income_pc])))
VAR min_val =
    MINX(
        FILTER(ALL(dim_regions[region]), CALCULATE(AVERAGE(fact_income[income_pc])) > 0),
        CALCULATE(AVERAGE(fact_income[income_pc]))
    )
VAR normalized = DIVIDE(val - min_val, max_val - min_val, 0)
RETURN
    SWITCH(
        TRUE(),
        normalized >= 0.75, "#1A5276",  -- To'q ko'k: eng yuqori
        normalized >= 0.50, "#2E86C1",  -- Ko'k: yuqori
        normalized >= 0.25, "#85C1E9",  -- Och ko'k: o'rta
        "#D6EAF8"                        -- Juda och: past
    )

-- YoY o'sish rangi
YoY Color =
IF([YoY Growth % v2] >= 0, "#27AE60", "#C0392B")

-- Tengsizlik darajasi rangi
Gap Color =
VAR ratio = [Gap Ratio]
RETURN
    IF(ratio >= 5, "#C0392B", IF(ratio >= 3, "#E67E22", "#27AE60"))
```

---

## 📌 KPI CARD MEASURES

```dax
-- Davlat o'rtacha daromadi (2024)
KPI National Avg 2024 =
CALCULATE(
    AVERAGE(fact_income[income_pc]),
    dim_calendar[year] = 2024,
    ALL(dim_regions)
)

-- Eng yuqori daromad (2024)
KPI Top Income 2024 = [Top Region Income]

-- Eng past daromad (2024)
KPI Bottom Income 2024 = [Bottom Region Income]

-- Gap ratio (2024)
KPI Gap Ratio 2024 =
CALCULATE([Gap Ratio], dim_calendar[year] = 2024)

-- O'sish multiplier matn
KPI Growth Text =
"17.6x o'sdi (2010→2024)"
```

---

## 🧮 CALCULATED COLUMNS (Hisoblangan ustunlar)

```dax
-- dim_regions jadvaliga qo'shish:

-- Viloyat turi (manuyal yoki formuladan)
Region Type =
SWITCH(
    dim_regions[region],
    "Toshkent sh.",   "Urban/Industrial",
    "Navoiy",         "Urban/Industrial",
    "Toshkent vil.",  "Mixed",
    "Buxoro",         "Mixed",
    "Samarqand",      "Mixed",
    "Qashqadaryo",    "Mixed",
    "Farg'ona",       "Trade-oriented",
    "Andijon",        "Trade-oriented",
    "Namangan",       "Trade-oriented",
    "Jizzax",         "Agricultural",
    "Sirdaryo",       "Agricultural",
    "Xorazm",         "Agricultural",
    "Surxondaryo",    "Agricultural",
    "Qoraqalpog'iston", "Agricultural",
    "Noma'lum"
)

-- Viloyat guruhi (shimol/janub/markaz)
Region Zone =
SWITCH(
    dim_regions[region],
    "Toshkent sh.",   "Markaziy",
    "Toshkent vil.",  "Markaziy",
    "Jizzax",         "Markaziy",
    "Sirdaryo",       "Markaziy",
    "Samarqand",      "Janubiy-Markaziy",
    "Qashqadaryo",    "Janubiy",
    "Surxondaryo",    "Janubiy",
    "Buxoro",         "G'arbiy",
    "Navoiy",         "G'arbiy",
    "Xorazm",         "G'arbiy",
    "Qoraqalpog'iston", "G'arbiy",
    "Farg'ona",       "Sharqiy",
    "Andijon",        "Sharqiy",
    "Namangan",       "Sharqiy",
    "Noma'lum"
)

-- fact_income jadvaliga:
-- Daromad o'sish foizi (oldingi yil bilan)
-- (Calculated Column sifatida foydalanilmaydi, Measure ishlatiladi)
```

---

## 🗓️ DIM_CALENDAR jadvalini yaratish (New Table)

```dax
dim_calendar =
ADDCOLUMNS(
    GENERATESERIES(2010, 2024, 1),
    "year", [Value],
    "decade",
        SWITCH(
            TRUE(),
            [Value] <= 2014, "2010-2014",
            [Value] <= 2019, "2015-2019",
            "2020-2024"
        ),
    "period_label",
        SWITCH(
            TRUE(),
            [Value] <= 2014, "Dastlabki davr",
            [Value] <= 2019, "O'tish davri",
            "Zamonaviy davr"
        )
)
```

---

## 📐 MEASURES TABLE STRUCTURE (Tavsiya etilgan tartib)

```
📁 _Measures (jadvalsiz measures papkasi)
  ├── 📂 00_Base
  │   ├── Avg Income PC
  │   ├── National Avg Income
  │   └── Total Income
  ├── 📂 01_Income Overview
  │   ├── Income 2024
  │   ├── Top Region Income
  │   ├── Bottom Region Income
  │   ├── YoY Growth % v2
  │   ├── Growth Multiplier 2010_2024
  │   └── Income Quartile
  ├── 📂 02_Gap Analysis
  │   ├── Absolute Gap
  │   ├── Gap Ratio
  │   ├── Deviation from National Avg
  │   └── Gap Trend Label
  ├── 📂 03_Sector Structure
  │   ├── Construction Share %
  │   ├── Agriculture Share %
  │   ├── Trade Share %
  │   ├── Dominant Sector
  │   └── Diversification Index
  ├── 📂 04_Drivers
  │   ├── Avg Investment PC
  │   ├── Investment YoY %
  │   └── Investment Index (0-100)
  └── 📂 05_KPI Cards
      ├── KPI National Avg 2024
      ├── KPI Top Income 2024
      ├── KPI Bottom Income 2024
      └── KPI Gap Ratio 2024
```
