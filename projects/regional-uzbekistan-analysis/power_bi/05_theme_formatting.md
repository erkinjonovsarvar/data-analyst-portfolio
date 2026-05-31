# STEP 5 — Theme, Formatting, Tooltips, Bookmarks
## Power BI Desktop — Professional Finishing

---

## 🎨 PART A — Report Theme (JSON)

> **Qo'llash usuli:**
> View → Themes → Browse for themes → `.json` faylni tanlang
>
> Yoki: View → Themes → Customize current theme → paste qiling

Quyidagi JSON ni `uzbekistan_economic_theme.json` nomli fayl sifatida saqlang:

```json
{
  "name": "Uzbekistan Economic Dashboard",
  "dataColors": [
    "#1A5276",
    "#2E86C1",
    "#85C1E9",
    "#D6EAF8",
    "#27AE60",
    "#E67E22",
    "#C0392B",
    "#6C3483"
  ],
  "background": "#F4F6F7",
  "foreground": "#2C3E50",
  "tableAccent": "#2E86C1",

  "visualStyles": {
    "*": {
      "*": {
        "fontFamily": [{"value": "Segoe UI"}],
        "fontSize":   [{"value": 10}],
        "color":      [{"solid": {"color": "#2C3E50"}}],
        "background": [{"solid": {"color": "#FFFFFF"}}]
      }
    },

    "card": {
      "*": {
        "dataLabelFontSize": [{"value": 28}],
        "categoryLabelFontSize": [{"value": 10}],
        "outline": [{"value": "BottomOnly"}],
        "outlineColor": [{"solid": {"color": "#2E86C1"}}],
        "outlineWeight": [{"value": 2}],
        "background": [{"solid": {"color": "#FFFFFF"}}]
      }
    },

    "barChart": {
      "*": {
        "gridlineColor": [{"solid": {"color": "#F0F0F0"}}],
        "gridlineStyle": [{"value": "dotted"}],
        "gridlineWidth": [{"value": 1}],
        "axisTitleFontSize": [{"value": 10}],
        "labelFontSize": [{"value": 9}]
      }
    },

    "lineChart": {
      "*": {
        "lineWidth": [{"value": 2}],
        "markerEnabled": [{"value": true}],
        "markerSize": [{"value": 6}],
        "gridlineColor": [{"solid": {"color": "#F0F0F0"}}]
      }
    },

    "scatterChart": {
      "*": {
        "markerSize": [{"value": 12}],
        "gridlineColor": [{"solid": {"color": "#F0F0F0"}}],
        "axisTitleFontSize": [{"value": 10}]
      }
    },

    "tableEx": {
      "*": {
        "fontFamily": [{"value": "Segoe UI"}],
        "fontSize":   [{"value": 9}],
        "gridColor":  [{"solid": {"color": "#E8E8E8"}}],
        "outlineColor": [{"solid": {"color": "#2E86C1"}}]
      }
    },

    "slicer": {
      "*": {
        "fontFamily": [{"value": "Segoe UI"}],
        "fontSize":   [{"value": 10}],
        "outlineColor": [{"solid": {"color": "#2E86C1"}}],
        "outlineWeight": [{"value": 1}],
        "background": [{"solid": {"color": "#FFFFFF"}}]
      }
    }
  },

  "textClasses": {
    "callout": {
      "fontFace": "Segoe UI",
      "color": "#1A5276",
      "size": 28
    },
    "header": {
      "fontFace": "Segoe UI Semibold",
      "color": "#FFFFFF",
      "size": 18
    },
    "label": {
      "fontFace": "Segoe UI",
      "color": "#7F8C8D",
      "size": 10
    },
    "title": {
      "fontFace": "Segoe UI Bold",
      "color": "#2C3E50",
      "size": 13
    },
    "smallLabel": {
      "fontFace": "Segoe UI",
      "color": "#7F8C8D",
      "size": 9
    }
  }
}
```



---

## 🖼️ PART B — Custom Tooltip Pages

> Custom Tooltip — sichqonchani visual ustiga olib borganingizda
> maxsus sahifa ko'rsatadi. Bu portfolio uchun juda kuchli ko'rinadi.
>
> **Yaratish usuli:**
> Yangi sahifa qo'shing → sahifani o'ng klik → Page information →
> **"Allow use as tooltip" = ON** →
> Canvas size: **Custom → 320 × 200 px**

