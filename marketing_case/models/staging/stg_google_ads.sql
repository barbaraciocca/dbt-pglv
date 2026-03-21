select
    id,
    synced_timestamp,
    raw_payload->>'campaign_name'        as campaign_name,
    'google'                             as platform,
    (raw_payload->>'cost')::numeric      as cost,
    (raw_payload->>'date')::date         as date,
    (raw_payload->>'impressions')::int   as impressions,
    (raw_payload->>'clicks')::int        as clicks
from public.raw_google_ads
