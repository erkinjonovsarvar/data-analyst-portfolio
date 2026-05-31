# Power BI Setup Guide
## O'zbekiston Mintaqaviy Tahlili — model.bim Import Qo'llanmasi

---

## 📁 Fayl Tuzilmasi

```
powerbi_data/
├── model.bim                        ← Power BI Tabular Model (asosiy fayl)
├── uzbekistan_economic_theme.json   ← Rang sxemasi
├── dim_calendar.csv                 ← 2010–2024 kalendar
├── dim_regions.csv                  ← 15 viloyat meta-ma'lumot
├── fact_income.csv                  ← Daromad, GRP, Investitsiya (225 satr)
├── fact_economy.csv                 ← Sektorlar: qurilish, qishloq x-jaligi, savdo (225 satr)
└── fact_demographics.csv            ← Aholi, bandlik, tug'ilish (225 satr)
```

---

## ⚡ BOSQICH 1 — CSV fayllar yo'lini sozlash

`model.bim` faylini matn muharririda oching (VS Code yoki Notepad).
`[YOUR_PATH]` ni o'z CSV fayllar joylashgan papka yo'liga almashtiring.

**Misol (Windows):**
```
[YOUR_PATH]  →  C:\\Users\\Sarvar\\Downloads\\powerbi_data
```

**Almashtirish uchun** Ctrl+H bosing:
- Topish: `[YOUR_PATH]`
- Almashtirish: `C:\\Users\\SizningIsm\\powerbi_data`

---

## ⚡ BOSQICH 2 — model.bim ni Power BI ga import qilish

### Usul A — Tabular Editor (Tavsiya etiladi ✅)
```
1. Tabular Editor 3 ni yuklab oling (bepul versiyasi bor):
   https://www.tabulareditor.com/downloads/

2. Power BI Desktop ni oching → yangi bo'sh fayl yarating

3. External Tools panelida → Tabular Editor ni oching

4. Tabular Editor → File → Open → model.bim ni tanlang

5. Save (Ctrl+S) → Power BI ga qaytib o'ting

6. Power BI → Refresh → barcha jadvallar va measurelar paydo bo'ladi
```

### Usul B — XMLA Endpoint (Power BI Service kerak)
```
1. Power BI Service → Workspace → Settings → Premium features → XMLA: Read/Write
2. SQL Server Management Studio → Connect → Analysis Services
3. Server: powerbi://api.powerbi.com/v1.0/myorg/[workspace]
4. Restore yoki Deploy → model.bim faylini tanlang
```

### Usul C — Eng Oddiy (CSV to'g'ridan import)
```
Agar Tabular Editor bo'lmasa, quyidagicha qiling:

1. Power BI Desktop → Home → Get Data → Text/CSV
2. Navbat bilan yuklang:
   ✅ dim_calendar.csv
   ✅ dim_regions.csv
   ✅ fact_income.csv
   ✅ fact_economy.csv
   ✅ fact_demographics.csv

3. Har biri uchun Transform → to'g'ri tiplarga o'zgartiring

4. Close & Apply

5. Model View → Relationships qo'lda o'rnating (quyida ko'rsatilgan)

6. DAX measurelarni 03_dax_measures.md faylidan nusxa ko'chiring
```

---

## ⚡ BOSQICH 3 — Relationships (Agar qo'lda o'rnatilsa)

```
Model View → Manage Relationships → New

Har biri uchun:
  fact_income[region]        → dim_regions[region]     (Many:1, Single)
  fact_income[year]          → dim_calendar[year]      (Many:1, Single)
  fact_economy[region]       → dim_regions[region]     (Many:1, Single)
  fact_economy[year]         → dim_calendar[year]      (Many:1, Single)
  fact_demographics[region]  → dim_regions[region]     (Many:1, Single)
  fact_demographics[year]    → dim_calendar[year]      (Many:1, Single)
```

---

## ⚡ BOSQICH 4 — _Measures jadvali

```
1. Home → Enter Data → Name: _Measures → bitta bo'sh ustun → Load
2. Model View → _Measures → ustunni Hide qiling
3. 03_dax_measures.md dan DAX measurelarni nusxa ko'chiring
4. Har bir measure uchun: Table tools → New Measure → DAX ni kiriting
```

---

## ⚡ BOSQICH 5 — Theme qo'llash

```
1. View → Themes → Browse for themes
2. uzbekistan_economic_theme.json ni tanlang
3. OK → barcha vizuallar yangi rangda bo'ladi
```

---

## ✅ Star Schema Diagrammasi

```
           dim_calendar
          [year PK]
               │1
    ┌──────────┼──────────┐
    │*         │*         │*
fact_income  fact_economy  fact_demographics
[region FK]  [region FK]  [region FK]
[year FK]    [year FK]    [year FK]
    └──────────┼──────────┘
               │*
           dim_regions
          [region PK]
               │
           _Measures
          [59 DAX]
```

---

## 📊 Measure Ro'yxati (59 ta, 7 papkada)

| Papka | Miqdor | Asosiy measurelar |
|-------|--------|-------------------|
| `00_Base` | 5 | Avg Income PC, National Avg, Income 2024/2010 |
| `01_Income_Overview` | 10 | Rank, YoY%, Quartile, Deviation |
| `02_Gap_Analysis` | 8 | Absolute Gap, Gap Ratio, Tashkent vs QQ |
| `03_Sector_Structure` | 10 | Shares%, Growth X, HHI Index |
| `04_Drivers` | 10 | Investment, Employment, GRP, Trade |
| `05_KPI_Cards` | 8 | Tayyor KPI qiymatlar |
| `06_Formatting` | 5 | Conditional Formatting ranglari |
| `07_Demographics` | 3 | Natural Growth, Births/Deaths per 1000 |

---

## 🚨 Keng Tarqalgan Xatolar

| Xato | Yechim |
|------|--------|
| CSV import da encoding xato | Power Query → Transform → encoding: UTF-8 |
| Region nomlari mos kelmaydi | dim_regions[region] va fact fayllar bir xil bo'lsin |
| Relationship yaratilmaydi | Fact jadvallardagi region/year ustunlari PK emas (normal) |
| Measures ko'rinmaydi | _Measures jadvalini model ga qo'shing |
| Blank qiymatlar | fact fayllarida NULL qatorlar yo'qligini tekshiring |

---

## 📞 Yordam

Muammo bo'lsa, GitHub Issues ga yozing yoki
`03_dax_measures.md` faylini qayta ko'rib chiqing.
