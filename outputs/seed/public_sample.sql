-- Public subset (website-only) from internal sample
-- Marker: notes = 'sample_from_website'

-- Ensure category/subcategory/treatment exist (public DB)
INSERT INTO categories (name, slug, sort_order, is_active)
VALUES ('リフトアップ・引き締め', 'liftup-tightening', 10, 1)
ON CONFLICT(slug) DO UPDATE SET
  name = excluded.name,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active,
  updated_at = datetime('now');

INSERT INTO subcategories (category_id, name, slug, sort_order, is_active)
VALUES (
  (SELECT id FROM categories WHERE slug = 'liftup-tightening'),
  'HIFU',
  'hifu',
  10,
  1
)
ON CONFLICT(category_id, slug) DO UPDATE SET
  name = excluded.name,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active,
  updated_at = datetime('now');

INSERT INTO treatments (subcategory_id, name, slug, description, sort_order, is_active)
VALUES (
  (SELECT id FROM subcategories WHERE slug = 'hifu' AND category_id = (SELECT id FROM categories WHERE slug = 'liftup-tightening')),
  'HIFU ウルトラセルZi',
  'ultracel-zi',
  'リフトアップ・引き締め向けのHIFUメニュー（サイト掲載分をサンプル化）',
  10,
  1
)
ON CONFLICT(subcategory_id, slug) DO UPDATE SET
  name = excluded.name,
  description = excluded.description,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active,
  updated_at = datetime('now');

-- Replace previous sample plans
DELETE FROM treatment_plans
WHERE treatment_id = (SELECT id FROM treatments WHERE slug = 'ultracel-zi')
  AND notes = 'sample_from_website';

INSERT INTO treatment_plans (
  treatment_id, plan_name, plan_type, sessions,
  price, price_taxed, sort_order, is_active, notes
)
VALUES
  ((SELECT id FROM treatments WHERE slug = 'ultracel-zi'), '200SHOT', 'single', 1, 20000, 22000, 10, 1, 'sample_from_website'),
  ((SELECT id FROM treatments WHERE slug = 'ultracel-zi'), '400SHOT', 'single', 1, 38000, 41800, 20, 1, 'sample_from_website'),
  ((SELECT id FROM treatments WHERE slug = 'ultracel-zi'), '600SHOT', 'single', 1, 54000, 59400, 30, 1, 'sample_from_website'),
  ((SELECT id FROM treatments WHERE slug = 'ultracel-zi'), '800SHOT', 'single', 1, 68000, 74800, 40, 1, 'sample_from_website'),
  ((SELECT id FROM treatments WHERE slug = 'ultracel-zi'), '1000SHOT', 'single', 1, 80000, 88000, 50, 1, 'sample_from_website');
