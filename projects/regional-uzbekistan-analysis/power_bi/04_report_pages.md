# STEP 4 — Report Pages: Vizual Sozlamalar
## Power BI Desktop → Report View

> **Canvas o'lchamlari:** File → Options → Report settings
> → Canvas size: **Custom → Width: 1280 px, Height: 720 px** (16:9)
>
> **Har bir vizualni qo'shish:** Visualizations panelidan ikonkani bosing →
> Canvas ga joylang → Fields panelidan maydonlarni DRAG qiling.

---

## 🎨 UMUMIY SAHIFA TUZILMASI (Har 4 sahifada takrorlanadi)

```
┌──────────────────────────────────────────────────────────────────┐
│ [Logo/Title Area — 1280×60px]                                    │
│  Sarlavha matn | Manba: Stat.uz | Slicer 1 | Slicer 2           │
├──────────┬──────────┬──────────┬───────────────────────────────┤
│  KPI     │  KPI     │  KPI     │  KPI                           │
│  Card    │  Card    │  Card    │  Card                          │
│ 200×120  │ 200×120  │ 200×120  │ 200×120                        │
├──────────┴──────────┴──────────┴───────────────────────────────┤
│                                │                                 │
│   Asosiy visual (katta)        │   Qo'shimcha visual            │
│   620×340 px                   │   580×340 px                   │
│                                │                                 │
├────────────────────────────────┴─────────────────────────────── ┤
│   Pastki visual (keng) — 1240×140 px                            │
└──────────────────────────────────────────────────────────────────┘
```



---

## 📄 PAGE 1 — Income Overview (Daromad Ko'rinishi)

> **Sahifa qo'shish:** Report View pastida **"+"** belgisini bosing →
> Sahifani o'ng klik → Rename → `01_Income_Overview`

### 🔲 HEADER — Title Box
```
Visual turi : Text Box
O'lcham     : 1240 × 50 px
Joylashuv   : X=20, Y=10
Matn        : "O'ZBEKISTON VILOYATLARI: DAROMAD KO'RINISHI"
Font        : Segoe UI Semibold, 18pt, oq (#FFFFFF)
Background  : #1A5276
```

### 🔲 SUBTITLE + SOURCE Box
```
Visual turi : Text Box
O'lcham     : 900 × 25 px
Joylashuv   : X=20, Y=62
Matn        : "Manba: Stat.uz  |  14 viloyat  |  2010–2024"
Font        : Segoe UI, 10pt, #7F8C8D
Background  : Yo'q (transparent)
```

### 🔲 SLICER 1 — Yil
```
Visual turi : Slicer
O'lcham     : 160 × 50 px
Joylashuv   : X=920, Y=62
Field       : dim_calendar[year]
Slicer type : Between (slider)
Format      : Header "Yil" | Font: 9pt | Border: yoq
Default     : 2024
```

### 🔲 SLICER 2 — Viloyat
```
Visual turi : Slicer
O'lcham     : 160 × 50 px
Joylashuv   : X=1090, Y=62
Field       : dim_regions[region]
Slicer type : Dropdown
Format      : Header "Viloyat" | "Select All" ON
Default     : All selected
```



### 🔲 KPI CARD 1 — Milliy O'rtacha
```
Visual turi : Card
O'lcham     : 280 × 110 px
Joylashuv   : X=20, Y=120
Field (Value): [KPI National Avg 2024]
Format string: #,##0.00 "mln UZS"
Callout value font : Segoe UI Bold, 28pt, #1A5276
Category label     : "Milliy O'rtacha Daromad (2024)"
Category font      : 10pt, #7F8C8D
Background  : #FFFFFF | Border: 1px #E8E8E8 | Rounded: 8px
```

