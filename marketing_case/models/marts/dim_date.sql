with all_dates as (
    select date from {{ ref('stg_facebook_ads') }}
    union
    select date from {{ ref('stg_google_ads') }}
    union
    select date from {{ ref('stg_tiktok_ads') }}
)
select
    date                          as date_day,
    extract(year  from date)      as year,
    extract(month from date)      as month,
    extract(day   from date)      as day
from all_dates
