-- Production cleanup script
PRAGMA foreign_keys = OFF;

-- Drop all views
DROP VIEW IF EXISTS v_price_list;
DROP VIEW IF EXISTS v_campaign_prices;
DROP VIEW IF EXISTS v_treatments_full;

-- Drop all tables (old schema)
DROP TABLE IF EXISTS campaign_items;
DROP TABLE IF EXISTS campaign_plans;
DROP TABLE IF EXISTS training_records;
DROP TABLE IF EXISTS training_materials;
DROP TABLE IF EXISTS trainings;
DROP TABLE IF EXISTS protocols;
DROP TABLE IF EXISTS before_afters;
DROP TABLE IF EXISTS treatment_tags;
DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS treatment_before_afters;
DROP TABLE IF EXISTS treatment_option_mappings;
DROP TABLE IF EXISTS treatment_options;
DROP TABLE IF EXISTS treatment_plans;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS medication_plans;

-- Drop service content tables if they exist
DROP TABLE IF EXISTS service_before_afters;
DROP TABLE IF EXISTS service_faqs;
DROP TABLE IF EXISTS service_overviews;
DROP TABLE IF EXISTS service_recommendations;
DROP TABLE IF EXISTS service_features;
DROP TABLE IF EXISTS service_contents;

PRAGMA foreign_keys = ON;