### 🔲 KPI CARD 2 — Eng Yuqori Viloyat
```
Visual turi : Card
O'lcham     : 280 × 110 px
Joylashuv   : X=320, Y=120
Field (Value): [KPI Top Income 2024]
Format string: #,##0.00 "mln UZS"
Callout value font : Segoe UI Bold, 28pt, #27AE60
Category label     : "Eng Yuqori ▲ Toshkent sh."
Background  : #FFFFFF | Border: 1px #E8E8E8 | Rounded: 8px
```

### 🔲 KPI CARD 3 — Eng Past Viloyat
```
Visual turi : Card
O'lcham     : 280 × 110 px
Joylashuv   : X=620, Y=120
Field (Value): [KPI Bottom Income 2024]
Format string: #,##0.00 "mln UZS"
Callout value font : Segoe UI Bold, 28pt, #C0392B
Category label     : "Eng Past ▼ Qoraqalpog'iston"
Background  : #FFFFFF | Border: 1px #E8E8E8 | Rounded: 8px
```

### 🔲 KPI CARD 4 — O'sish Multiplier
```
Visual turi : Card
O'lcham     : 280 × 110 px
Joylashuv   : X=920, Y=120
Field (Value): [KPI Growth Multiplier National]
Format string: 0.0"x o'sdi"
Callout value font : Segoe UI Bold, 28pt, #E67E22
Category label     : "O'sish (2010→2024)"
Background  : #FFFFFF | Border: 1px #E8E8E8 | Rounded: 8px
```



### 🔲 VISUAL 1 — Viloyat Daromad Reytingi (Horizontal Bar Chart)
```
Visual turi : Clustered bar chart
O'lcham     : 600 × 330 px
Joylashuv   : X=20, Y=245

Fields:
  Y-axis  : dim_regions[region]
  X-axis  : [Avg Income PC]
  Tooltips: [Region Income Rank], [Income Quartile Label], [YoY Growth Pct]

Sort       : [Avg Income PC] DESC (katta → kichik, yuqoridan pastga)

Format:
  X-axis title   : "Daromad, mln UZS"
  Y-axis font    : 10pt, #2C3E50
  Data labels    : ON | Font: 9pt | Format: #,##0.0
  Gridlines      : Vertical, #F0F0F0, 1px dotted

Conditional Formatting (bar rangi):
  Bars → fx button → Field value → [Color Income Bar]
  → To'q ko'k (Toshkent, Navoiy) dan och ko'k (Qoraqalpog'iston) gacha

Reference line:
  X-axis → Add reference line → Value: [National Avg Income]
  Line: #E67E22, dashed, 1.5px
  Data label: "Milliy o'rtacha"
```

### 🔲 VISUAL 2 — Daromad Trendi (Line Chart)
```
Visual turi : Line chart
O'lcham     : 600 × 330 px
Joylashuv   : X=640, Y=245

Fields:
  X-axis  : dim_calendar[year]
  Y-axis  : [Avg Income PC]
  Legend  : dim_regions[is_capital]
             (2 qator: "Poytaxt" va "Viloyat" o'rtachasi)
  Tooltips: [YoY Growth Pct], [Income Quartile Label]

Format:
  X-axis  : 2010, 2012, 2014 ... 2024 (Every 2 years)
  Y-axis  : "mln UZS"
  Lines   : "Poytaxt" → #1A5276, 2.5px solid
            "Viloyat" → #85C1E9, 1.5px dashed
  Markers : ON, circle, 6px
  Data labels: OFF (tooltipdan foydalaniladi)

Annotations (Text Box overlay):
  → "17.6x o'sdi" — 2024 yil oxirida qo'ying
  → Font: 9pt bold, #1A5276
```

### 🔲 VISUAL 3 — Daromad Kvartil Matrix
```
Visual turi : Matrix
O'lcham     : 1240 × 115 px
Joylashuv   : X=20, Y=590

Fields:
  Rows    : dim_regions[region]
  Columns : dim_calendar[year]  (2010, 2015, 2018, 2020, 2022, 2024)
  Values  : [Avg Income PC]

Format:
  Values format    : #,##0.0
  Font             : 9pt
  Row headers      : 10pt, Bold
  Column headers   : 9pt, #7F8C8D

Conditional Formatting (Background color):
  Values → fx → Color scale
    Minimum: #D6EAF8 (och ko'k)
    Maximum: #1A5276 (to'q ko'k)
  → Natija: Heat map ko'rinishi
```



