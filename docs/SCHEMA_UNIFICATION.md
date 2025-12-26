# スキーマ統一方針（D1）

このドキュメントは、公開サイト再構築に向けたD1スキーマの正本と統一ルールを定義する。

## 正本

- 正本スキーマ: `database/schema_d1_full.sql`
- 新規マイグレーションは `database/d1/migrations/` に追加

## 統一ルール

### 参照キー

- **施術系の参照は `treatment_id` に統一**
  - `treatment_plans`, `treatment_details`, `treatment_tags`, `treatment_flows`, `treatment_cautions`, `treatment_faqs`, `treatment_before_afters`
- `subcategory_id` は **施術のグルーピング** 用途に限定

### テーブル命名

- 症例: `treatment_before_afters` を正本
- 旧 `before_afters` は互換用途で段階的に廃止

### 主キー型

- 既存 `product_launches` 系は **INTEGERのまま**（運用中のため）
- その他は TEXT UUID（D1標準）で統一

### 公開フラグ

- 公開/非公開は `is_published` に統一
- 公開サイト側の基本条件: `is_published = 1`
- 対象テーブル（正本）:
  - `treatment_faqs`
  - `treatment_before_afters`
  - `counseling_materials`
  - `treatment_protocols`
  - `service_contents`
  - `campaigns`
  - `launch_before_afters`
  - `articles`
- APIの公開向けフィルタは `is_published=1|0|true|false` を受け付け、無効値はフィルタなし

## 記事コンテンツ（拡張スコープ）

追加テーブル（正本に反映済み）:
- `articles`
- `article_blocks`
- `article_tags`
- `article_tag_links`

## 既知の差分/課題

- `treatment_plans` の `subcategory_id` 依存コードが残っているため、API/画面の追従が必要
- `before_afters` 参照の互換を残しつつ段階移行が必要
- `treatment_faqs` の `subcategory_id` 参照は旧仕様のため、`treatments/[id]/faqs` へ統一が必要
- `counseling_materials`/`treatment_protocols` は subcategory_id ベースのため、treatment_id 寄せは要検討

## counseling_materials / treatment_protocols 方針

- 現状は `subcategory_id` を正本として維持（運用中のため影響を最小化）
- 公開向け/将来の統一は「代表施術(treatments)を1件ひも付ける」方式で段階対応
  - `subcategory_id` -> `treatments` の先頭（`ORDER BY sort_order, name`）を代表として扱う
  - 将来的に `treatment_id` を追加する場合は既存の `subcategory_id` を残し、移行期間を設ける

## 次のアクション

- `articles` 用マイグレーションを追加
- `treatment_plans` 参照の統一（API/画面側のクエリ更新）
- 旧 `before_afters` 依存の整理（必要ならビュー/移行スクリプト）
