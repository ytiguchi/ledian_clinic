# トレーニング機能 提案

## 目的

スタッフ（約30名）が新しい情報をまとめて確認できる機能を提供する。

## 必要な機能

### 1. 新着情報・お知らせ

- **用途**: 新しい施術メニューの追加、料金変更、キャンペーン開始などのお知らせ
- **機能**:
  - お知らせ一覧（日付順）
  - 重要度・優先度の設定
  - 既読/未読の管理
  - カテゴリ別フィルタリング

### 2. 施術マニュアル・資料

- **用途**: 各施術の手順、注意点、説明資料の閲覧
- **機能**:
  - 施術一覧からの詳細表示
  - 手順書・マニュアルの表示
  - 画像・動画の埋め込み
  - PDF資料の閲覧

### 3. FAQ・よくある質問

- **用途**: スタッフがよく聞かれる質問への回答
- **機能**:
  - カテゴリ別FAQ
  - 検索機能
  - よく見られるFAQの表示

### 4. 料金・メニュー確認

- **用途**: 最新の料金情報を素早く確認
- **機能**:
  - カテゴリ別料金表
  - 検索機能
  - キャンペーン情報の表示

### 5. 症例写真・ビフォーアフター

- **用途**: 施術効果の確認、顧客への説明資料
- **機能**:
  - 症例写真一覧
  - カテゴリ別フィルタリング
  - 拡大表示

## 実装案

### ページ構成

```
/training (トレーニングトップ)
├── /training/announcements (お知らせ)
├── /training/manuals (マニュアル・資料)
├── /training/faq (FAQ)
├── /training/pricing (料金確認)
└── /training/cases (症例写真)
```

### データ構造

#### announcements テーブル（新規作成）

```sql
CREATE TABLE announcements (
    id TEXT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    category VARCHAR(50),
    priority INTEGER DEFAULT 0,
    is_published INTEGER DEFAULT 0,
    published_at DATETIME,
    created_at DATETIME,
    updated_at DATETIME
);
```

#### faqs テーブル（新規作成）

```sql
CREATE TABLE faqs (
    id TEXT PRIMARY KEY,
    category_id TEXT,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    view_count INTEGER DEFAULT 0,
    sort_order INTEGER DEFAULT 0,
    is_published INTEGER DEFAULT 0,
    created_at DATETIME,
    updated_at DATETIME
);
```

#### training_manuals テーブル（新規作成）

```sql
CREATE TABLE training_manuals (
    id TEXT PRIMARY KEY,
    treatment_id TEXT REFERENCES treatments(id),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    file_url VARCHAR(500),
    video_url VARCHAR(500),
    sort_order INTEGER DEFAULT 0,
    is_published INTEGER DEFAULT 0,
    created_at DATETIME,
    updated_at DATETIME
);
```

## 優先実装項目

1. **お知らせ機能**（高優先度）
   - 新着情報の通知
   - 既読管理

2. **FAQ機能**（高優先度）
   - よくある質問の管理
   - 検索機能

3. **料金確認機能**（中優先度）
   - 既存の料金管理を活用
   - スタッフ向けビュー

4. **マニュアル機能**（中優先度）
   - 施術マニュアルの管理
   - 資料の閲覧

5. **症例写真**（低優先度）
   - 既存機能を活用
   - スタッフ向けビュー

