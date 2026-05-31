# STEP 1 — Power Query: Ma'lumotlarni Tayyorlash
## Bronze → Silver → Gold Layer

> **Muhim:** Bu qo'llanma Power BI Desktop → Home → Transform Data (Power Query Editor) ichida bajariladigan amallarni o'z ichiga oladi.
> Har bir M-code ni Advanced Editor ichiga ko'chirib joylashtiring.

---

## 📁 Fayl strukturasi (siz import qiladigan Excel/CSV)

```
stat_uz_data.xlsx
├── Sheet: income_raw        ← region, year, income_pc
├── Sheet: industry_raw      ← region, year, industry_output
├── Sheet: agriculture_raw   ← region, year, agriculture_output
├── Sheet: business_raw      ← region, year, business_activity
├── Sheet: investment_raw    ← region, year, inv_fixed_capital_pc
```

---

## 🥉 BRONZE LAYER — Xom ma'lumotni yuklash

### 1.1 Excel faylni import qilish
```
Power BI Desktop → Home → Get Data → Excel Workbook
→ stat_uz_data.xlsx ni tanlang
→ Navigator oynasida barcha sheetlarni belgilang
→ Transform Data tugmasini bosing (Load emas!)
```

### 1.2 Har bir jadval uchun Bronze query (M-code)

**bronze_income:**
```m
let
    Source = Excel.Workbook(
        File.Contents("C:\YourPath\stat_uz_data.xlsx"),
        null, true
    ),
    income_raw = Source{[Item="income_raw", Kind="Sheet"]}[Data],
    // Birinchi qatorni sarlavha sifatida olish
    promoted_headers = Table.PromoteHeaders(income_raw, [PromoteAllScalars=true]),
    // Ustun turlarini belgilash
    changed_types = Table.TransformColumnTypes(promoted_headers, {
        {"region",    type text},
        {"year",      Int64.Type},
        {"income_pc", type number}
    })
in
    changed_types
```

**bronze_industry:**
```m
let
    Source = Excel.Workbook(
        File.Contents("C:\YourPath\stat_uz_data.xlsx"),
        null, true
    ),
    industry_raw = Source{[Item="industry_raw", Kind="Sheet"]}[Data],
    promoted_headers = Table.PromoteHeaders(industry_raw, [PromoteAllScalars=true]),
    changed_types = Table.TransformColumnTypes(promoted_headers, {
        {"region",           type text},
        {"year",             Int64.Type},
        {"industry_output",  type number}
    })
in
    changed_types
```

**bronze_agriculture:**
```m
let
    Source = Excel.Workbook(
        File.Contents("C:\YourPath\stat_uz_data.xlsx"),
        null, true
    ),
    agriculture_raw = Source{[Item="agriculture_raw", Kind="Sheet"]}[Data],
    promoted_headers = Table.PromoteHeaders(agriculture_raw, [PromoteAllScalars=true]),
    changed_types = Table.TransformColumnTypes(promoted_headers, {
        {"region",              type text},
        {"year",                Int64.Type},
        {"agriculture_output",  type number}
    })
in
    changed_types
```

**bronze_business:**
```m
let
    Source = Excel.Workbook(
        File.Contents("C:\YourPath\stat_uz_data.xlsx"),
        null, true
    ),
    business_raw = Source{[Item="business_raw", Kind="Sheet"]}[Data],
    promoted_headers = Table.PromoteHeaders(business_raw, [PromoteAllScalars=true]),
    changed_types = Table.TransformColumnTypes(promoted_headers, {
        {"region",            type text},
        {"year",              Int64.Type},
        {"business_activity", type number}
    })
in
    changed_types
```

**bronze_investment:**
```m
let
    Source = Excel.Workbook(
        File.Contents("C:\YourPath\stat_uz_data.xlsx"),
        null, true
    ),
    investment_raw = Source{[Item="investment_raw", Kind="Sheet"]}[Data],
    promoted_headers = Table.PromoteHeaders(investment_raw, [PromoteAllScalars=true]),
    changed_types = Table.TransformColumnTypes(promoted_headers, {
        {"region",                type text},
        {"year",                  Int64.Type},
        {"inv_fixed_capital_pc",  type number}
    })
in
    changed_types
```

---

## 🥈 SILVER LAYER — Tozalash va Standartlashtirish

### 2.1 Region nomlarini standartlashtirish

**Muammo:** Excel faylida "Toshkent shahri", "Toshkent sh", "toshkent sh." kabi turli yozuvlar bo'lishi mumkin.

