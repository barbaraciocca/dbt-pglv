select
    id,
    synced_timestamp,
    raw_payload->>'campaign_name'        as campaign_name,
    'tiktok'                             as platform,
    (raw_payload->>'spend')::numeric     as cost,
    (raw_payload->>'stat_date')::date    as date,
    (raw_payload->>'impressions')::int   as impressions,
    (raw_payload->>'clicks')::int        as clicks
from public.raw_tiktok_ads