---

## 📄 PAGE 2 — Income Gap Analysis (Tengsizlik Tahlili)

> Sahifa nomini: `02_Gap_Analysis` qiling.

### 🔲 HEADER
```
Matn        : "MINTAQAVIY DAROMAD TENGSIZLIGI: 2010–2024"
Background  : #922B21  (to'q qizil — tengsizlik mavzusiga mos)
Font        : oq, 18pt bold
```

### 🔲 SLICER — Yil diapazoni
```
Visual turi : Slicer
O'lcham     : 340 × 50 px
Joylashuv   : X=920, Y=62
Field       : dim_calendar[year]
Slicer type : Between (range slider)
```

### 🔲 KPI CARD 1 — Mutloq Farq
```
Field       : [KPI Absolute Gap 2024]
Format      : #,##0.00 "mln UZS"
Callout font: 28pt, #C0392B
Label       : "Mutloq Farq (2024)"
```

### 🔲 KPI CARD 2 — Gap Ratio
```
Field       : [KPI Gap Ratio 2024]
Format      : 0.00"x"
Callout font: 28pt, #C0392B
Label       : "Top/Bottom Nisbati (2024)"
```

### 🔲 KPI CARD 3 — Gap 2010 da
```
Field       : [Gap Ratio 2010]
Format      : 0.00"x"
Callout font: 28pt, #27AE60
Label       : "Nisbat 2010 yilda"
```

### 🔲 KPI CARD 4 — Gap O'zgarishi
```
Field       : [Gap Change Since 2010]
Format      : +0.00"x"
Callout font: 28pt, #E67E22
Label       : "O'zgarish (2010→2024)"
```

### 🔲 VISUAL 1 — Gap Ratio Trendi (Line Chart)
```
Visual turi : Line chart
O'lcham     : 580 × 280 px
Joylashuv   : X=20, Y=245

Fields:
  X-axis  : dim_calendar[year]
  Y-axis  : [Gap Ratio]
  Tooltips: [Absolute Gap], [Tashkent Income], [Karakalpakstan Income]

Format:
  Line    : #C0392B, 2.5px solid
  Markers : ON, 6px
  Y-axis  : Format 0.0"x"
  Shading : Area below line → #FADBD8, 30% opacity

Annotations:
  2010 marker: "2.81x" text box
  2024 marker: "6.14x" text box (bold, qizil)
  Reference line Y=4: dashed #E67E22 → "Ogohlantirish chegarasi"
```

### 🔲 VISUAL 2 — Toshkent vs Qoraqalpog'iston (Clustered Bar)
```
Visual turi : Clustered bar chart
O'lcham     : 580 × 280 px
Joylashuv   : X=640, Y=245

Fields:
  Y-axis  : dim_calendar[year]
  X-axis  : [Tashkent Income], [Karakalpakstan Income]
  Tooltips: [Absolute Gap], [Gap Ratio]

Format:
  Bar 1 (Tashkent)     : #1A5276
  Bar 2 (Qoraqalpog')  : #85C1E9
  Data labels          : ON, #,##0.0
  Legend               : Bottom
  Y-axis               : All years 2010–2024

Insight Text Box (o'ng tomonda):
  "2024: Toshkent 60.59 mln
   Qoraqalpog' 9.87 mln
   Farq: 50.72 mln"
  Font: 9pt, #2C3E50
```

