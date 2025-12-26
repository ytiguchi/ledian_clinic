# AI向けメモ（前提・用語）

## このリポジトリの目的（要約）

- 施術メニュー/料金/症例などを一元管理する
- 内部サイト（`apps/internal-site`）で運用し、必要に応じて公開サイトや外部へ出す

## 重要な前提

- DBは Cloudflare D1（SQLite互換）を前提にしている箇所がある
- `docs/START.md` が起動の入口
- 仕様・計画は散らばりやすいので、入口はルート `README.md` に集約する

## 主要用語

- **Category / Subcategory / Treatment / Plan**: メニュー階層
- **before-after（症例）**: `treatment_before_afters` などで管理
- **発売処理（launches）**: 新商品の発売パイプライン（内部サイトでの運用）


