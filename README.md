# dbt Marketing Case

A dbt project that unifies marketing cost data from **Facebook Ads**, **Google Ads**, and **TikTok Ads** from raw tables with JSON payloads, simulating a Fivetran ingestion pipeline into a PostgreSQL Data Warehouse.

---

## Architecture
```
Raw (PostgreSQL)
      ↓
Staging (JSON extraction and standardization)
      ↓
Marts — Star Schema (fact + dimensions)
```

### Raw Layer
Raw tables ingested by Fivetran. Each platform uses different field names for the same concepts inside a `raw_payload` column in JSONB format.

| Platform | Cost field | Date field |
|---|---|---|
| Facebook Ads | `amount_spent` | `spending_date` |
| Google Ads | `cost` | `date` |
| TikTok Ads | `spend` | `stat_date` |

### Staging Layer
Extracts fields from the JSON payload, standardizes column names, and casts to the correct data types. One model per platform:
- `stg_facebook_ads`
- `stg_google_ads`
- `stg_tiktok_ads`

### Marts Layer — Star Schema
- `dim_campaign` — campaign dimension with name and source platform
- `dim_date` — date dimension with year, month, and day
- `fct_campaign_performance` — fact table with cost, impressions, clicks, and cost-per-click unified across all platforms

---

## Tests

24 automated tests covering:
- Uniqueness (`unique`)
- Required fields (`not_null`)
- Accepted values (`accepted_values`) for the `platform` column

---

## How to run

### Prerequisites
- Python 3.10+
- PostgreSQL 15
- dbt-postgres 1.10+

### Commands
```bash
make setup      # install dependencies
make db-start   # start PostgreSQL
make db-setup   # create raw tables with sample data
make run        # run all dbt models
make test       # run all 24 tests
make docs       # generate and serve documentation in the browser
make all        # run everything from scratch
```

---

## Project structure
```
dbt-pglv/
├── Makefile
├── README.md
├── scripts/
│   └── create_raw_tables.sql
└── marketing_case/
    ├── dbt_project.yml
    └── models/
        ├── staging/
        │   ├── schema.yml
        │   ├── stg_facebook_ads.sql
        │   ├── stg_google_ads.sql
        │   └── stg_tiktok_ads.sql
        └── marts/
            ├── schema.yml
            ├── dim_campaign.sql
            ├── dim_date.sql
            └── fct_campaign_performance.sql
```
