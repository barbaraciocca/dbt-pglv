DROP TABLE IF EXISTS raw_facebook_ads;
DROP TABLE IF EXISTS raw_google_ads;
DROP TABLE IF EXISTS raw_tiktok_ads;

CREATE TABLE raw_facebook_ads (
  id SERIAL PRIMARY KEY,
  raw_payload JSONB,
  synced_timestamp TIMESTAMP DEFAULT NOW()
);

INSERT INTO raw_facebook_ads (raw_payload) VALUES
('{"campaign_name": "Black Friday FB", "amount_spent": 1500.00, "spending_date": "2024-11-01", "impressions": 50000, "clicks": 1200}'),
('{"campaign_name": "Natal FB", "amount_spent": 2200.50, "spending_date": "2024-12-10", "impressions": 80000, "clicks": 2100}');

CREATE TABLE raw_google_ads (
  id SERIAL PRIMARY KEY,
  raw_payload JSONB,
  synced_timestamp TIMESTAMP DEFAULT NOW()
);

INSERT INTO raw_google_ads (raw_payload) VALUES
('{"campaign_name": "Black Friday GG", "cost": 900.00, "date": "2024-11-01", "impressions": 30000, "clicks": 800}'),
('{"campaign_name": "Natal GG", "cost": 1800.75, "date": "2024-12-10", "impressions": 60000, "clicks": 1500}');

CREATE TABLE raw_tiktok_ads (
  id SERIAL PRIMARY KEY,
  raw_payload JSONB,
  synced_timestamp TIMESTAMP DEFAULT NOW()
);

INSERT INTO raw_tiktok_ads (raw_payload) VALUES
('{"campaign_name": "Black Friday TK", "spend": 600.00, "stat_date": "2024-11-01", "impressions": 20000, "clicks": 500}'),
('{"campaign_name": "Natal TK", "spend": 1100.00, "stat_date": "2024-12-10", "impressions": 45000, "clicks": 900}');
