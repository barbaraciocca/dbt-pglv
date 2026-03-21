# dbt Marketing Case

Projeto dbt que unifica dados de custo de marketing do Facebook Ads, Google Ads e TikTok Ads a partir de tabelas brutas com payload em JSON.

## Arquitetura
```
Raw (PostgreSQL) → Staging → Marts (modelo estrela)
```

### Camadas

**Staging** — extrai campos do `raw_payload` (JSONB) e padroniza nomes de colunas entre plataformas.

**Marts** — modelo estrela composto por:
- `dim_campaign` — dimensão de campanhas com nome e plataforma
- `dim_date` — dimensão de datas com ano, mês e dia
- `fct_campaign_performance` — fato com custo, impressões, cliques e custo por clique

### Testes
24 testes automatizados cobrindo unicidade, not_null e valores aceitos.

## Como rodar
```bash
dbt run
dbt test
```# dbt-pglv
