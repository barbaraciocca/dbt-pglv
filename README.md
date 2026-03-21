# dbt Marketing Case

Projeto dbt que unifica dados de custo de marketing do **Facebook Ads**, **Google Ads** e **TikTok Ads** a partir de tabelas brutas com payload em JSON, simulando uma ingestão via Fivetran em um Data Warehouse PostgreSQL.

---

## Arquitetura
```
Raw (PostgreSQL)
      ↓
Staging (extração e padronização do JSON)
      ↓
Marts — Modelo Estrela (fct + dims)
```

### Camada Raw
Tabelas brutas ingeridas pelo Fivetran. Cada plataforma usa nomes diferentes para os mesmos campos dentro de uma coluna `raw_payload` em formato JSONB.

| Plataforma | Campo de custo | Campo de data |
|---|---|---|
| Facebook Ads | `amount_spent` | `spending_date` |
| Google Ads | `cost` | `date` |
| TikTok Ads | `spend` | `stat_date` |

### Camada Staging
Extrai os campos do JSON, padroniza os nomes das colunas e define os tipos corretos. Um modelo por plataforma:
- `stg_facebook_ads`
- `stg_google_ads`
- `stg_tiktok_ads`

### Camada Marts — Modelo Estrela
- `dim_campaign` — dimensão de campanhas com nome e plataforma
- `dim_date` — dimensão de datas com ano, mês e dia separados
- `fct_campaign_performance` — fato com custo, impressões, cliques e custo por clique unificando todas as plataformas

---

## Testes

24 testes automatizados cobrindo:
- Unicidade (`unique`)
- Campos obrigatórios (`not_null`)
- Valores aceitos (`accepted_values`) para a coluna `platform`

---

## Como rodar

### Pré-requisitos
- Python 3.10+
- PostgreSQL 15
- dbt-postgres 1.10+

### Comandos
```bash
make setup      # instala dependências
make db-start   # inicia o PostgreSQL
make db-setup   # cria as tabelas raw com dados de exemplo
make run        # roda todos os modelos dbt
make test       # roda os 24 testes
make docs       # gera e abre a documentação no browser
make all        # roda tudo do zero
```

---

## Estrutura do projeto
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
