# Power BI Dashboard — Regional Economic Analysis of Uzbekistan
## Microsoft Power BI · DAX · Power Query · Star Schema

> **Muallif:** Sarvar Erkinjonov
> **Manba:** Stat.uz (O'zbekiston Statistika Qo'mitasi)
> **Qamrov:** 14 viloyat · 2010–2024 (15 yil) · 210 kuzatuv
> **Vositalar:** Power BI Desktop · DAX · Power Query (M) · Python · SQL

---

## 📌 Dashboard Haqida

Bu dashboard O'zbekiston viloyatlarining 2010–2024 yillar orasidagi
iqtisodiy rivojlanishini tahlil qiladi. Asosiy savollar:

| # | Savol | Sahifa |
|---|-------|--------|
| 1 | Qaysi viloyatlar daromad bo'yicha oldinda, qaysilari orqada? | Page 1 |
| 2 | Mintaqalar orasidagi tengsizlik kengaymoqdami yoki toraymoqdami? | Page 2 |
| 3 | Qaysi iqtisodiy sektor qaysi viloyatda ustunlik qiladi? | Page 3 |
| 4 | Daromad o'sishining eng kuchli harakatlantiruvchisi nima? | Page 4 |

---

## 📊 Asosiy Ko'rsatkichlar (2024)

| KPI | Qiymat |
|-----|--------|
| Milliy o'rtacha daromad | **38.60 mln UZS** |
| Eng yuqori daromad | **60.59 mln UZS** — Toshkent sh. |
| Eng past daromad | **9.87 mln UZS** — Qoraqalpog'iston |
| Gap ratio (Top÷Bottom) | **6.14x** (2010 da 2.81x edi) |
| Mutloq farq | **50.72 mln UZS** (2010 da 2.71 mln edi) |
| Daromad o'sishi (2010→2024) | **17.6x** (milliy o'rtacha) |
| Eng kuchli driver | **Investitsiya** (r = 0.97) |
| Eng tez o'sgan sektor | **Qurilish** (+8.4x) |

---

## 🗂️ Fayl Tuzilmasi

```
power_bi/
├── README.md                  ← Shu fayl
├── 01_power_query.md          ← STEP 1: M-code (Bronze→Silver→Gold)
├── 02_data_model.md           ← STEP 2: Star Schema, Relationships
├── 03_dax_measures.md         ← STEP 3: 55 ta DAX Measure
├── 04_report_pages.md         ← STEP 4: 5 sahifa vizual sozlamalar
├── 05_theme_formatting.md     ← STEP 5: Theme JSON, Tooltips, Bookmarks
└── uzbekistan_economic_theme.json  ← Power BI tema fayli
```

---

## 🏗️ Texnik Arxitektura

### Data Pipeline
```
Stat.uz Excel
     │
     ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   BRONZE    │───▶│   SILVER    │───▶│    GOLD     │
│  Xom yuklam │    │  Tozalash   │    │ Tahlilga    │
│  (M-code)   │    │  Standart.  │    │ tayyor      │
└─────────────┘    └─────────────┘    └─────────────┘
                                            │
                                            ▼
                                    ┌───────────────┐
                                    │  STAR SCHEMA  │
                                    │  dim_regions  │
                                    │  dim_calendar │
                                    │  fact_income  │
                                    │  fact_sectors │
                                    │  fact_invest. │
                                    └───────────────┘
                                            │
                                            ▼
                                    ┌───────────────┐
                                    │  55 DAX       │
                                    │  MEASURES     │
                                    └───────────────┘
                                            │
                                            ▼
                                    ┌───────────────┐
                                    │  5 SAHIFA     │
                                    │  DASHBOARD    │
                                    └───────────────┘
```

### Star Schema (5 jadval, 6 relationship)
```
              dim_calendar
             [year PK]
                  │ 1
       ┌──────────┼──────────┐
       │ *        │ *        │ *
  fact_income  fact_sectors  fact_investment
  [region FK]  [region FK]  [region FK]
  [year FK]    [year FK]    [year FK]
       └──────────┼──────────┘
                  │ *
              dim_regions
             [region PK]
```

