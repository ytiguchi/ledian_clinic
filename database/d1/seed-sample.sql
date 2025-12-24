-- サンプルデータ投入（D1用）
-- テスト用の最小限のデータ

-- カテゴリ
INSERT INTO categories (id, name, slug, sort_order, is_active) VALUES
  ('cat001', 'スキンケア', 'skincare', 10, 1),
  ('cat002', '医療脱毛', 'hair-removal', 20, 1),
  ('cat003', 'アートメイク', 'art-makeup', 30, 1);

-- サブカテゴリ
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  ('sub001', 'cat001', 'ハイフ', 'hifu', 10, 1),
  ('sub002', 'cat001', 'ポテンツァ', 'potenza', 20, 1),
  ('sub003', 'cat002', 'ワックス脱毛', 'wax', 10, 1);

-- 施術
INSERT INTO treatments (id, subcategory_id, name, slug, description, sort_order, is_active) VALUES
  ('treat001', 'sub001', 'ウルトラセルZi', 'ultracel-zi', '高密度集束超音波治療', 10, 1),
  ('treat002', 'sub002', 'ポテンツァ', 'potenza', 'RF(ラジオ波)治療', 10, 1),
  ('treat003', 'sub003', '全身ワックス脱毛', 'full-body-wax', '全身のワックス脱毛', 10, 1);

-- 料金プラン
INSERT INTO treatment_plans (
  id, treatment_id, plan_name, plan_type, sessions, price, price_taxed, 
  cost_rate, supply_cost, staff_cost, total_cost, sort_order, is_active
) VALUES
  ('plan001', 'treat001', '1回', 'single', 1, 50000, 55000, 15.0, 5000, 2000, 12500, 10, 1),
  ('plan002', 'treat001', '3回コース', 'course', 3, 135000, 148500, 15.0, 15000, 6000, 33750, 20, 1),
  ('plan003', 'treat002', '1回', 'single', 1, 30000, 33000, 20.0, 3000, 1500, 9000, 10, 1),
  ('plan004', 'treat003', '1回', 'single', 1, 20000, 22000, 25.0, 2000, 1000, 7000, 10, 1);

