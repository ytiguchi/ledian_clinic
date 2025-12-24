# ディレクトリ構造と運用ルール

料金表・施術メニューの「正規化データ」と、各チャネル向けの出力素材を同じフォルダで一元管理します。キーとなる slug/ID を共有し、各アウトプットはこの共通キーを参照します。

## フォルダマップ
- `database/`: DBスキーマ（PostgreSQL/D1）。物理テーブルとビューの定義。
- `data/`（正規化ソース）
  - `catalog/`: 施術カテゴリ・サブカテゴリ・施術本体。
  - `pricing/`: 料金プラン・オプション・薬剤プラン。
  - `content/`
    - `web/`: 一般向けWeb用コピー（LP/FAQなど）。
    - `bot/`: 社内Bot/ナレッジ向け回答テンプレート。
    - `counseling/`: カウンセリング資料用説明・注意事項。
  - `shared/`: 共通文言・画像メタ情報・禁忌/同意事項など。
- `apps/`
  - `public-site/`: 一般向けWebサイト（Cloudflare Pages想定）。ビルド成果は`public-site`内の`dist`等へ。
  - `internal-site/`: Lineworks/Accessで保護する社内向けWeb。ビューは`data/`を参照。
- `scripts/`: 変換・バリデーション・エクスポート（DBシード、JSON生成、PDF/CSV等）。
- `outputs/`: 生成物（PDF/CSV/静的JSONなど）。gitignore予定。
- `docs/`: 運用ドキュメント、アーティファクトロードマップ、タスク管理。

## 命名・キーのルール
- `slug` は英小文字ケバブケースで一意にする（例: `skincare`, `ultracel-zi`）。
- 施術/薬剤/プランの YAML は `slug` をキーに、DB の UUID は必要になったら付与する。
- 価格は税抜/税込を必ず両方保持し、`plan_type` は `schema.sql` の ENUM に合わせる（`single|course|trial|monitor|campaign`）。

## データファイル例
```yaml
# data/catalog/categories.yml
- slug: skincare
  name: スキンケア
  sort_order: 10
  is_active: true

# data/catalog/treatments.yml
- slug: ultracel-zi
  subcategory_slug: hifu
  name: ウルトラセルZi
  description: リフトアップ向けHIFU
  sort_order: 10
```

```yaml
# data/pricing/treatment_plans.yml
- treatment_slug: ultracel-zi
  plan_name: 全顔
  plan_type: course
  sessions: 3
  price: 120000
  price_taxed: 132000
  price_per_session: 40000
  price_per_session_taxed: 44000
  campaign_price: 99000
  campaign_price_taxed: 108900
  notes: 初回限定キャンペーン
```

```yaml
# data/content/web/treatments.yml
- treatment_slug: ultracel-zi
  headline: 切らないリフトアップでフェイスラインを引き締め
  highlights:
    - 深さ別に3層へ熱エネルギーを届ける最新HIFU
    - ダウンタイムを抑えながら小顔・たるみケアを両立
  faq:
    - q: 施術時間はどのくらいですか？
      a: カウンセリング含め約60分です。施術自体は30〜40分程度です。
  caution: 施術当日は激しい運動・サウナはお控えください。
```

## 運用の考え方
- 正規化データ（catalog/pricing）は「真実のソース」。チャネル固有の文章は content 配下で管理し、キーで参照する。
- スクリプトで DB へのインポートや静的サイト/Googleスプレッドシート出力を行う想定。生成物は `outputs/`（gitignore）へ。
- 追加チャネルが増える場合は `data/content/<channel>/` を増やし、キーは共通 slug を使う。
- 一般向け/社内向けで表示を分ける場合、テンプレート/コンポーネントは `apps/public-site` と `apps/internal-site` に分けつつ、データソースは共通 `data/` を参照する。