### 🔲 VISUAL 3 — Deviation Waterfall Chart
```
Visual turi : Waterfall chart
O'lcham     : 1240 × 160 px
Joylashuv   : X=20, Y=545

Fields:
  Category  : dim_regions[region]
  Y-axis    : [Deviation from Avg]
  Breakdown : dim_regions[region_type]

Format:
  Increase color : #2E86C1
  Decrease color : #C0392B
  Total color    : #1A5276
  Data labels    : ON, format: +#,##0.0;-#,##0.0
  Reference line : Y=0, solid #333, 1px

Title: "Milliy O'rtachadan Og'ish (mln UZS) — 2024"
```



---

## 📄 PAGE 3 — Sector Structure (Sektor Tuzilmasi)

> Sahifa nomini: `03_Sector_Structure` qiling.

### 🔲 HEADER
```
Matn        : "SEKTOR TUZILMASI: KIM NIMA ISHLAYDI?"
Background  : #1E8449  (yashil — qishloq va sanoat mavzusi)
Font        : oq, 18pt bold
```

### 🔲 SLICER 1 — Yil
```
Field       : dim_calendar[year]
Type        : Dropdown | Default: 2024
```

### 🔲 SLICER 2 — Viloyat turi
```
Field       : dim_regions[region_type]
Type        : Tile (gorizontal) | Multi-select ON
```

### 🔲 KPI CARD 1 — Qurilish o'sishi
```
Field       : [Construction Growth X]
Format      : 0.0"x"
Callout     : 28pt, #1A5276
Label       : "Qurilish O'sishi (2010→2024)"
```

### 🔲 KPI CARD 2 — Q/X o'sishi
```
Field       : [Agriculture Growth X]
Format      : 0.0"x"
Callout     : 28pt, #27AE60
Label       : "Q/X O'sishi (2010→2024)"
```

### 🔲 KPI CARD 3 — Savdo o'sishi
```
Field       : [Trade Growth X]
Format      : 0.0"x"
Callout     : 28pt, #E67E22
Label       : "Savdo O'sishi (2010→2024)"
```

### 🔲 KPI CARD 4 — Diversifikatsiya
```
Field       : [Diversification Level]   ← matn measure
Callout     : 14pt, #2C3E50
Label       : "Milliy Diversifikatsiya Darajasi"
```

### 🔲 VISUAL 1 — Stacked Bar: Sektor Ulushi (viloyat bo'yicha)
```
Visual turi : 100% Stacked bar chart
O'lcham     : 620 × 320 px
Joylashuv   : X=20, Y=245

Fields:
  Y-axis  : dim_regions[region]
  X-axis  : [Construction Share Pct]
             [Agriculture Share Pct]
             [Trade Share Pct]
  Tooltips: [Dominant Sector], [Diversification Index]

Sort: dim_regions[sort_order] (daromad bo'yicha yuqoridan pastga)

Format:
  Qurilish (Construction) : #1A5276
  Qishloq x'jaligi        : #27AE60
  Savdo (Trade)           : #E67E22
  Data labels             : ON, format: 0%
  X-axis                  : 0%–100%
  Legend                  : Top, horizontal
```

### 🔲 VISUAL 2 — Donut Chart: 2024 Milliy Sektor Ulushi
```
Visual turi : Donut chart
O'lcham     : 280 × 320 px
Joylashuv   : X=660, Y=245

Fields:
  Legend  : (3 ta measure label uchun qo'lda nomi)
  Values  : [Construction Share Pct]
             [Agriculture Share Pct]
             [Trade Share Pct]

Format:
  Inner radius   : 50%
  Slice renglari : #1A5276, #27AE60, #E67E22
  Data labels    : Category + percent, 10pt
  Center label   : "2024" — Text Box overlay
  Legend         : Right side
```