---

### TOOLTIP 1 — `tooltip_region_detail`
*(Page 1 va Page 2 dagi bar chart uchun)*

```
Sahifa nomi : tooltip_region_detail
Canvas      : 320 × 200 px
Background  : #1A3A5C (to'q ko'k)

Vizuallar:

[1] Region nomi — Text Box + Dynamic Title
    Joylash : X=10, Y=10, W=300, H=30
    Matn    : dim_regions[region]  ← Title dynamic qiling:
              Format → Title → fx → Field value → dim_regions[region]
    Font    : Segoe UI Bold, 14pt, #FFFFFF

[2] Daromad qiymati — Card
    O'lcham : W=140, H=60 | Joylash: X=10, Y=45
    Field   : [Avg Income PC]
    Format  : #,##0.0 "mln"
    Label   : "Daromad"
    Font    : 22pt, #85C1E9 | Label: 9pt, #7F8C8D

[3] YoY o'sish — Card
    O'lcham : W=140, H=60 | Joylash: X=165, Y=45
    Field   : [YoY Growth Pct]
    Format  : +0.0%;-0.0%
    Label   : "YoY O'sish"
    Conditional color: [Color YoY Arrow]
    Font    : 22pt | Label: 9pt, #7F8C8D

[4] Reyting + Kvartil — Table (2 ustun, 2 qator)
    O'lcham : W=300, H=55 | Joylash: X=10, Y=115
    Fields  : [Region Income Rank], [Income Quartile Label]
    Matn    : "Reyting: #X  |  Segment: QX"
    Font    : 10pt, #D6EAF8
    Background: transparent

[5] Segment rangi belgisi — Shape
    Doira (Circle shape): W=10, H=10
    Joylash: X=10, Y=180
    Fill: [Color Income Bar] ← conditional
```

---

