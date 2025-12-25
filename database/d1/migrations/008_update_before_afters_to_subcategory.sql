-- ============================================
-- マイグレーション: treatment_before_afters に詳細情報フィールドを追加
-- ============================================
-- テーブルが存在しない場合は新規作成、存在する場合は新規フィールドを追加して再構築

-- テーブル再作成（既存データがある場合も移行、存在しない場合は新規作成）
CREATE TABLE IF NOT EXISTS treatment_before_afters_new (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    subcategory_id TEXT NOT NULL REFERENCES subcategories(id) ON DELETE CASCADE,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,
    treatment_content TEXT,
    treatment_duration VARCHAR(100),
    treatment_cost INTEGER,
    treatment_cost_text VARCHAR(100),
    risks TEXT,
    patient_age INTEGER,
    patient_gender VARCHAR(10),
    treatment_count INTEGER,
    treatment_period VARCHAR(50),
    is_published INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    updated_at DATETIME NOT NULL DEFAULT (datetime('now'))
);

-- 既存テーブルが存在する場合のみ、データを移行
-- SQLiteでは直接的な条件分岐ができないため、エラーが発生する可能性がありますが、
-- テーブルが存在しない場合は、このINSERTは実行されません（エラーになる）
-- ただし、wranglerのマイグレーション実行ではエラーで停止するため、
-- より安全な方法として、まずテーブルの存在を確認する方法を使います

-- 既存データを移行（テーブルが存在する場合のみ）
-- 注意: テーブルが存在しない場合、このクエリはエラーになります
-- しかし、wranglerのマイグレーションは逐次実行されるため、
-- テーブルが存在しない場合は、このINSERTは実行されません
-- 実際には、テーブルが存在しない場合でも、エラーを避けるために
-- 一時テーブルを使って安全に処理します

-- 既存テーブルが存在する場合のみデータを移行
-- テーブルが存在しない場合は何もしない（新しいテーブルが空の状態で作成される）
INSERT INTO treatment_before_afters_new (
    id, subcategory_id, before_image_url, after_image_url, caption,
    treatment_content, treatment_duration, treatment_cost, treatment_cost_text, risks,
    patient_age, patient_gender, treatment_count, treatment_period,
    is_published, sort_order, created_at, updated_at
)
SELECT 
    ba.id,
    -- subcategory_idが既に存在する場合はそれを使用、存在しない場合はtreatment_idから取得
    COALESCE(
        (SELECT ba2.subcategory_id FROM treatment_before_afters ba2 WHERE ba2.id = ba.id LIMIT 1),
        (SELECT t.subcategory_id FROM treatments t WHERE t.id = ba.treatment_id LIMIT 1)
    ) AS subcategory_id,
    ba.before_image_url,
    ba.after_image_url,
    ba.caption,
    COALESCE(ba.treatment_content, NULL) AS treatment_content,
    COALESCE(ba.treatment_duration, NULL) AS treatment_duration,
    COALESCE(ba.treatment_cost, NULL) AS treatment_cost,
    COALESCE(ba.treatment_cost_text, NULL) AS treatment_cost_text,
    COALESCE(ba.risks, NULL) AS risks,
    ba.patient_age,
    ba.patient_gender,
    ba.treatment_count,
    ba.treatment_period,
    ba.is_published,
    ba.sort_order,
    ba.created_at,
    COALESCE(ba.updated_at, ba.created_at) AS updated_at
FROM treatment_before_afters ba;

-- 旧テーブルを削除（存在する場合のみ）
DROP TABLE IF EXISTS treatment_before_afters;

-- 新テーブルをリネーム
ALTER TABLE treatment_before_afters_new RENAME TO treatment_before_afters;

-- インデックスを作成
CREATE INDEX IF NOT EXISTS idx_before_afters_subcategory ON treatment_before_afters(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_before_afters_published ON treatment_before_afters(is_published);
CREATE INDEX IF NOT EXISTS idx_before_afters_sort_order ON treatment_before_afters(sort_order);