---

## 📄 Dashboard Sahifalari

### 00_Cover — Navigatsiya Muqovasi
- 4 ta navigation button (har sahifaga)
- Dashboard umumiy tavsifi
- Muallif va manba ma'lumotlari

### 01_Income_Overview — Daromad Ko'rinishi
| Visual | Turi | Maqsad |
|--------|------|--------|
| 4 ta KPI Card | Card | Milliy avg, Top, Bottom, 17.6x |
| Viloyat reytingi | Horizontal Bar | Daromad bo'yicha ranking |
| Daromad trendi | Line Chart | 2010–2024 dinamikasi |
| Heatmap matrix | Matrix | Viloyat × Yil heat map |

**Slicerlar:** Yil · Viloyat · Kvartil
**Bookmarks:** `2024 📸` · `2010 📊` · `Q1 ⬇️`

### 02_Gap_Analysis — Tengsizlik Tahlili
| Visual | Turi | Maqsad |
|--------|------|--------|
| 4 ta KPI Card | Card | Farq, Ratio, 2010 holat, O'zgarish |
| Gap Ratio trendi | Line Chart | 2.81x → 6.14x yo'li |
| Top vs Bottom | Clustered Bar | Toshkent va Qoraqalpog' yonma-yon |
| Deviation chart | Waterfall | O'rtachadan og'ish |

**Slicerlar:** Yil diapazoni · Viloyat
**Bookmarks:** `To'liq trend` · `So'nggi 5 yil`

### 03_Sector_Structure — Sektor Tuzilmasi
| Visual | Turi | Maqsad |
|--------|------|--------|
| 3 ta KPI Card | Card | +8.4x, +5.3x, +4.9x |
| Sektor ulushi | 100% Stacked Bar | Har viloyat sektor tarkibi |
| Milliy ulush | Donut Chart | 2024 yil uchun |
| Sektor trendi | Area Chart | 2010–2024 o'sish |
| Jadval | Table | Ustun sektor + Diversifikatsiya |

**Slicerlar:** Yil · Viloyat turi (tile slicer)
**Bookmarks:** `Agrar viloyatlar` · `Urban viloyatlar`

### 04_Economic_Drivers — Iqtisodiy Omillar
| Visual | Turi | Maqsad |
|--------|------|--------|
| 4 ta KPI Card | Card | r=0.97, r=0.89, r=0.86, r=0.43 |
| Korrelyatsiya bar | Horizontal Bar | 6 ta driver taqqoslash |
| Scatter plot | Scatter | Investitsiya ↔ Daromad (R²=0.94) |
| Investitsiya reytingi | Bar Chart | Viloyat bo'yicha investitsiya |

**Slicerlar:** Yil (All tavsiya)
**Bookmarks:** `Barcha yillar`

---

## 🧮 DAX Measures — 55 ta (6 papka)

| Papka | Measures soni | Maqsad |
|-------|--------------|--------|
| `00_Base` | 5 | Asosiy hisob-kitob |
| `01_Income_Overview` | 10 | Daromad tahlili |
| `02_Gap_Analysis` | 9 | Tengsizlik o'lchovi |
| `03_Sector_Structure` | 10 | Sektor hisob |
| `04_Drivers` | 10 | Korrelyatsiya va indekslar |
| `05_KPI_Cards` | 6 | Tayyor KPI qiymatlari |
| `06_Formatting` | 5 | Conditional formatting ranglari |

Barcha measurelar → [`03_dax_measures.md`](./03_dax_measures.md)

---

## 🎨 Dizayn Tizimi

