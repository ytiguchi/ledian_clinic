# Cloudflare (Pages + D1 + Access) 構成メモ

Lineworks 連携の社内向けサイトを Cloudflare だけで完結させる案。DB は D1(SQLite 互換) を使用し、`data/` で正規化した YAML をソースに同期する。

## アーキテクチャ
- **Auth**: Cloudflare Access + Lineworks IdP(SAML/OIDC)。Access を全エンドポイントに適用。
- **Web**: Cloudflare Pages（フロント SPA/SSG）+ Pages Functions（API）。
- **DB**: Cloudflare D1（料金・メニュー）。PostgreSQL 拡張/enum 非対応のため、スキーマは SQLite 互換に調整。
- **静的データ**: `data/` の YAML を CI で D1 にシード。Bot/カウンセリング向け JSON も同じ Functions から配信。
- **CDN/セキュリティ**: Cloudflare WAF/HTTPS/Cache。D1 への CRUD は Functions 経由のみ。

## スキーマ移行の注意（PostgreSQL → D1）
- `uuid_generate_v4()` → `TEXT` PK + アプリ側で UUID 生成。
- `ENUM plan_type` → `TEXT` + CHECK (`IN ('single','course','trial','monitor','campaign')`)。
- `DECIMAL` → `REAL` or `NUMERIC` 相当（SQLite）。コスト率などは `REAL` とする。
- トリガー/関数（updated_at 自動更新）は未サポート。アプリ/API で `updated_at` を明示更新。
- GIN/全文検索インデックスはなし。必要なら LIKE/FTS5 を検討（後続）。
- ビューは簡易 SELECT で代替（複雑になれば API レイヤーで組み立て）。

## データフロー
1. `data/`(YAML) をパーサーで `INSERT/UPDATE` 用 SQL か JSON に変換。
2. GitHub Actions から `wrangler d1 execute` でマイグレーション/シード（ステージ/本番別の D1 バインド）。
3. フロント/社内Bot/カウンセリング資料向け API は Pages Functions で提供（例: `/api/price-list`, `/api/treatments`）。Access 通過必須。
4. 生成物（PDF/CSV）が必要になったら Functions 内で生成し、署名付き URL か一時ストレージ(S3互換/R2)を利用。

## 実装ステップ
1) D1 環境作成: `wrangler d1 create ledian-clinic-prod` / `-stg`。`wrangler.toml` にバインド。
2) スキーマ移植: `database/schema.sql` を D1 互換に書き換えたマイグレーションを作成（enum→CHECK、uuid→TEXT、trigger削除）。`wrangler d1 migrations apply`。
3) シード: `scripts/seed_from_yaml.js(ts)` を用意し、`data/catalog/*.yml` / `data/pricing/*.yml` から D1 へ投入。CI で `wrangler d1 execute --file seed.sql` を実行。
4) API: Pages Functions で読み出しエンドポイントを作成し、Access を通過したリクエストのみ許可。ロール分けが必要なら Access の Group claim をヘッダで受けて振り分け。
5) フロント: Cloudflare Pages にデプロイ。認証は Access で事前バリア、フロントは API を直接叩くシンプル構成。

## Lineworks SSO（Access 側設定サマリ）
- Access でアプリ追加 → IdP として Lineworks の SAML/OIDC 設定を登録（エンドポイント/証明書/Client ID & Secret）。
- ユーザー/グループ単位で Access Policy を作成し、`*.ledianclinic.pages.dev` とカスタムドメインに適用。
- 動作確認はステージングドメインで先行。

## CI/CD イメージ（GitHub Actions）
```yaml
- uses: actions/checkout@v4
- uses: pnpm/action-setup@v4
- run: pnpm install
- run: pnpm build  # フロント/Functions
- run: pnpm run migrate:d1:stg   # wrangler d1 migrations apply
- run: pnpm run seed:d1:stg      # wrangler d1 execute --file seed.sql
- run: pnpm run deploy:stg       # wrangler pages deploy
```
本番は手動承認ステップを挟む。シークレット: `CLOUDFLARE_API_TOKEN`, `ACCOUNT_ID`, `D1_DB_NAME` など。

## 今後の拡張
- FTS5 で施術名/カテゴリ検索を入れるか、軽量な全文検索はクエリで代替。
- PDF/CSV エクスポートは Functions + R2 に一時保存し、署名付き URL を返す。
- Webhook で Lineworks Bot へ更新通知を送る場合、Access を通った内部 Functions から POST。

## D1 メモ（2025-12-24）
- DB (internal/master): `ledian-internal-prod`, `ledian-internal-stg`
- DB (public): `ledian-public-prod`, `ledian-public-stg`
- マイグレーション格納: `database/d1/migrations/001_init.sql`
- wrangler apply 例:
  - internal prod: `npx wrangler@4.56.0 d1 migrations apply ledian-internal-prod --config wrangler.internal.toml --remote`
  - internal stg: `... --preview`
  - public prod: `npx wrangler@4.56.0 d1 migrations apply ledian-public-prod --config wrangler.toml --remote`
  - public stg: `... --preview`
- シード/同期フロー: `docs/seed-and-sync.md` 参照（internalをマスター、publicはマスク/抽出）
