# STEP 2 — Data Model: Star Schema va Relationships
## Power BI Desktop → Model View

> **Ochish:** Power BI Desktop chap panelida **Model** ikonkasini bosing (3-chi ikon).
> Bu yerda barcha jadvallar, ustunlar va ular orasidagi bog'liqliklar ko'rinadi.

---

## 📐 Star Schema — Umumiy Ko'rinish

```
                    ┌─────────────────────┐
                    │    dim_calendar     │
                    │─────────────────────│
                    │ 🔑 year (PK)        │
                    │    decade           │
                    │    period_label     │
                    │    year_sort        │
                    └──────────┬──────────┘
                               │ 1
                               │
           ┌───────────────────┼───────────────────┐
           │ *                 │ *                 │ *
           ▼                   ▼                   ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────────┐
│   fact_income    │ │  fact_sectors    │ │   fact_investment    │
│──────────────────│ │──────────────────│ │──────────────────────│
│ 🔗 region  (FK) │ │ 🔗 region  (FK) │ │ 🔗 region      (FK) │
│ 🔗 year    (FK) │ │ 🔗 year    (FK) │ │ 🔗 year        (FK) │
│    income_pc     │ │    construction  │ │    inv_fixed_        │
│                  │ │    agriculture_  │ │    capital_pc        │
│                  │ │    output        │ └──────────┬───────────┘
│                  │ │    retail_trade  │            │ *
└────────┬─────────┘ └────────┬─────────┘           │
         │ *                  │ *                    │
         └──────────┬─────────┘                      │
                    │                                │
                    ▼ 1                              │
          ┌─────────────────────┐                   │
          │     dim_regions     │◄──────────────────┘
          │─────────────────────│
          │ 🔑 region (PK)      │
          │    region_type      │
          │    region_zone      │
          │    region_order     │
          └─────────────────────┘
```

**Schema turi:** `Star Schema` — 2 dimension + 3 fact jadval

---

## ⚙️ Relationships — Bog'liqliklarni O'rnatish

### Power BI da relationship yaratish usuli:
```
Model View → jadvallar orasidagi ustunni DRAG qiling
yoki
Home → Manage Relationships → New
```

### Barcha bog'liqliklar (jami: 6 ta):

#### Relationship 1: fact_income → dim_regions
| Parametr | Qiymat |
|----------|--------|
| From table | `fact_income` |
| From column | `region` |
| To table | `dim_regions` |
| To column | `region` |
| Cardinality | **Many to One (\*:1)** |
| Cross filter direction | **Single** (dim → fact) |
| Active | ✅ Yes |

#### Relationship 2: fact_income → dim_calendar
| Parametr | Qiymat |
|----------|--------|
| From table | `fact_income` |
| From column | `year` |
| To table | `dim_calendar` |
| To column | `year` |
| Cardinality | **Many to One (\*:1)** |
| Cross filter direction | **Single** |
| Active | ✅ Yes |

#### Relationship 3: fact_sectors → dim_regions
| Parametr | Qiymat |
|----------|--------|
| From table | `fact_sectors` |
| From column | `region` |
| To table | `dim_regions` |
| To column | `region` |
| Cardinality | **Many to One (\*:1)** |
| Cross filter direction | **Single** |
| Active | ✅ Yes |

#### Relationship 4: fact_sectors → dim_calendar
| Parametr | Qiymat |
|----------|--------|
| From table | `fact_sectors` |
| From column | `year` |
| To table | `dim_calendar` |
| To column | `year` |
| Cardinality | **Many to One (\*:1)** |
| Cross filter direction | **Single** |
| Active | ✅ Yes |

#### Relationship 5: fact_investment → dim_regions
| Parametr | Qiymat |
|----------|--------|
| From table | `fact_investment` |
| From column | `region` |
| To table | `dim_regions` |
| To column | `region` |
| Cardinality | **Many to One (\*:1)** |
| Cross filter direction | **Single** |
| Active | ✅ Yes |

#### Relationship 6: fact_investment → dim_calendar
| Parametr | Qiymat |
|----------|--------|
| From table | `fact_investment` |
| From column | `year` |
| To table | `dim_calendar` |
| To column | `year` |
| Cardinality | **Many to One (\*:1)** |
| Cross filter direction | **Single** |
| Active | ✅ Yes |

---

## 🗂️ Calculated Columns — dim_regions jadvaliga qo'shish

> **Qo'shish usuli:** Model View → dim_regions jadvalini tanlang →
> Table tools → New Column

### CC-1: income_tier (Daromad darajasi)
```dax
income_tier =
SWITCH(
    dim_regions[region],
    "Toshkent sh.",      "Tier 1 — Yuqori",
    "Navoiy",            "Tier 1 — Yuqori",
    "Toshkent vil.",     "Tier 2 — O'rta-yuqori",
    "Buxoro",            "Tier 2 — O'rta-yuqori",
    "Qashqadaryo",       "Tier 2 — O'rta-yuqori",
    "Jizzax",            "Tier 3 — O'rta",
    "Samarqand",         "Tier 3 — O'rta",
    "Sirdaryo",          "Tier 3 — O'rta",
    "Farg'ona",          "Tier 3 — O'rta",
    "Andijon",           "Tier 4 — Past",
    "Namangan",          "Tier 4 — Past",
    "Xorazm",            "Tier 4 — Past",
    "Surxondaryo",       "Tier 4 — Past",
    "Qoraqalpog'iston",  "Tier 4 — Past",
    "Noma'lum"
)
```