### Rang Sxemasi
| Rol | Hex | Ishlatiladi |
|-----|-----|-------------|
| Primary dark | `#1A5276` | Header, high income |
| Primary | `#2E86C1` | Accent, bars |
| Primary light | `#85C1E9` | Secondary bars |
| Primary pale | `#D6EAF8` | Low income, background |
| Positive | `#27AE60` | O'sish, yaxshi ko'rsatkich |
| Warning | `#E67E22` | O'rta tengsizlik, reference |
| Negative | `#C0392B` | Pasayish, yuqori tengsizlik |
| Premium | `#6C3483` | Drivers sahifasi |

### Typography
| Element | Font | O'lcham |
|---------|------|---------|
| Sahifa sarlavhasi | Segoe UI Semibold | 18pt |
| KPI qiymat | Segoe UI Bold | 28pt |
| KPI label | Segoe UI | 10pt |
| Axis/data labels | Segoe UI | 9–10pt |
| Tooltip sarlavha | Segoe UI Bold | 14pt |

### Custom Tooltips (4 ta)
| Tooltip sahifasi | Qaysi vizual uchun |
|------------------|--------------------|
| `tooltip_region_detail` | Page 1–2 Bar charts |
| `tooltip_gap_year` | Page 2 Line chart |
| `tooltip_sector_region` | Page 3 Stacked bar |
| `tooltip_driver_scatter` | Page 4 Scatter |

---

## ⚙️ Texnik Talablar

| Talab | Qiymat |
|-------|--------|
| Power BI Desktop versiya | 2.0+ (2023 yoki yangi) |
| Ma'lumot manbasi | Excel (.xlsx) yoki CSV |
| Ma'lumot hajmi | ~210 satr × 5 ustun (kichik) |
| Refresh turi | Manual (yillik yangilanish) |
| Import mode | Import (DirectQuery emas) |
| RLS | Ixtiyoriy (namuna qo'llanmada bor) |

---

## 🚀 Boshlash Uchun

```
1. Power BI Desktop ni oching
2. Get Data → Excel → stat_uz_data.xlsx
3. Transform Data → Power Query Editor
   → 01_power_query.md dagi M-code ni Advanced Editor ga joylashtiring
4. Close & Apply
5. Model View → 02_data_model.md bo'yicha relationships yarating
6. _Measures jadvali yarating
   → 03_dax_measures.md dagi barcha DAX ni kiriting
7. Report View → 04_report_pages.md bo'yicha vizuallarni yarating
8. View → Themes → 05_theme_formatting.md dagi JSON ni qo'llang
9. Tooltip sahifalarini yarating
10. Bookmarks qo'shing
11. File → Publish → Power BI Service
```

---

## 📸 Screenshots

> *Dashboard tugatilgandan so'ng quyidagi fayllarni qo'shing:*

```
power_bi/screenshots/
├── 00_cover.png
├── 01_income_overview.png
├── 02_gap_analysis.png
├── 03_sector_structure.png
└── 04_economic_drivers.png
```

---

## 🔗 Loyiha Bilan Bog'liq Fayllar

| Fayl | Maqsad |
|------|--------|
| [`../sql/`](../sql/) | SQL tahlil so'rovlari (4 ta) |
| [`../insights/`](../insights/) | Tahlil natijalari (4 ta .md) |
| [`../../python/stat_uz_analysis/`](../../python/stat_uz_analysis/) | Python EDA notebook |

---

## 💼 Portfolio Uchun Eslatma

Bu loyiha quyidagi texnik ko'nikmalarni namoyish etadi:

- ✅ **Power Query (M)** — Bronze→Silver→Gold ETL pipeline
- ✅ **Star Schema** — professional data modeling
- ✅ **DAX** — 55 ta measure (CALCULATE, FILTER, VAR, RANKX, MAXX/MINX, DIVIDE, SWITCH, time intelligence)
- ✅ **Conditional Formatting** — measure asosida dinamik ranglar
- ✅ **Custom Tooltips** — professional UX
- ✅ **Bookmarks + Navigation** — interaktiv storytelling
- ✅ **Performance Optimization** — VAR pattern, Import mode
- ✅ **Mobile Layout** — responsive dizayn
- ✅ **RLS** — xavfsizlik namunasi
