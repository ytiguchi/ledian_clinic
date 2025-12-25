-- ============================================
-- 発売予定商品サンプルデータ
-- ============================================

-- クマ取り（企画中）
INSERT INTO product_launches (
    name, description, target_subcategory_name,
    status, priority, target_launch_date, owner_name, notes
) VALUES (
    'クマ取り（経結膜脱脂）',
    '下まぶたの裏側から脂肪を除去し、クマ・たるみを改善する施術',
    'クマ取り',
    'planning',
    10,
    '2025-03-01',
    '院長',
    '需要高い。競合調査中'
);

-- 脂肪吸引注射（料金決定中）
INSERT INTO product_launches (
    name, description, target_subcategory_name,
    status, priority, target_launch_date, owner_name,
    planned_price, planned_price_taxed, price_notes
) VALUES (
    '脂肪吸引注射（BNLS等）',
    '注射で脂肪細胞を溶解・排出する施術。顔・ボディに対応',
    '脂肪溶解注射',
    'pricing',
    8,
    '2025-02-15',
    '院長',
    15000,
    16500,
    'BNLS neo、カベリン等の薬剤選定中'
);

-- お顔の脂肪吸引（プロトコル策定中）
INSERT INTO product_launches (
    name, description, target_subcategory_name,
    status, priority, target_launch_date, owner_name,
    planned_price, planned_price_taxed,
    pricing_completed_at, protocol_notes
) VALUES (
    'お顔の脂肪吸引',
    '頬・顎下などの脂肪を吸引し、フェイスラインを整える施術',
    'フェイスライン形成',
    'protocol',
    9,
    '2025-04-01',
    '院長',
    250000,
    275000,
    '2024-12-20',
    '術後ケア・ダウンタイム説明の標準化が必要'
);

-- AGA治療（研修中）
INSERT INTO product_launches (
    name, description, target_subcategory_name,
    status, priority, target_launch_date, owner_name,
    planned_price, planned_price_taxed,
    pricing_completed_at, protocol_completed_at, training_notes
) VALUES (
    'AGA治療（内服・外用）',
    'フィナステリド・ミノキシジル等による男性型脱毛症治療',
    'AGA治療',
    'training',
    7,
    '2025-01-15',
    '看護師長',
    8000,
    8800,
    '2024-12-10',
    '2024-12-18',
    '問診・処方フローの研修実施中'
);

-- タスク追加: クマ取り
INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'pricing', '料金設定・原価計算', '2025-01-10', '事務長', 1 FROM product_launches WHERE name LIKE 'クマ取り%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'protocol', '施術プロトコル作成', '2025-01-20', '院長', 2 FROM product_launches WHERE name LIKE 'クマ取り%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'training_material', '研修資料作成', '2025-02-01', '看護師長', 3 FROM product_launches WHERE name LIKE 'クマ取り%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'training_session', '研修実施', '2025-02-15', '看護師長', 4 FROM product_launches WHERE name LIKE 'クマ取り%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'web_register', 'WEBサイト登録', '2025-02-25', 'WEB担当', 5 FROM product_launches WHERE name LIKE 'クマ取り%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'smaregi_register', 'スマレジ商品登録', '2025-02-25', '事務', 6 FROM product_launches WHERE name LIKE 'クマ取り%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'medical_force_register', 'メディカルフォース登録', '2025-02-25', '事務', 7 FROM product_launches WHERE name LIKE 'クマ取り%';

-- タスク追加: AGA治療（一部完了）
INSERT INTO launch_tasks (launch_id, task_type, title, is_completed, completed_at, completed_by, sort_order)
SELECT id, 'pricing', '料金設定・原価計算', 1, '2024-12-10', '事務長', 1 FROM product_launches WHERE name LIKE 'AGA治療%';

INSERT INTO launch_tasks (launch_id, task_type, title, is_completed, completed_at, completed_by, sort_order)
SELECT id, 'protocol', '処方プロトコル作成', 1, '2024-12-18', '院長', 2 FROM product_launches WHERE name LIKE 'AGA治療%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'training_session', '問診・処方フロー研修', '2025-01-05', '看護師長', 3 FROM product_launches WHERE name LIKE 'AGA治療%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'web_register', 'WEBサイト登録', '2025-01-10', 'WEB担当', 4 FROM product_launches WHERE name LIKE 'AGA治療%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'smaregi_register', 'スマレジ商品登録', '2025-01-10', '事務', 5 FROM product_launches WHERE name LIKE 'AGA治療%';

INSERT INTO launch_tasks (launch_id, task_type, title, due_date, assignee, sort_order)
SELECT id, 'medical_force_register', 'メディカルフォース登録', '2025-01-10', '事務', 6 FROM product_launches WHERE name LIKE 'AGA治療%';

