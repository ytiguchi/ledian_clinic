# 症例写真管理機能

## 概要

施術のBefore/After写真を管理する機能です。公開・非公開の切り替え、施術別のフィルタリングが可能です。

## 実装済み機能

### 1. 症例写真一覧ページ (`/before-afters`)

- **機能**:
  - 症例写真の一覧表示（グリッドレイアウト）
  - 施術別フィルター
  - 公開状態フィルター（公開中/非公開）
  - Before/After画像の並列表示
  - 編集・削除リンク

- **表示項目**:
  - 施術名
  - Before/After画像
  - 説明文
  - 患者情報（年齢・性別・施術回数・期間）
  - 公開状態

### 2. 症例写真作成ページ (`/before-afters/new`)

- **入力項目**:
  - 施術選択（カテゴリ→サブカテゴリ→施術の連動選択）
  - Before画像URL
  - After画像URL
  - 説明文
  - 患者年齢
  - 性別
  - 施術回数
  - 施術期間
  - 公開設定

- **機能**:
  - 画像URL入力時のプレビュー表示
  - バリデーション

### 3. 症例写真編集ページ (`/before-afters/[id]/edit`)

- **機能**:
  - 既存データの読み込み
  - 全項目の編集
  - 更新処理

### 4. API Routes

- `GET /api/before-afters` - 症例写真一覧（フィルター対応）
- `GET /api/before-afters/[id]` - 症例写真詳細
- `POST /api/before-afters` - 症例写真作成
- `PUT /api/before-afters/[id]` - 症例写真更新
- `DELETE /api/before-afters/[id]` - 症例写真削除

## データベーススキーマ

### treatment_before_afters テーブル

```sql
CREATE TABLE treatment_before_afters (
    id TEXT PRIMARY KEY,
    treatment_id TEXT NOT NULL,
    before_image_url VARCHAR(500) NOT NULL,
    after_image_url VARCHAR(500) NOT NULL,
    caption TEXT,
    patient_age INTEGER,
    patient_gender VARCHAR(10),
    treatment_count INTEGER,
    treatment_period VARCHAR(50),
    is_published INTEGER NOT NULL DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT (datetime('now'))
);
```

## マイグレーション

D1用のマイグレーションファイル:
- `database/d1/migrations/002_add_before_afters.sql`

適用方法:
```bash
wrangler d1 execute ledian-internal-prod --file=database/d1/migrations/002_add_before_afters.sql
```

## 今後の拡張予定

### 画像アップロード機能
- Cloudflare R2統合
- 画像アップロードAPI
- 画像リサイズ・最適化
- ドラッグ&ドロップ対応

### 機能改善
- 施術IDからカテゴリ・サブカテゴリの自動取得（編集ページ）
- 一括公開/非公開切り替え
- 並び替え機能（ドラッグ&ドロップ）
- 画像プレビューの拡大表示

## 使用方法

1. **症例写真の追加**
   - `/before-afters/new` にアクセス
   - 施術を選択
   - Before/After画像URLを入力
   - 詳細情報を入力
   - 公開設定を選択
   - 保存

2. **症例写真の編集**
   - 一覧ページから「編集」をクリック
   - 必要な項目を修正
   - 更新

3. **症例写真の削除**
   - 一覧ページから「削除」をクリック
   - 確認ダイアログで確認
   - 削除実行

4. **フィルタリング**
   - カテゴリ・施術・公開状態で絞り込み
   - 複数条件の組み合わせ可能

