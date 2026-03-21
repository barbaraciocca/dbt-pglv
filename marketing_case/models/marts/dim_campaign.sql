with all_campaigns as (
    select campaign_name, platform from {{ ref('stg_facebook_ads') }}
    union all
    select campaign_name, platform from {{ ref('stg_google_ads') }}
    union all
    select campaign_name, platform from {{ ref('stg_tiktok_ads') }}
)
select
    row_number() over ()  as campaign_id,
    campaign_name,
    platform
from all_campaigns
group by campaign_name, platform