### 🔲 VISUAL 3 — Area Chart: Sektor Trendi (2010–2024)
```
Visual turi : Area chart
O'lcham     : 580 × 320 px
Joylashuv   : X=660, Y=245  (Donut bilan almashtirish mumkin)

Fields:
  X-axis  : dim_calendar[year]
  Y-axis  : SUM(fact_sectors[construction])
             SUM(fact_sectors[agriculture_output])
             SUM(fact_sectors[retail_trade])
  Tooltips: [Construction Growth X], [Agriculture Growth X]

Format:
  Construction area : #1A5276, 60% opacity
  Agriculture area  : #27AE60, 60% opacity
  Trade area        : #E67E22, 60% opacity
  Y-axis            : "mln UZS"
  Markers           : OFF (area chart uchun)

Annotations (Text box):
  "Qurilish: +8.4x" → 2024 oxirida
  "Q/X: +5.3x"      → 2024 oxirida
  "Savdo: +4.9x"    → 2024 oxirida
```

### 🔲 VISUAL 4 — Sektor + Daromad Jadvali
```
Visual turi : Table
O'lcham     : 1240 × 130 px
Joylashuv   : X=20, Y=578

Fields:
  dim_regions[region]
  dim_regions[region_type]
  [Construction Share Pct]
  [Agriculture Share Pct]
  [Trade Share Pct]
  [Dominant Sector]
  [Diversification Level]
  [Avg Income PC]

Format:
  Font              : 9pt
  Header background : #1E8449, oq matn
  Alternating rows  : #F9FBF9, #FFFFFF
  [Avg Income PC]   : Conditional formatting → Color scale
  [Dominant Sector] : Bold
  Column widths     : Region(140), Type(120), shares(80 each),
                      Dominant(120), Divers(140), Income(100)
```



---

## 📄 PAGE 4 — Economic Drivers (Iqtisodiy Harakatlantiruvchilar)

> Sahifa nomini: `04_Economic_Drivers` qiling.

### 🔲 HEADER
```
Matn        : "DAROMAD OMILLARI: ENG KUCHLI HARAKATLANTIRUVCHILAR"
Background  : #6C3483  (binafsha — analitik mavzu)
Font        : oq, 18pt bold
```

### 🔲 SLICER — Yil (ALL filter recommended)
```
Field       : dim_calendar[year]
Type        : Dropdown
Default     : All (bu sahifada ALL tavsiya etiladi)

⚠️ Eslatma: Page 4 dagi scatterda viloyatlar
   barcha yillar bo'yicha taqqoslanadi (cross-sectional).
   Yil slicer ni "All" qoldirib qo'ying yoki
   "Select All" default qiling.
```

### 🔲 KPI CARD 1 — Investitsiya Korrelyatsiyasi
```
Field       : [Correlation Investment Income]
Format      : 0.00
Callout     : 28pt, #6C3483
Label       : "Investitsiya ↔ Daromad (r)"
```

### 🔲 KPI CARD 2 — Qurilish Korrelyatsiyasi
```
Field       : [Correlation Construction Income]
Format      : 0.00
Callout     : 28pt, #1A5276
Label       : "Qurilish ↔ Daromad (r)"
```

### 🔲 KPI CARD 3 — Savdo Korrelyatsiyasi
```
Field       : [Correlation Trade Income]
Format      : 0.00
Callout     : 28pt, #E67E22
Label       : "Savdo ↔ Daromad (r)"
```

### 🔲 KPI CARD 4 — Q/X Korrelyatsiyasi
```
Field       : [Correlation Agriculture Income]
Format      : 0.00
Callout     : 28pt, #27AE60
Label       : "Q/X ↔ Daromad (r)"
```