**silver_income** (Advanced Editor → yangi query yarating):
```m
let
    Source = bronze_income,

    // ── 1. Bo'sh qatorlarni olib tashlash ──
    removed_blanks = Table.SelectRows(Source, each
        [region] <> null and [region] <> "" and
        [income_pc] <> null and [income_pc] > 0
    ),

    // ── 2. Region nomlarini trim qilish ──
    trimmed_region = Table.TransformColumns(removed_blanks, {
        {"region", each Text.Trim(Text.Proper(_)), type text}
    }),

    // ── 3. Region nomlarini STANDARTLASHTIRISH ──
    //    (sizning Excel faylida qanday yozilgan bo'lsa, shunga moslang)
    standardized_region = Table.TransformColumns(trimmed_region, {
        {"region", each
            let
                r = _
            in
                if Text.Contains(r, "Toshkent Sh")    then "Toshkent sh."
                else if Text.Contains(r, "Toshkent V") then "Toshkent vil."
                else if Text.Contains(r, "Qoraqalp")  then "Qoraqalpog'iston"
                else if Text.Contains(r, "Navoiy")    then "Navoiy"
                else if Text.Contains(r, "Buxoro")    then "Buxoro"
                else if Text.Contains(r, "Samarqand") then "Samarqand"
                else if Text.Contains(r, "Qashqadar") then "Qashqadaryo"
                else if Text.Contains(r, "Surxon")    then "Surxondaryo"
                else if Text.Contains(r, "Jizzax")    then "Jizzax"
                else if Text.Contains(r, "Sirdaryo")  then "Sirdaryo"
                else if Text.Contains(r, "Farg")      then "Farg'ona"
                else if Text.Contains(r, "Andijon")   then "Andijon"
                else if Text.Contains(r, "Namangan")  then "Namangan"
                else if Text.Contains(r, "Xorazm")    then "Xorazm"
                else r,
            type text
        }
    }),

    // ── 4. Yil diapazonini tekshirish (2010–2024) ──
    filtered_years = Table.SelectRows(standardized_region, each
        [year] >= 2010 and [year] <= 2024
    ),

    // ── 5. Dublikatlarni olib tashlash ──
    removed_dupes = Table.Distinct(filtered_years, {"region", "year"})
in
    removed_dupes
```

**silver_sectors** (industry + agriculture + business ni birlashtirish):
```m
let
    // ── Uchta sektornni Join qilish ──
    ind  = bronze_industry,
    agri = bronze_agriculture,
    biz  = bronze_business,

    // ── 1. Industry va Agriculture ni region+year bo'yicha birlashtirish ──
    join_agri = Table.NestedJoin(
        ind, {"region", "year"},
        agri, {"region", "year"},
        "agri_data", JoinKind.Left
    ),
    expand_agri = Table.ExpandTableColumn(
        join_agri, "agri_data",
        {"agriculture_output"}, {"agriculture_output"}
    ),

    // ── 2. Business ni ham qo'shish ──
    join_biz = Table.NestedJoin(
        expand_agri, {"region", "year"},
        biz, {"region", "year"},
        "biz_data", JoinKind.Left
    ),
    expand_biz = Table.ExpandTableColumn(
        join_biz, "biz_data",
        {"business_activity"}, {"business_activity"}
    ),

    // ── 3. NULL qiymatlarni 0 ga almashtirish ──
    replace_nulls = Table.ReplaceValue(
        expand_biz, null, 0,
        Replacer.ReplaceValue,
        {"agriculture_output", "business_activity"}
    ),

    // ── 4. Turlarni sozlash ──
    changed_types = Table.TransformColumnTypes(replace_nulls, {
        {"region",              type text},
        {"year",                Int64.Type},
        {"industry_output",     type number},
        {"agriculture_output",  type number},
        {"business_activity",   type number}
    }),

    // ── 5. Yil filter ──
    filtered_years = Table.SelectRows(changed_types, each
        [year] >= 2010 and [year] <= 2024
    )
in
    filtered_years
```

**silver_investment:**
```m
let
    Source = bronze_investment,

    // ── 1. NULL va nol qiymatlarni olib tashlash ──
    clean = Table.SelectRows(Source, each
        [inv_fixed_capital_pc] <> null and [inv_fixed_capital_pc] > 0
    ),

    // ── 2. Yil filtri ──
    filtered = Table.SelectRows(clean, each
        [year] >= 2010 and [year] <= 2024
    ),

    // ── 3. Dublikatlar ──
    no_dupes = Table.Distinct(filtered, {"region", "year"})
in
    no_dupes
```

---

## 🥇 GOLD LAYER — Tahlilga tayyor jadvallar

### 3.1 fact_income (Power BI ga yuklanadigan asosiy fact jadval)
```m
let
    Source = silver_income,

    // ── Faqat kerakli ustunlarni qoldirish ──
    selected = Table.SelectColumns(Source, {
        "region", "year", "income_pc"
    }),

    // ── income_pc ni million UZS ga o'tkazish (agar kerak bo'lsa) ──
    // Agar ma'lumot allaqachon mln UZS da bo'lsa — bu qatorni o'chirish
    // converted = Table.TransformColumns(selected, {
    //     {"income_pc", each _ / 1000000, type number}
    // }),

    // ── Saralash ──
    sorted = Table.Sort(selected, {
        {"region", Order.Ascending},
        {"year",   Order.Ascending}
    })
in
    sorted
```

