# Power BI Dashboard Design Guide
## Regional Economic Analysis of Uzbekistan

---

## 🎨 Color Palette (Rang sxemasi)

| Rol | Rang | Hex |
|-----|------|-----|
| Primary accent | Ko'k | `#2E86C1` |
| High income | To'q ko'k | `#1A5276` |
| Low income | Och ko'k | `#D6EAF8` |
| Positive trend | Yashil | `#27AE60` |
| Negative / Gap | Qizil | `#C0392B` |
| Warning | To'q sariq | `#E67E22` |
| Neutral | Kulrang | `#7F8C8D` |
| Background | Juda och kulrang | `#F4F6F7` |
| Card background | Oq | `#FFFFFF` |

---

## 📐 Layout (Sahifa tuzilmasi)

```
┌─────────────────────────────────────────────────┐
│  LOGO  │  Dashboard nomi  │  [Yil slicer] [Viloyat] │
├────────┬────────┬────────┬────────────────────────┤
│  KPI   │  KPI   │  KPI   │         KPI             │
│ Card 1 │ Card 2 │ Card 3 │        Card 4           │
├────────────────────────┬────────────────────────┤
│                        │                        │
│    Asosiy visual       │    Qo'shimcha visual   │
│    (katta)             │    (kichik)            │
│                        │                        │
├────────────────────────┴────────────────────────┤
│         Pastki visual (keng)                    │
└─────────────────────────────────────────────────┘
```

---

## 📄 PAGE 1 — Income Overview

### Vizuallar:

| # | Visual turi | Ma'lumot | DAX Measure |
|---|-------------|---------|-------------|
| 1 | **KPI Card** | Davlat o'rtacha daromadi | `KPI National Avg 2024` |
| 2 | **KPI Card** | Eng yuqori viloyat | `KPI Top Income 2024` |
| 3 | **KPI Card** | Eng past viloyat | `KPI Bottom Income 2024` |
| 4 | **KPI Card** | O'sish multiplier | `Growth Multiplier 2010_2024` |
| 5 | **Bar Chart** (horizontal) | Viloyat bo'yicha daromad reytingi | `Avg Income PC` + rank sort |
| 6 | **Line Chart** | 2010–2024 daromad trendi (national) | `Avg Income PC` by `year` |
| 7 | **Matrix / Table** | Viloyat + Kvartil segmenti | `Income Quartile` |
| 8 | **Map** | Viloyatlar xaritasi (daromad rangi) | `Income Color` |

### Slicerlar:
- 📅 Year (2010–2024)
- 🗺️ Region
- 🏷️ Income Segment (Q1–Q4)

### Conditional Formatting:
- Bar Chart: `Income Color` measure asosida rang berish
- Matrix: Background color = `Income Color`

---

## 📄 PAGE 2 — Income Gap Analysis

### Vizuallar:

| # | Visual turi | Ma'lumot | DAX Measure |
|---|-------------|---------|-------------|
| 1 | **KPI Card** | Mutloq farq (2024) | `Absolute Gap` |
| 2 | **KPI Card** | Nisbiy farq (Gap Ratio) | `KPI Gap Ratio 2024` |
| 3 | **KPI Card** | Gap trend yo'nalishi | `Gap Trend Label` |
| 4 | **Line Chart** | Gap Ratio trendi (2010–2024) | `Gap Ratio` by `year` |
| 5 | **Line Chart** | Mutloq farq trendi | `Absolute Gap` by `year` |
| 6 | **Clustered Bar** | Toshkent sh. vs Qoraqalpog'iston | `Tashkent Income` + `Karakalpakstan Income` |
| 7 | **Matrix (Heatmap)** | Viloyat × Yil daromad matritsasi | `Avg Income PC` → `Income Color` |
| 8 | **Waterfall Chart** | Daromad deviatsiyasi (avg dan) | `Deviation from National Avg` |

### Slicerlar:
- 📅 Year range
- 🗺️ Region (multi-select)

### Insight Box (Text Box):
> 💡 *Gap ratio 2010 yilda 2.8x bo'lgan, 2024 yilda 6.1x ga yetdi. Bu tengsizlik kengayib borayotganini ko'rsatadi.*

---

## 📄 PAGE 3 — Sector Structure

### Vizuallar:

| # | Visual turi | Ma'lumot | DAX Measure |
|---|-------------|---------|-------------|
| 1 | **Stacked Bar** | Viloyat bo'yicha sektor ulushlari | `Construction Share %`, `Agriculture Share %`, `Trade Share %` |
| 2 | **Area Chart** | Milliy sektor trendi (2010–2024) | SUM by sector by year |
| 3 | **KPI Cards** (3 ta) | Har bir sektor o'sish multiplier | `Construction Growth x`, `Agriculture Growth x`, `Trade Growth x` |
| 4 | **Donut Chart** | Joriy yil milliy sektor ulushi | 3 ta share measure |
| 5 | **Table** | Viloyat turi + ustun sektor | `Dominant Sector`, `Diversification Level` |
| 6 | **Scatter Plot** | Qishloq xo'jaligi ulushi vs Daromad | `Agriculture Share %` vs `Avg Income PC` |

