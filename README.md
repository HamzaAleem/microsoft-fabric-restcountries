# 🌍 Microsoft Fabric — REST Countries Analytics Platform

![Microsoft Fabric](https://img.shields.io/badge/Microsoft%20Fabric-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PySpark](https://img.shields.io/badge/PySpark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge)

> End-to-end data engineering project on Microsoft Fabric — live REST API ingestion,
> medallion architecture transformation, and world analytics dashboard in Power BI.

---

## 📌 Project Overview

Builds a fully automated analytics platform on Microsoft Fabric that:
- Ingests live country data daily from the **REST Countries API** (no API key, always free)
- Transforms complex nested JSON through a Bronze → Silver → Gold medallion architecture
- Delivers a star schema optimized for Power BI analytics
- Refreshes automatically on a daily schedule via Data Factory pipelines

**API Source:** `https://restcountries.com/v3.1/all`
250+ countries · 80+ fields per record · Complex nested JSON · No authentication required

---

## 🏛️ Architecture

```
REST Countries API
       ↓  HTTP GET (Data Factory Pipeline)
Bronze Lakehouse      raw JSON → Delta table
       ↓  PySpark Notebook
Silver Lakehouse      flattened + cleaned Delta tables
       ↓  PySpark Notebook
Gold Lakehouse        star schema (dim + fact Delta tables)
       ↓  T-SQL Views
Fabric Warehouse      SQL analytics endpoint
       ↓  Auto-generated
Semantic Model        relationships + DAX measures
       ↓  DirectLake
Power BI Report       world analytics dashboard
```

---

## 🗄️ Data Model

```
dim_regions ──────────────────────────────────────────────┐
(region_key PK, region, subregion)                        │
                                                          │
dim_countries ────────────────────────────────────────┐   │
(country_key PK, country_name, capital, continent,    │   │
 latitude, longitude, is_landlocked, is_un_member,    ├───┘
 primary_currency_code, language_count, flag_emoji)   │
                                                      │
fact_country_metrics ──────────────────────────── FK ─┤
(population, area_km2, population_density,            │
 size_category, population_category)                  │
                                                      │
fact_country_languages ────────────────────────── FK ─┤
(language_code, language_name)                        │
                                                      │
fact_country_currencies ───────────────────────── FK ──┘
(currency_code, currency_name, currency_symbol)
```

---

## 🔧 Key Transformations

| Layer | Challenge | Technique |
|---|---|---|
| Bronze → Silver | Nested struct: `name.common`, `name.official` | `col("name.common")` struct access |
| Bronze → Silver | Array fields: `capital[0]`, `timezones[0]` | Array indexing + null guard |
| Bronze → Silver | Map fields: currencies, languages | `explode_outer()` + `map_keys()` |
| Bronze → Silver | Multiple currencies per country | Exploded to separate table |
| Bronze → Silver | Multiple languages per country | Exploded to separate table |
| Silver → Gold | Population density calculation | `population / area_km2` with null guard |
| Silver → Gold | Size classification | `CASE` bins on area_km2 |
| Silver → Gold | Population classification | `CASE` bins on population |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Microsoft Fabric Trial | Unified analytics platform |
| Data Factory Pipeline | HTTP connector → REST API ingestion |
| Fabric Lakehouse (×3) | OneLake Delta table storage per layer |
| PySpark Notebooks (×3) | Bronze/Silver/Gold transformations |
| Fabric Warehouse | T-SQL endpoint over Gold Delta tables |
| Semantic Model | Relationships + DAX measures |
| Power BI | World analytics dashboard |

---

## 🚀 How to Run

1. Sign up for Microsoft Fabric trial at `https://app.fabric.microsoft.com`
2. Create workspace `RestCountries-Fabric`
3. Create 3 Lakehouses: Bronze, Silver, Gold
4. Create and run `PL_Ingest_RestCountries_Bronze` pipeline
5. Run notebooks in order: NB_01 → NB_02 → NB_03
6. Create Warehouse and run `sql/warehouse_views.sql`
7. Open Semantic Model — define relationships and add DAX measures
8. Build Power BI report from Semantic Model

**Or run everything at once:**
Trigger `PL_Master_Orchestration` — runs API ingest + all 3 notebooks automatically.

---

## 📊 Power BI Dashboard Pages

- **World Overview** — KPIs, population map, country counts by region
- **Regional Analysis** — Matrix drill-down region → subregion → country
- **Languages & Currencies** — Top spoken languages, most used currencies
- **Country Deep Dive** — Single-country selector with all metrics

---

## 👤 Author

**Hamza** — Senior Data & Inventory Analyst → Data Engineering
📍 Karachi, Pakistan
🔗 [LinkedIn](https://linkedin.com/in/hamzaaleem) | [GitHub](https://github.com/HamzaAleem)

---

## 📄 License
MIT License
