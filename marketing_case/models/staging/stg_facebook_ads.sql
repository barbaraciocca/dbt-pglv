select
    id,
    synced_timestamp,
    raw_payload->>'campaign_name'           as campaign_name,
    'facebook'                              as platform,
    (raw_payload->>'amount_spent')::numeric as cost,
    (raw_payload->>'spending_date')::date   as date,
    (raw_payload->>'impressions')::int      as impressions,
    (raw_payload->>'clicks')::int           as clicks
from public.raw_facebook_ads
