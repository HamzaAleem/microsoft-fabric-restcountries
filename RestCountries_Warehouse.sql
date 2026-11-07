-- ============================================================
-- Create T-SQL views over Gold Lakehouse Delta tables
-- This gives the Semantic Model a SQL endpoint to connect to
-- ============================================================

-- View: dim_countries
CREATE OR ALTER VIEW dim_countries AS
SELECT
    country_key,
    country_code_2,
    country_name,
    official_name,
    capital,
    region,
    subregion,
    continent,
    region_key,
    latitude,
    longitude,
    is_landlocked,
    is_un_member,
    primary_currency_code,
    language_count,
    border_count,
    flag_emoji
FROM Gold_lakehouse.dbo.dim_countries;
GO
-- View: dim_regions 
CREATE OR ALTER VIEW dbo.dim_regions AS
SELECT
    region_key,
    region,
    subregion
FROM Gold_Lakehouse.dbo.dim_regions;
GO

-- View: fact_country_metrics
CREATE or ALTER VIEW fact_country_languages AS
SELECT
    country_key,
    language_code,
    language_name
FROM gold_lakehouse.dbo.fact_country_languages;
GO

-- View: fact_country_currencies
CREATE OR ALTER VIEW fact_country_currencies AS
SELECT
    country_key,
    currency_code,
    currency_name,
    currency_symbol
FROM Gold_Lakehouse.dbo.fact_country_currencies;
GO
-- Verify star schema join works end to end
SELECT TOP 20
    dc.country_name,
    dc.region,
    dc.capital,
    dc.flag_emoji,
    fm.population,
    fm.area_km2,
    fm.population_density,
    fm.size_category
FROM fact_country_metrics fm
JOIN dim_countries dc ON fm.country_key=dc.country_key
JOIN dim_regions dr ON dc.region_key=dr.region_key
order by fm.population DESC
