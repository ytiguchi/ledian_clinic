# レディアンクリニック メニュー管理システム

美容クリニックの施術メニュー・料金管理システム

## 📁 プロジェクト構成

```
ledian_clinic/
├── database/
│   ├── schema.sql                  # 基本テーブル定義
│   ├── schema_content.sql          # コンテンツ管理テーブル
│   ├── seed.sql                    # シードデータ（自動生成）
│   ├── seed_data.json              # JSON形式のデータ（自動生成）
│   ├── migration_add_campaign_id.sql   # campaign_idカラム追加
│   ├── migration_set_campaign_ids.sql  # campaign_id設定用SQL
│   ├── setup_complete.sh           # セットアップスクリプト
│   └── README_MIGRATION.md         # マイグレーション詳細
├── data/
│   ├── content/
│   │   ├── campaigns.json          # キャンペーンデータ
│   │   ├── subscriptions.json      # サブスクリプションデータ
│   │   └── treatments/             # 施術詳細データ
│   └── shared/
│       └── tags.json               # タグマスター
├── scripts/
│   ├── parse_menu_csv.py           # CSV → 構造化データ変換
│   └── update_campaign_ids.py      # campaign_id更新用
├── public/
│   ├── index.html                  # 料金表（一覧）
│   ├── treatments.html             # 施術一覧ページ
│   └── treatment-detail.html       # 施術詳細ページ
├── src/types/
│   ├── menu.ts                     # メニュー型定義
│   └── content.ts                  # コンテンツ型定義
└── README.md
```

## 🚀 セットアップ

### 1. PostgreSQL データベース作成

```bash
createdb ledian_clinic
```

### 2. セットアップスクリプト実行（推奨）

```bash
./database/setup_complete.sh
```

### 3. 手動セットアップの場合

```bash
# スキーマ適用
psql -d ledian_clinic -f database/schema.sql
psql -d ledian_clinic -f database/schema_content.sql

# マイグレーション（既存DBの場合）
psql -d ledian_clinic -f database/migration_add_campaign_id.sql

# シードデータ投入
psql -d ledian_clinic -f database/seed.sql
```

## 🔄 CSVからデータを再生成

メニュー表CSVを更新した場合：

```bash
# Python スクリプト実行
python3 scripts/parse_menu_csv.py

# DBに再投入（既存データをクリアして再投入する場合）
psql -d ledian_clinic -c "TRUNCATE categories CASCADE;"
psql -d ledian_clinic -f database/seed.sql
```

## 📊 データ構造

### カテゴリ階層

```
Category（大カテゴリ）
  └── Subcategory（小カテゴリ）
        └── Treatment（施術）
              └── TreatmentPlan（料金プラン）
```

### 主要テーブル

| テーブル | 説明 |
|---------|------|
| `categories` | 大カテゴリ（スキンケア、医療脱毛等） |
| `subcategories` | 小カテゴリ（ハイフ、ポテンツァ等） |
| `treatments` | 施術（ウルトラセルZi等） |
| `treatment_plans` | 料金プラン（回数、価格、キャンペーン価格） |
| `treatment_details` | 施術詳細情報（説明、スペック等） |
| `campaigns` | キャンペーン情報 |
| `tags` | タグ（お悩み・効果・部位） |
| `treatment_options` | オプション（麻酔等） |
| `medications` | 薬剤マスター |
| `medication_plans` | 薬剤料金 |

### プラン種別（plan_type）

| 値 | 説明 |
|---|------|
| `single` | 単発 |
| `course` | 回数コース |
| `trial` | 初回お試し |
| `monitor` | モニター価格 |
| `campaign` | キャンペーン |

## 🔍 クエリ例

### 全メニュー一覧

```sql
SELECT * FROM v_price_list;
```

### キャンペーン中の施術

```sql
SELECT 
    c.title AS campaign_title,
    t.name AS treatment,
    tp.plan_name,
    tp.price_taxed AS 通常価格,
    tp.campaign_price_taxed AS キャンペーン価格
FROM treatment_plans tp
JOIN treatments t ON tp.treatment_id = t.id
LEFT JOIN campaigns c ON tp.campaign_id = c.id
WHERE tp.campaign_price IS NOT NULL
ORDER BY c.title, tp.campaign_price_taxed;
```

### カテゴリ別施術数

```sql
SELECT 
    c.name AS category,
    COUNT(DISTINCT t.id) AS treatment_count,
    COUNT(tp.id) AS plan_count
FROM categories c
LEFT JOIN subcategories sc ON c.id = sc.category_id
LEFT JOIN treatments t ON sc.id = t.subcategory_id
LEFT JOIN treatment_plans tp ON t.id = tp.treatment_id
GROUP BY c.id, c.name
ORDER BY c.sort_order;
```

### 価格帯検索

```sql
SELECT 
    t.name AS treatment,
    tp.plan_name,
    tp.price_taxed
FROM treatments t
JOIN treatment_plans tp ON t.id = tp.treatment_id
WHERE tp.price_taxed BETWEEN 10000 AND 50000
ORDER BY tp.price_taxed;
```

## 🌐 Webページ

### ローカルサーバー起動

```bash
cd /Users/iguchiyuuta/Dev/ledian_clinic
python3 -m http.server 8080
```

### アクセスURL

- **料金表**: http://localhost:8080/public/index.html
- **施術一覧**: http://localhost:8080/public/treatments.html
- **施術詳細**: http://localhost:8080/public/treatment-detail.html

## 🎨 機能

### 料金表（index.html）

- ✅ カテゴリ別表示
- ✅ 検索機能
- ✅ フィルタータブ
- ✅ **税抜き価格 (税込価格)** 表示
- ✅ キャンペーン価格表示（キャンペーン名付き）
- ✅ 原価・粗利表示（トグルON）
- ✅ 社販OFF価格表示（トグルON）
- ✅ 詳細テーブル表示（トグルON）

### 施術一覧（treatments.html）

- ✅ カテゴリ別一覧
- ✅ お悩みから探す
- ✅ 検索機能
- ✅ 人気ランキング表示

## 🛠️ TypeScript 使用例

```typescript
import type { 
    Category, 
    TreatmentWithPlans, 
    PriceListItem,
    Campaign
} from './src/types';

// 型安全なデータ操作
const fetchMenu = async (): Promise<Category[]> => {
    const response = await fetch('/api/menu');
    return response.json();
};
```

## 📝 キャンペーン設定

キャンペーン価格が設定されているプランに`campaign_id`を設定：

```sql
-- campaignsテーブルにデータ投入後
psql -d ledian_clinic -f database/migration_set_campaign_ids.sql
```

詳細は `database/README_MIGRATION.md` を参照してください。

## 📝 ライセンス

Private - レディアンクリニック
