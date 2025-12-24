# data/ ディレクトリ運用

正規化されたソースデータを YAML で管理し、各チャネルのコピーは slug で参照します。基本的に UTF-8 / YAML、インデント2スペースで統一します。

## ファイル一覧（想定）
- `catalog/categories.yml`：大カテゴリ。`slug`, `name`, `sort_order`, `is_active`
- `catalog/subcategories.yml`：小カテゴリ。`slug`, `category_slug`, `name`, `sort_order`, `is_active`
- `catalog/treatments.yml`：施術本体。`slug`, `subcategory_slug`, `name`, `description`, `sort_order`, `is_active`
- `pricing/treatment_plans.yml`：施術プラン。`treatment_slug`, `plan_name`, `plan_type`, `sessions`, `quantity`, `price`, `price_taxed`, `price_per_session`, `campaign_price(_taxed)`, `notes`
- `pricing/options.yml`：オプション（麻酔など）。`slug`, `name`, `description`, `price`, `price_taxed`, `is_global`, `sort_order`, `is_active`
- `pricing/medications.yml`：薬剤マスタ。`slug`, `name`, `unit`, `description`, `is_active`
- `pricing/medication_plans.yml`：薬剤プラン。`medication_slug`, `quantity`, `sessions`, `price`, `price_taxed`, `campaign_price`, `cost_rate`, `sort_order`, `is_active`
- `content/web/`：Web 用コピー・FAQ。`treatment_slug` をキーにテキストを管理。
- `content/bot/`：Q&A テンプレート。`intent`, `utterance`, `answer`, `references` などで構成。
- `content/counseling/`：カウンセリング資料用テキスト。`treatment_slug`, `indications`, `contraindications`, `aftercare` など。
- `shared/`：共通文言、注意事項、画像メタ情報。

## 追加の書き方ルール
- 金額は整数（円）で保持し、税込/税抜を両方記録する。
- `plan_type` は `single|course|trial|monitor|campaign` のみ使用。
- Boolean は `true/false` を明示。未定項目は `null` で埋めて後から更新。
- 並び順が必要な箇所は `sort_order`（整数）で管理。

## 作業フローの例
1. 施術を追加する場合は `catalog/` にカテゴリ → サブカテゴリ → 施術の順で slug を登録。
2. 続けて `pricing/` にプラン情報を追加し、税込/税抜・キャンペーン価格を揃える。
3. 各チャネルのコピーを `content/` に追加。語調や長さはチャネルに合わせて書き分け、キーは共通の `treatment_slug` を使う。
4. スクリプトやビュー（例: `v_price_list`）に流して動作確認し、問題があれば正規化データを修正する。