### 🔲 VISUAL 1 — Korrelyatsiya Reytingi (Horizontal Bar)
```
Visual turi : Clustered bar chart (horizontal)
O'lcham     : 460 × 320 px
Joylashuv   : X=20, Y=245

Ma'lumot    : Enter Data → Statik jadval
  Driver               | Correlation
  Investitsiya         | 0.97
  GRP per capita       | 0.91
  Qurilish             | 0.89
  Savdo                | 0.86
  Q/X                  | 0.43
  Bandlik              | 0.31

Fields:
  Y-axis  : Driver (text)
  X-axis  : Correlation (number)

Sort: Correlation DESC

Format:
  Bars    : Conditional color
            ≥ 0.80 → #1A5276
            ≥ 0.60 → #2E86C1
            ≥ 0.40 → #E67E22
            < 0.40 → #BDC3C7
  Data labels: ON, format: 0.00
  X-axis range: 0 to 1.0
  Reference line X=0.7: dashed #C0392B → "Kuchli korrelyatsiya chegarasi"
  Title   : "Daromad bilan Korrelyatsiya (Pearson r)"
```

### 🔲 VISUAL 2 — Scatter Plot: Investitsiya vs Daromad
```
Visual turi : Scatter chart
O'lcham     : 740 × 320 px
Joylashuv   : X=500, Y=245

Fields:
  X-axis  : [Investment Index Normalized]   (0–100)
  Y-axis  : [Income Index Normalized]       (0–100)
  Legend  : dim_regions[region_type]
  Size    : [Avg Income PC]
  Details : dim_regions[region]    ← har bubble = 1 viloyat
  Tooltips: dim_regions[region],
             [Avg Income PC],
             [Avg Investment PC],
             [Investment to Income Ratio]

Format:
  Bubble ranglari (Legend):
    Urban/Industrial : #1A5276
    Mixed            : #2E86C1
    Trade-oriented   : #E67E22
    Agricultural     : #27AE60
  Bubble max size  : 30px
  Bubble opacity   : 80%

  X-axis title: "Investitsiya Indeksi (0–100, normalizatsiya)"
  Y-axis title: "Daromad Indeksi (0–100, normalizatsiya)"
  Gridlines   : #F0F0F0

  Data labels (region nomi):
    ON, font 8pt, qora
    Muhim nuqtalar: "Toshkent sh.", "Qoraqalpog'iston" label bering

Trend line:
  Analytics pane → Trend line → Linear
  Rang: #C0392B, dashed 1.5px
  R² = 0.94 (label sifatida qo'lda Text Box qo'shing)

Annotation Text Box:
  "r = 0.97 — Juda kuchli musbat bog'liqlik"
  Font: 10pt bold, #6C3483
  Joylashuv: chart ichida yuqori chap
```

### 🔲 VISUAL 3 — Investitsiya Reytingi (Bar Chart)
```
Visual turi : Clustered bar chart (horizontal)
O'lcham     : 1240 × 145 px
Joylashuv   : X=20, Y=578

Fields:
  Y-axis  : dim_regions[region]
  X-axis  : [Avg Investment PC]
  Tooltips: [Investment Rank], [Investment YoY Pct], [Avg Income PC]

Sort: [Avg Investment PC] DESC

Format:
  Bar rangi  : #6C3483 gradient → och binafsha
  Data labels: ON, format: #,##0.0
  X-axis title: "O'rtacha Investitsiya, mln UZS"
  Reference line: [National Avg Income] → dashed #E67E22

Conditional Formatting (bar background):
  Top 3 → #6C3483 (to'q)
  4–7   → #9B59B6
  8–14  → #D7BDE2 (och)
```



---

## 📄 PAGE 5 — Navigation / Cover (Muqova Sahifa)

> Sahifa nomini: `00_Cover` qiling va **birinchi sahifa** sifatida joylashtiring.
> Bu sahifa foydalanuvchi uchun dashboard navigatsiyasini ta'minlaydi.

### 🔲 COVER BACKGROUND
```
Background color : #1A3A5C (to'q ko'k-moviy)
Canvas           : 1280 × 720 px
```

### 🔲 TITLE TEXT BOX
```
Matn    : "O'ZBEKISTON MINTAQAVIY IQTISODIY TAHLILI"
Font    : Segoe UI Black, 32pt, #FFFFFF
Joylash : Markazda, Y=120
```

