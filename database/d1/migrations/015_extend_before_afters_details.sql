-- Extend treatment_before_afters with public-site style detail fields
-- Note: Current schema (after 010) uses treatment_id, not subcategory_id

ALTER TABLE treatment_before_afters ADD COLUMN treatment_content TEXT;
ALTER TABLE treatment_before_afters ADD COLUMN treatment_duration VARCHAR(100);
ALTER TABLE treatment_before_afters ADD COLUMN treatment_cost INTEGER;
ALTER TABLE treatment_before_afters ADD COLUMN treatment_cost_text VARCHAR(100);
ALTER TABLE treatment_before_afters ADD COLUMN risks TEXT;
ALTER TABLE treatment_before_afters ADD COLUMN updated_at DATETIME NOT NULL DEFAULT (datetime('now'));