### Slicerlar:
- 📅 Year
- 🗺️ Region
- 🏭 Sector (Agriculture / Construction / Trade)

### Annotation:
- Scatter plotda "zaif korrelyatsiya (r=0.43)" izohini qo'shing
- Area chartda "Qurilish eng tez o'sdi (+8.4x)" annotation

---

## 📄 PAGE 4 — Economic Drivers

### Vizuallar:

| # | Visual turi | Ma'lumot | DAX Measure |
|---|-------------|---------|-------------|
| 1 | **Horizontal Bar** | Korrelyatsiya ko'rsatkichlari | Hardcoded values yoki measure |
| 2 | **Scatter Plot** | Investitsiya vs Daromad | `Investment Index (0-100)` vs `Income Index (0-100)` |
| 3 | **Bar Chart** | GRP/investitsiya bo'yicha viloyat reytingi | `Avg Investment PC` |
| 4 | **KPI Card** | Eng kuchli driver | `Top Driver Label` |
| 5 | **KPI Card** | Investitsiya o'rtachasi | `Avg Investment PC` |
| 6 | **Line Chart** | Investitsiya trendi (yil bo'yicha) | `Avg Investment PC` by `year` |
| 7 | **Table** | Driver korrelyatsiya jadvali | Statik jadval yoki measure |

### Scatter Plot o'rnatish:
- X o'qi: `Investment Index (0-100)`
- Y o'qi: `Income Index (0-100)`
- Legend: `Region Type`
- Size: `Avg Income PC`
- Tooltip: viloyat nomi, investitsiya, daromad

### Slicerlar:
- 📅 Year (bu sahifada ALL filtr tavsiya etiladi)

---

## ⚙️ POWER BI O'RNATISH BOSQICHLARI

### 1. Ma'lumot import qilish
```
Excel/CSV fayllarini import → Power Query Editor → Gold layer
```

### 2. Modelni o'rnatish (Relationships)
```
fact_income[region]     → dim_regions[region]
fact_sectors[region]    → dim_regions[region]
fact_investment[region] → dim_regions[region]

fact_income[year]       → dim_calendar[year]
fact_sectors[year]      → dim_calendar[year]
fact_investment[year]   → dim_calendar[year]
```

### 3. Star Schema diagrammasi
```
         dim_regions
              │
    ┌─────────┼─────────┐
    │         │         │
fact_income  fact_sectors  fact_investment
    └─────────┼─────────┘
              │
         dim_calendar
```

### 4. Measures papkasini yaratish
- Blank table yarating: `_Measures`
- Barcha measurelarni shu jadvalga qo'shing
- Papkalar bo'yicha guruhlang (Display Folder)

### 5. Report theme
- File → Options → Report settings → Theme → JSON

```json
{
  "name": "UzbekistanEconomic",
  "dataColors": [
    "#1A5276", "#2E86C1", "#85C1E9", "#D6EAF8",
    "#27AE60", "#E67E22", "#C0392B", "#7F8C8D"
  ],
  "background": "#F4F6F7",
  "foreground": "#2C3E50",
  "tableAccent": "#2E86C1"
}
```

---

## 🏆 PORTFOLIO UCHUN TIPS

1. **Tooltiplar** — har bir vizualga custom tooltip page yarating
2. **Bookmarks** — "2024 Snapshot" va "Trend View" bookmark qo'shing
3. **Navigation buttons** — sahifalar orasida tugmalar bilan o'tish
4. **Mobile layout** — har bir sahifa uchun mobile view ham o'rnating
5. **Export** — har bir sahifadan PNG screenshot olib README ga qo'shing
6. **Performance Analyzer** — og'ir DAX measurelarni optimallashtiring

---

## 📊 DASHBOARD TITLE (Har sahifa uchun)

| Sahifa | Sarlavha | Pastki matn |
|--------|---------|-------------|
| Page 1 | **O'zbekiston Viloyatlari: Daromad Ko'rinishi** | 2024 yil holati · 14 viloyat · Stat.uz ma'lumotlari |
| Page 2 | **Mintaqaviy Daromad Tengsizligi: 2010–2024** | Gap ratio: 2.8x → 6.1x · Absolut farq: 50.72 mln UZS |
| Page 3 | **Sektor Tuzilmasi: Kim Nima Ishlaydi?** | Qurilish +8.4x · Qishloq x'jaligi +5.3x · Savdo +4.9x |
| Page 4 | **Daromad Omillari: Eng Kuchli Harakatlantiruvchilar** | Investitsiya r=0.97 · GRP r=0.91 |