### CC-2: is_capital (Poytaxt belgisi — filtr uchun)
```dax
is_capital =
IF(dim_regions[region] = "Toshkent sh.", "Poytaxt", "Viloyat")
```

### CC-3: sort_order (Reytingda tartib)
```dax
sort_order =
SWITCH(
    dim_regions[region],
    "Toshkent sh.",      1,
    "Navoiy",            2,
    "Toshkent vil.",     3,
    "Buxoro",            4,
    "Qashqadaryo",       5,
    "Jizzax",            6,
    "Samarqand",         7,
    "Sirdaryo",          8,
    "Farg'ona",          9,
    "Andijon",           10,
    "Namangan",          11,
    "Xorazm",            12,
    "Surxondaryo",       13,
    "Qoraqalpog'iston",  14,
    99
)
```

---

## 📊 Calculated Columns — fact_income jadvaliga qo'shish

### CC-4: income_category (Har bir satr uchun kategoriya)
```dax
income_category =
VAR val = fact_income[income_pc]
RETURN
    SWITCH(
        TRUE(),
        val >= 40,  "Juda yuqori (40+ mln)",
        val >= 20,  "Yuqori (20–40 mln)",
        val >= 10,  "O'rta (10–20 mln)",
        val >= 5,   "Past (5–10 mln)",
        "Juda past (< 5 mln)"
    )
```

### CC-5: decade_group (fact_income → dim_calendar orqali)
```dax
decade_group =
RELATED(dim_calendar[decade])
```

---

## 🔧 Model Sozlamalari (Properties)

### Ustunlarni yashirish (Hide from Report View)
Quyidagi ustunlar slicerlarda ko'rinmasin — ularni yashiring:

```
dim_regions[region_order]    → yashirish ✅
dim_calendar[year_sort]      → yashirish ✅
fact_income[region]          → yashirish ✅  (dim_regions orqali ishlating)
fact_income[year]            → yashirish ✅  (dim_calendar orqali ishlating)
fact_sectors[region]         → yashirish ✅
fact_sectors[year]           → yashirish ✅
fact_investment[region]      → yashirish ✅
fact_investment[year]        → yashirish ✅
```

> **Yashirish usuli:** Model View → ustunni o'ng klik → Hide in report view

### Ustunlarga Format berish
```
fact_income[income_pc]              → Format: Decimal Number, 2 decimal
fact_sectors[construction]          → Format: Whole Number
fact_sectors[agriculture_output]    → Format: Whole Number
fact_sectors[retail_trade]          → Format: Whole Number
fact_investment[inv_fixed_capital_pc] → Format: Decimal Number, 2 decimal
```

### Sort By Column (To'g'ri tartiblash uchun)
```
dim_regions[region]      → Sort by: dim_regions[sort_order]
dim_calendar[decade]     → Sort by: dim_calendar[year] (birinchi yil)
```

> **Sort by usuli:** Model View → ustunni tanlang →
> Column tools → Sort by Column → kerakli ustunni tanlang

---

## 📁 _Measures jadvalini yaratish

> Barcha DAX Measurelar alohida jadvalda saqlansin — bu eng yaxshi amaliyot.

```
Power BI Desktop → Home → Enter Data
→ Name: _Measures
→ Bitta bo'sh ustun qo'shing: "placeholder"
→ Load
→ Model View → _Measures → placeholder ustunini o'ng klik → Hide
```

**Display Folders yaratish** (Measures papkalar bo'yicha guruhlash):
```
Measure ni tanlang → Properties paneli → Display folder:
  00_Base
  01_Income_Overview
  02_Gap_Analysis
  03_Sector_Structure
  04_Drivers
  05_KPI_Cards
  06_Formatting
```

---

## ✅ Model Tekshiruv Ro'yxati

Model to'g'ri o'rnatilganini tekshirish uchun:

- [ ] 6 ta relationship mavjud va barchasi **Active**
- [ ] Barcha relationship **Many-to-One (\*:1)** ko'rinishida
- [ ] dim_regions va dim_calendar jadvallarida takroriy qiymat yo'q (PK)
- [ ] fact jadvallarida region va year ustunlari to'g'ri nomlangan
- [ ] Model View da **sariq chiziqlar** yo'q (muammo belgisi)
- [ ] `_Measures` jadvali yaratilgan va yashirilgan ustunlari bor
- [ ] Ustunlar formatlangan (decimal, whole number)

---

## 🚨 Keng Tarqalgan Xatolar va Yechimlari

| Xato | Sabab | Yechim |
|------|-------|--------|
| "Relationship not active" | Bir xil jadvallar orasida 2 ta relationship | Birini Inactive qiling, USERELATIONSHIP() bilan ishlating |
| "Circular dependency" | A→B→A zanjiri | Star schemada faqat fact→dim yo'nalishi bo'lsin |
| Slicer filtr ishlamaydi | Cross filter direction noto'g'ri | Single → Both ga o'zgartiring (ehtiyotkorlik bilan) |
| Region nomlari mos kelmaydi | Excel va dim_regions da farq | Power Query silver_income da standartlashtiring |
| Blank qiymatlar ko'rinyapti | Relationship key da NULL bor | Power Query da NULL qatorlarni olib tashlang |