### 🔲 SUBTITLE TEXT BOX
```
Matn    : "14 Viloyat  ·  2010–2024  ·  Stat.uz Ma'lumotlari"
Font    : Segoe UI Light, 16pt, #85C1E9
Joylash : Markazda, Y=185
```

### 🔲 4 TA NAVIGATION BUTTON
```
Har bir tugma uchun:
  Visual    : Button → Blank
  O'lcham   : 260 × 130 px
  Rounded   : 12px

Button 1 — Page 1:
  Joylash   : X=80, Y=300
  Matn      : "📊  Daromad Ko'rinishi"
  Subtitle  : "Viloyat reytingi · Kvartillar · Trendlar"
  Fill      : #2E86C1
  Action    : Page navigation → 01_Income_Overview

Button 2 — Page 2:
  Joylash   : X=380, Y=300
  Matn      : "⚖️  Tengsizlik Tahlili"
  Subtitle  : "Gap ratio · 2010→2024 dinamikasi"
  Fill      : #922B21
  Action    : Page navigation → 02_Gap_Analysis

Button 3 — Page 3:
  Joylash   : X=680, Y=300
  Matn      : "🏭  Sektor Tuzilmasi"
  Subtitle  : "Sektorlar ulushi · O'sish · Diversifikatsiya"
  Fill      : #1E8449
  Action    : Page navigation → 03_Sector_Structure

Button 4 — Page 4:
  Joylash   : X=980, Y=300
  Matn      : "💡  Daromad Omillari"
  Subtitle  : "Korrelyatsiya · Investitsiya · Scatter"
  Fill      : #6C3483
  Action    : Page navigation → 04_Economic_Drivers

Format (barcha tugmalar uchun):
  Matn font      : Segoe UI Bold, 13pt, #FFFFFF
  Subtitle font  : Segoe UI, 10pt, #D6EAF8
  Hover fill     : 20% qoraytirilgan rang
  Border         : Yo'q
```

### 🔲 FOOTER TEXT BOX
```
Matn    : "Muallif: Sarvar Erkinjonov  |  Manba: Stat.uz  |  Vosita: Power BI + DAX + Python + SQL"
Font    : Segoe UI, 9pt, #7F8C8D
Joylash : X=20, Y=680
```

---

## 🔁 BARCHA SAHIFALAR UCHUN UMUMIY SOZLAMALAR

### Back to Cover tugmasi (har sahifada)
```
Visual    : Button → Back
O'lcham   : 110 × 30 px
Joylash   : X=1150, Y=12
Matn      : "← Bosh sahifa"
Font      : 9pt, #FFFFFF
Fill      : transparent
Border    : 1px #FFFFFF
Action    : Page navigation → 00_Cover
```

### Page Navigation tugmalari (har sahifada — top right)
```
4 ta kichik tugma: P1 | P2 | P3 | P4
O'lcham           : 40 × 25 px har biri
Joylash           : X=730,760,790,820 | Y=12
Aktiv sahifa      : To'ldirilgan rang (sahifa rangi)
Passiv sahifa     : Shaffof, 1px border
```

---

## ✅ PAGE 4 Tekshiruv Ro'yxati

- [ ] Cover sahifa (00_Cover) birinchi o'rinda
- [ ] 4 ta sahifaning barchasi to'g'ri nomlangan
- [ ] Har sahifada Header text box bor va rangi to'g'ri
- [ ] Barcha KPI Cardlarda format string qo'shilgan
- [ ] Bar chartlarda conditional formatting ishlayapti
- [ ] Scatter chartda trend line va R² annotation bor
- [ ] Navigation tugmalari ishlaydi (Ctrl+Click test)
- [ ] Waterfall chart da reference line (Y=0) bor
- [ ] Matrix da color scale heat map ko'rinmoqda
- [ ] Barcha slicerlar sahifaga ta'sir qilmoqda
- [ ] Visual sarlavhalari (`Title`) har birida yozilgan
- [ ] Footer har sahifada mavjud