### TOOLTIP 2 — `tooltip_gap_year`
*(Page 2 dagi Line Chart uchun — yil bo'yicha)*

```
Sahifa nomi : tooltip_gap_year
Canvas      : 320 × 200 px
Background  : #4A0E0E (to'q qizil)

[1] Yil — Dynamic Title
    Field   : dim_calendar[year]
    Font    : 16pt Bold, #FFFFFF

[2] Gap Ratio — Card
    O'lcham : W=140, H=60 | Joylash: X=10, Y=45
    Field   : [Gap Ratio]
    Format  : 0.00"x"
    Label   : "Gap Ratio"
    Font    : 24pt, #FADBD8

[3] Mutloq Farq — Card
    O'lcham : W=140, H=60 | Joylash: X=165, Y=45
    Field   : [Absolute Gap]
    Format  : #,##0.0 "mln"
    Label   : "Mutloq Farq"
    Font    : 22pt, #FADBD8

[4] Toshkent vs Qoraqalpog' — Clustered Bar (mini)
    O'lcham : W=300, H=60 | Joylash: X=10, Y=115
    Fields  : Y=[Tashkent Income], [Karakalpakstan Income]
    Bar renglari: #1A5276, #85C1E9
    Data labels : ON, 9pt
    Title       : OFF, X/Y axis: OFF (minimal view)

[5] Trend label — Text Box
    Field   : [Gap Trend Label]
    Font    : 11pt Bold, #FADBD8
    Joylash : X=10, Y=178
```

---

### TOOLTIP 3 — `tooltip_sector_region`
*(Page 3 dagi Stacked Bar uchun)*

```
Sahifa nomi : tooltip_sector_region
Canvas      : 320 × 200 px
Background  : #0B3320 (to'q yashil)

[1] Viloyat nomi — Dynamic Title
    Font: 14pt Bold, #FFFFFF

[2] Donut Chart (mini) — Sektor ulushi
    O'lcham : W=120, H=120 | Joylash: X=10, Y=45
    Fields  : [Construction Share Pct]
               [Agriculture Share Pct]
               [Trade Share Pct]
    Rangi   : #1A5276, #27AE60, #E67E22
    Legend  : OFF | Title: OFF
    Inner r : 40%

[3] Ustun sektor — Card
    O'lcham : W=170, H=55 | Joylash: X=140, Y=50
    Field   : [Dominant Sector]
    Label   : "Ustun Sektor"
    Font    : 14pt, #A9DFBF

[4] Diversifikatsiya — Card
    O'lcham : W=170, H=55 | Joylash: X=140, Y=115
    Field   : [Diversification Level]
    Label   : "Diversifikatsiya"
    Font    : 11pt, #A9DFBF

[5] Daromad — Text Box
    Matn    : "Daromad: " + [Avg Income PC]
    Font    : 10pt, #D5F5E3
    Joylash : X=10, Y=175
```

---

### TOOLTIP 4 — `tooltip_driver_scatter`
*(Page 4 dagi Scatter Chart uchun)*

```
Sahifa nomi : tooltip_driver_scatter
Canvas      : 320 × 220 px
Background  : #2C0E4A (to'q binafsha)

[1] Viloyat nomi — Dynamic Title
    Font: 14pt Bold, #FFFFFF

[2] Investitsiya — Card
    O'lcham : W=140, H=60 | Joylash: X=10, Y=45
    Field   : [Avg Investment PC]
    Format  : #,##0.0 "mln"
    Label   : "Investitsiya PC"
    Font    : 22pt, #D7BDE2

[3] Daromad — Card
    O'lcham : W=140, H=60 | Joylash: X=165, Y=45
    Field   : [Avg Income PC]
    Format  : #,##0.0 "mln"
    Label   : "Daromad PC"
    Font    : 22pt, #D7BDE2

[4] Investitsiya/Daromad nisbati — Card
    O'lcham : W=140, H=55 | Joylash: X=10, Y=115
    Field   : [Investment to Income Ratio]
    Format  : 0.00
    Label   : "Investitsiya/Daromad"
    Font    : 18pt, #E8DAEF

[5] Investment Rank — Card
    O'lcham : W=140, H=55 | Joylash: X=165, Y=115
    Field   : [Investment Rank]
    Format  : "#"0
    Label   : "Investitsiya Reytingi"
    Font    : 18pt, #E8DAEF

[6] Viloyat turi — Text Box
    Field   : dim_regions[region_type]
    Font    : 10pt, #D7BDE2
    Joylash : X=10, Y=180
```

---

### Tooltip ni Visuals ga ulash
```
Har bir asosiy visual uchun:
Format pane → Tooltip → Type = "Report page"
→ Page = kerakli tooltip sahifasini tanlang

Page 1 Bar Chart    → tooltip_region_detail
Page 2 Line Chart   → tooltip_gap_year
Page 3 Stacked Bar  → tooltip_sector_region
Page 4 Scatter      → tooltip_driver_scatter
```



---

## 🔖 PART C — Bookmarks

> **Bookmark — nima?**
> Dashboard holatini (qaysi slicer tanlangan, qaysi visual ko'rinmoqda)
> saqlaydi. Tugma bilan chaqiriladi. Demo va storytelling uchun ideal.
>
> **Ochish:** View → Bookmarks pane (ON qiling)

---

### Bookmark 1 — `bm_2024_snapshot`
```
Maqsad    : Faqat 2024 yil ko'rsatilsin, barcha viloyatlar
Sahifa    : 01_Income_Overview
Sozlash   :
  1. Year slicer → faqat 2024 ni tanlang
  2. Region slicer → "All" (barcha)
  3. Bookmarks pane → Add → Nom: "bm_2024_snapshot"
  4. Options (3 nuqta) → Data = ON, Display = ON, Current page = ON
```

### Bookmark 2 — `bm_2010_baseline`
```
Maqsad    : 2010 yil holati — taqqoslash uchun
Sahifa    : 01_Income_Overview
Sozlash   :
  1. Year slicer → faqat 2010 ni tanlang
  2. Region slicer → "All"
  3. Bookmarks → Add → "bm_2010_baseline"
```

### Bookmark 3 — `bm_q1_regions`
```
Maqsad    : Faqat Q1 (eng past) viloyatlar — Andijon, Namangan,
            Xorazm, Surxondaryo, Qoraqalpog'iston
Sahifa    : 01_Income_Overview
Sozlash   :
  1. Region slicer → yuqoridagi 5 viloyatni tanlang
  2. Year slicer → All
  3. Bookmarks → Add → "bm_q1_regions"
```

### Bookmark 4 — `bm_gap_fulltrend`
```
Maqsad    : 2010–2024 to'liq gap trendi
Sahifa    : 02_Gap_Analysis
Sozlash   :
  1. Year range slicer → 2010 to 2024 (full range)
  2. Region → All
  3. Bookmarks → Add → "bm_gap_fulltrend"
```

### Bookmark 5 — `bm_gap_recent`
```
Maqsad    : So'nggi 5 yil tengsizlik dinamikasi
Sahifa    : 02_Gap_Analysis
Sozlash   :
  1. Year slicer → 2020 to 2024
  2. Bookmarks → Add → "bm_gap_recent"
```

### Bookmark 6 — `bm_agri_regions`
```
Maqsad    : Faqat Agricultural region turi ko'rsatilsin
Sahifa    : 03_Sector_Structure
Sozlash   :
  1. Region Type slicer → "Agricultural" tanlang
  2. Bookmarks → Add → "bm_agri_regions"
```

### Bookmark 7 — `bm_urban_regions`
```
Maqsad    : Urban/Industrial va Mixed viloyatlar
Sahifa    : 03_Sector_Structure
Sozlash   :
  1. Region Type slicer → "Urban/Industrial" + "Mixed" tanlang
  2. Bookmarks → Add → "bm_urban_regions"
```

### Bookmark 8 — `bm_investment_allyears`
```
Maqsad    : Scatter chart — barcha yillar, barcha viloyatlar
Sahifa    : 04_Economic_Drivers
Sozlash   :
  1. Year slicer → All
  2. Bookmarks → Add → "bm_investment_allyears"
```

---

### Bookmark Tugmalarini Sahifaga ulash
```
Har bir sahifada Bookmark tugmalarini qo'shing:

Insert → Buttons → Blank → Format:
  Matn   : Bookmark nomi (qisqa)
  Action : Bookmark → tegishli bookmark ni tanlang

Misol (01_Income_Overview sahifasida):

  [2024 📸]  → bm_2024_snapshot
  [2010 📊]  → bm_2010_baseline
  [Q1 ⬇️]   → bm_q1_regions

Tugma o'lchami : 90 × 28 px
Joylashuv      : Sahifa pastki qismida gorizontal qator
Font           : Segoe UI, 9pt
Fill           : #EBF5FB (tanlangan holat)
               : #FFFFFF (oddiy holat)
Border         : 1px #2E86C1
```

---

## 📱 PART D — Mobile Layout

> **Ochish:** View → Mobile layout
> Har bir sahifa uchun alohida sozlash kerak.

```
Tavsiya etilgan tartib (portrait, 360 × 780 px):

1. Header Text Box     (to'liq kenglik)
2. KPI Card 1          (yarmi kenglik)  | KPI Card 2 (yarmi)
3. KPI Card 3          (yarmi kenglik)  | KPI Card 4 (yarmi)
4. Asosiy Visual       (to'liq kenglik, balandroq)
5. Qo'shimcha Visual   (to'liq kenglik)
6. Slicer 1 + Slicer 2 (pastda)

Muhim: Mobile layoutda Scatter chart va Matrix ni
       olib tashlang — kichik ekranda o'qilmaydi.
       Ular o'rniga Cards va Bar chartlarni qoldiring.
```

---

## 🎯 PART E — Performance Optimization

> Katta dataset yoki ko'p DAX bo'lsa, dashboard sekin ishlaydi.
> Quyidagi choralar yordamida tezlashtiriladi.

### Performance Analyzer (Slow DAX topish)
```
View → Performance analyzer → Start recording
→ Sahifani refresh qiling
→ Har bir vizualning "DAX query" vaqtini ko'ring
→ 300ms dan oshsa — optimizatsiya kerak
```

### Sekin Measurelarni Tezlashtirish

**❌ Sekin (har safar qayta hisoblaydi):**
```dax
-- FILTER + CALCULATE ichida MAXX/MINX
Bottom Region Income =
MINX(
    FILTER(ALL(dim_regions[region]),
        CALCULATE(AVERAGE(fact_income[income_pc])) > 0),
    CALCULATE(AVERAGE(fact_income[income_pc]))
)
```

**✅ Tez (VARLAR bilan bir marta hisoblaydi):**
```dax
Bottom Region Income Fast =
VAR income_table =
    ADDCOLUMNS(
        ALL(dim_regions[region]),
        "avg_inc", CALCULATE(AVERAGE(fact_income[income_pc]))
    )
VAR positive_only =
    FILTER(income_table, [avg_inc] > 0)
RETURN
    MINX(positive_only, [avg_inc])
```

### Import Mode (DirectQuery emas)
```
Ma'lumot manba → Import Mode ishlating (bizning holatda Excel)
Import Mode → RAM da saqlanadi → tez ishlaydi
DirectQuery → har safar bazaga so'rov → sekin
```

### Aggregation Table (katta dataset uchun)
```
Agar 1M+ qatorli dataset bo'lsa:
Modeling → Manage aggregations
→ Viloyat + Yil bo'yicha pre-aggregated jadval yarating
→ Power BI avtomatik tez yo'lni tanlaydi
```

---

## 🔒 PART F — Row Level Security (RLS)

> Portfolio uchun majburiy emas, lekin professional ko'rinish uchun qo'shish mumkin.

```dax
-- Modeling → Manage roles → New role: "Region_Manager"
-- dim_regions jadvaliga quyidagi filtr:

[region] = USERPRINCIPALNAME()

-- Yoki test uchun:
[region] = "Toshkent sh."
```

```
Test qilish:
Modeling → View as → Roles → Region_Manager
→ Dashboard faqat Toshkent sh. ma'lumotini ko'rsatishi kerak
```

---

## 📤 PART G — Publishing va Sharing

### Power BI Service ga Publish qilish
```
1. File → Publish → Publish to Power BI
2. Destination: My workspace (yoki yangi workspace yarating)
3. Publish tugmasini bosing
4. "Open in Power BI" havolasini saqlang
```

### Dashboard Embedding (Portfolio uchun)
```
Power BI Service → Report → File → Embed report →
Website or portal → Embed code oling

HTML ga qo'shish:
<iframe
  src="EMBED_URL_HERE"
  width="1280"
  height="720"
  frameborder="0"
  allowFullScreen="true">
</iframe>
```

### GitHub README ga qo'shish
```
Dashboard uchun screenshot oling (Print Screen yoki
Power BI → Export → Export to PDF/PNG)

README.md da:
![Dashboard Preview](./screenshots/page1_income_overview.png)

Yoki Power BI badge:
[![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)](YOUR_POWERBI_URL)
```

---

## ✅ STEP 5 Tekshiruv Ro'yxati

**Theme:**
- [ ] `uzbekistan_economic_theme.json` fayli saqlandi
- [ ] Power BI da theme qo'llandi (View → Themes → Browse)
- [ ] Barcha vizuallar yangi rang sxemasida ko'rinmoqda

**Tooltips:**
- [ ] 4 ta tooltip sahifasi yaratildi
- [ ] Har bir tooltip sahifasida "Allow use as tooltip" = ON
- [ ] Canvas size = 320 × 200 px (yoki 320 × 220 px)
- [ ] Asosiy vizuallarga tooltip page ulandi

**Bookmarks:**
- [ ] 8 ta bookmark yaratildi
- [ ] Bookmark tugmalari sahifaga qo'shildi
- [ ] Ctrl+Click bilan bookmark ishlayaptimi — tekshiring

**Mobile:**
- [ ] Har 4 sahifa uchun Mobile layout sozlandi
- [ ] Kichik ekranda Scatter/Matrix olib tashlandi

**Performance:**
- [ ] Performance Analyzer ishlatildi
- [ ] 300ms+ DAX lar VAR bilan optimizatsiya qilindi

**Publishing:**
- [ ] Power BI Service ga publish qilindi
- [ ] Embed kodi olindi (ixtiyoriy)
- [ ] Screenshot olingan va README ga qo'shishga tayyor