### 3.2 fact_sectors
```m
let
    Source = silver_sectors,

    // ── Ustunlarni tanlash va tartibga solish ──
    selected = Table.SelectColumns(Source, {
        "region", "year",
        "industry_output",
        "agriculture_output",
        "business_activity"
    }),

    // ── Ustun nomlarini qayta nomlash (dashboard uchun tushunarli) ──
    renamed = Table.RenameColumns(selected, {
        {"industry_output",    "construction"},
        {"business_activity",  "retail_trade"}
    }),

    sorted = Table.Sort(renamed, {
        {"region", Order.Ascending},
        {"year",   Order.Ascending}
    })
in
    sorted
```

### 3.3 fact_investment
```m
let
    Source = silver_investment,

    selected = Table.SelectColumns(Source, {
        "region", "year", "inv_fixed_capital_pc"
    }),

    sorted = Table.Sort(selected, {
        {"region", Order.Ascending},
        {"year",   Order.Ascending}
    })
in
    sorted
```

### 3.4 dim_regions (Enter Data yoki M-code bilan yaratish)
```
Power BI Desktop → Home → Enter Data → quyidagi jadval ma'lumotlarini kiriting:
```

| region | region_type | region_zone | region_order |
|--------|-------------|-------------|--------------|
| Toshkent sh. | Urban/Industrial | Markaziy | 1 |
| Navoiy | Urban/Industrial | G'arbiy | 2 |
| Toshkent vil. | Mixed | Markaziy | 3 |
| Buxoro | Mixed | G'arbiy | 4 |
| Qashqadaryo | Mixed | Janubiy | 5 |
| Jizzax | Mixed | Markaziy | 6 |
| Samarqand | Mixed | Janubiy-Markaziy | 7 |
| Sirdaryo | Agricultural | Markaziy | 8 |
| Farg'ona | Trade-oriented | Sharqiy | 9 |
| Andijon | Trade-oriented | Sharqiy | 10 |
| Namangan | Trade-oriented | Sharqiy | 11 |
| Xorazm | Agricultural | G'arbiy | 12 |
| Surxondaryo | Agricultural | Janubiy | 13 |
| Qoraqalpog'iston | Agricultural | G'arbiy | 14 |

**Yoki M-code sifatida (New Query → Blank Query → Advanced Editor):**
```m
let
    Source = Table.FromRows(
        {
            {"Toshkent sh.",      "Urban/Industrial",  "Markaziy",          1},
            {"Navoiy",            "Urban/Industrial",  "G'arbiy",           2},
            {"Toshkent vil.",     "Mixed",             "Markaziy",          3},
            {"Buxoro",            "Mixed",             "G'arbiy",           4},
            {"Qashqadaryo",       "Mixed",             "Janubiy",           5},
            {"Jizzax",            "Mixed",             "Markaziy",          6},
            {"Samarqand",         "Mixed",             "Janubiy-Markaziy",  7},
            {"Sirdaryo",          "Agricultural",      "Markaziy",          8},
            {"Farg'ona",          "Trade-oriented",    "Sharqiy",           9},
            {"Andijon",           "Trade-oriented",    "Sharqiy",           10},
            {"Namangan",          "Trade-oriented",    "Sharqiy",           11},
            {"Xorazm",            "Agricultural",      "G'arbiy",           12},
            {"Surxondaryo",       "Agricultural",      "Janubiy",           13},
            {"Qoraqalpog'iston",  "Agricultural",      "G'arbiy",           14}
        },
        type table [
            region        = text,
            region_type   = text,
            region_zone   = text,
            region_order  = Int64.Type
        ]
    )
in
    Source
```

### 3.5 dim_calendar (New Query → Blank Query)
```m
let
    years = { 2010 .. 2024 },
    to_table = Table.FromList(years, Splitter.SplitByNothing(), {"year"}),
    changed_type = Table.TransformColumnTypes(to_table, {{"year", Int64.Type}}),

    with_decade = Table.AddColumn(changed_type, "decade", each
        if [year] <= 2014 then "2010–2014"
        else if [year] <= 2019 then "2015–2019"
        else "2020–2024",
        type text
    ),

    with_period = Table.AddColumn(with_decade, "period_label", each
        if [year] <= 2014 then "Dastlabki davr"
        else if [year] <= 2019 then "O'tish davri"
        else "Zamonaviy davr",
        type text
    ),

    with_sort = Table.AddColumn(with_period, "year_sort", each [year], Int64.Type)
in
    with_sort
```

---

## ✅ Power Query Yakunlash Qadamlari

```
1. Har bir query ni yarating (yuqoridagi nomlar bilan)
2. Bronze querylar → Properties → "Enable Load" = OFF qiling
   (Ular faqat Silver uchun asos, Power BI ga yuklanmasin)
3. Silver querylar → "Enable Load" = OFF
4. Gold querylar (fact_income, fact_sectors, fact_investment,
   dim_regions, dim_calendar) → "Enable Load" = ON ✅
5. Home → Close & Apply
```

> 💡 **Pro tip:** Query larni Power Query Editor → Queries panelida guruhlang:
> - 📁 Bronze
> - 📁 Silver  
> - 📁 Gold (faqat bular Power BI ga yuklanadi)
