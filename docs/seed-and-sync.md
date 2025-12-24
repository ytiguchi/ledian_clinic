# シードと同期フロー（internal をマスターにし、public をマスク/抽出）

## 目的
- `data/` の正規化YAMLを internal D1 にシードし、公開用はマスク/抽出したデータだけを public D1 に同期する。
- internal は閲覧/編集/ナレッジ用のマスター。public はサービスページ用のサブセット。

## 前提
- D1 DB:
  - internal: `ledian-internal-prod`, `ledian-internal-stg`
  - public: `ledian-public-prod`, `ledian-public-stg`
- スキーマ: `database/d1/migrations/001_init.sql` 適用済み
- wrangler:
  - internal 用設定: `wrangler.internal.toml`
  - public 用設定: `wrangler.toml`

## 想定するスクリプト（今後作成）
- `scripts/seed_from_yaml.(ts|js)`: `data/catalog`, `data/pricing`, `data/content/*` を読み、INSERT/UPDATE SQL を生成し D1 に流す。
- `scripts/mask_for_public.(ts|js)`: internal のデータを SELECT → 公開可能フィールドだけを public 用 INSERT/UPDATE に変換。
- 上記を CI（GitHub Actions）から呼び出す。

## 運用フロー（案）
1) internal にシード  
   ```
   npx wrangler@4.56.0 d1 execute ledian-internal-stg --config wrangler.internal.toml --remote --file outputs/seed-internal.sql
   ```
   ※ `outputs/seed-internal.sql` は `scripts/seed_from_yaml` が生成。

2) 公開用に同期（マスク/抽出）  
   ```
   npx wrangler@4.56.0 d1 execute ledian-public-stg --config wrangler.toml --remote --file outputs/seed-public.sql
   ```
   ※ `outputs/seed-public.sql` は internal を参照して生成（マスク済み）。

3) 確認 → 問題なければ prod に昇格  
   - internal prod へ同じ seed を実行  
   - public prod へマスク済み seed を実行

## マスク/抽出ポリシー（例）
- 公開しないフィールド: 原価、スタッフコスト、内部ノート、社販ディスカウント率など。
- 公開するフィールド: 施術名、プラン名、税込/税抜価格、回数/個数、キャンペーン価格、表示用文言。
- 公開しないコンテンツ: 社内Bot回答、カウンセリング向け禁忌/同意文言など。

## 注意点
- D1 は ENUM/トリガーなし。`plan_type` の CHECK や `updated_at` はアプリ側で保証。
- Migrations は `wrangler d1 migrations apply <db> --config <file> --remote [--preview]` で適用。
- prod/stg を間違えないよう wranglerの `--config` と `--preview` を使い分ける。

## TODO
- `scripts/seed_from_yaml` と `scripts/mask_for_public` の実装・使い方を追記。
- 生成される SQL/JSON のファイル名・配置パスを決定（例: `outputs/seed/internal.sql` など）。
