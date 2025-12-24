# データベース マイグレーション手順

## 📋 セットアップ順序

### 1. 基本スキーマの適用

```bash
psql -d ledian_clinic -f database/schema.sql
```

### 2. コンテンツスキーマの適用

```bash
psql -d ledian_clinic -f database/schema_content.sql
```

### 3. キャンペーンIDマイグレーション（既存DBの場合）

既に`treatment_plans`テーブルが存在する場合：

```bash
psql -d ledian_clinic -f database/migration_add_campaign_id.sql
```

### 4. シードデータ投入

```bash
psql -d ledian_clinic -f database/seed.sql
```

---

## 🔄 既存データベースの場合

既存のデータベースに`campaign_id`カラムを追加する場合：

```sql
-- マイグレーション実行
psql -d ledian_clinic -f database/migration_add_campaign_id.sql
```

このマイグレーションは：
- `campaigns`テーブルが存在する場合のみ外部キー制約を追加
- 既にカラムが存在する場合はエラーにならないよう`IF NOT EXISTS`を使用

---

## 📝 注意事項

1. **外部キー制約**: `campaigns`テーブルは`schema_content.sql`で定義されます
2. **campaign_idの設定**: 既存データに`campaign_id`を設定する場合は手動でUPDATEが必要です
3. **NULL許容**: `campaign_id`はNULL可能で、キャンペーン価格がないプランはNULLのままです

---

## 🎯 campaign_idの設定例

キャンペーンが適用されているプランに`campaign_id`を設定：

```sql
-- 例: Holiday Campaign (IDを実際の値に置き換え)
UPDATE treatment_plans tp
SET campaign_id = (
    SELECT id FROM campaigns WHERE slug = 'holiday-2024'
)
WHERE tp.campaign_price IS NOT NULL
  AND tp.campaign_price < tp.price
  AND EXISTS (
      SELECT 1 FROM campaigns WHERE slug = 'holiday-2024'
  );
```



