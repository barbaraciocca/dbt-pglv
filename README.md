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

## Getting Started

### Prerequisites
- Python 3.9+
- Git
- Homebrew (Mac only) — install at brew.sh

Everything else (PostgreSQL, dbt) is installed automatically by the Makefile.

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/barbaraciocca/dbt-pglv.git
cd dbt-pglv
```

**2. Configure your credentials**

The first time you run `make all`, the Makefile will automatically create a `.env` file and ask you to fill in your credentials:
```bash
nano .env
```

| Variable | Mac | Linux |
|---|---|---|
| `DBT_HOST` | `localhost` | `localhost` |
| `DBT_PORT` | `5432` | `5432` |
| `DBT_USER` | your system username (`whoami`) | `postgres` |
| `DBT_PASSWORD` | any password of your choice | any password of your choice |
| `DBT_DATABASE` | `postgres` | `postgres` |
| `DBT_SCHEMA` | `public` | `public` |

**3. Run everything**
```bash
make all
```

This single command will install dbt, start PostgreSQL, create the raw tables with sample data, run all dbt models, and run all 24 tests.

---

## Available commands
```bash
make setup      # install dbt and configure credentials
make db-start   # start PostgreSQL
make db-setup   # create raw tables with sample data
make run        # run all dbt models
make test       # run all 24 tests
make docs       # generate and serve documentation in the browser
make clean      # remove generated files
make all        # run everything from scratch
```

---

## Project structure
```
dbt-pglv/
├── .env.example               ← credentials template
├── Makefile                   ← automation commands
├── README.md
├── scripts/
│   └── create_raw_tables.sql  ← sample raw data
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

---

> **Note:** Sample data is used to simulate Fivetran ingestion. In a real scenario, these raw tables would be populated automatically by Fivetran.