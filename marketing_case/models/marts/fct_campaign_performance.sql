with base as (
    select * from {{ ref('stg_facebook_ads') }}
    union all
    select * from {{ ref('stg_google_ads') }}
    union all
    select * from {{ ref('stg_tiktok_ads') }}
)
select
    row_number() over ()                    as performance_id,
    campaign_name,
    platform,
    date,
    cost,
    impressions,
    clicks,
    round(cost / nullif(clicks, 0), 4)     as cost_per_click,
    synced_timestamp
from base
