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

## 記事コンテンツ（拡張スコープ）

追加テーブル（正本に反映済み）:
- `articles`
- `article_blocks`
- `article_tags`
- `article_tag_links`

## 既知の差分/課題

- `treatment_plans` の `subcategory_id` 依存コードが残っているため、API/画面の追従が必要
- `before_afters` 参照の互換を残しつつ段階移行が必要

## 次のアクション

- `articles` 用マイグレーションを追加
- `treatment_plans` 参照の統一（API/画面側のクエリ更新）
- 旧 `before_afters` 依存の整理（必要ならビュー/移行スクリプト）
