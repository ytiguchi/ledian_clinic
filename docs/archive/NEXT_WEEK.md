# 来週の作業（12/30〜）

最終更新: 2025-12-27

このページは **来週やること**を載せます。  
中長期の方向性は `docs/ROADMAP.md` を参照してください。

---

## 来週の優先ゴール

### 🔴 高優先度

- [ ] **service_contentsのsubcategory_id紐付け確認**
  - 他にもNULLのままのレコードがないかチェック
  - 必要に応じて一括更新SQLを作成

- [ ] **サービスコンテンツ新規作成フロー改善**
  - サブカテゴリ詳細ページから「コンテンツ新規作成」した場合に自動でsubcategory_idを設定
  - `/services/new?subcategory=xxx` パラメータ対応

### 🟡 中優先度

- [ ] 内部サイトでの「発売処理」運用フローを固める
  - 誰が/いつ/何を更新するかを明確化

- [ ] メニュー/料金/症例のデータ入力テンプレ（最低限）を決める

- [ ] D1マイグレーション運用を"迷わない手順"にまとめる
  - 実行コマンド、注意点、ロールバック方針

---

## 今週完了したこと（12/27）

- [x] ~~サブカテゴリ詳細ページにWEBコンテンツへのリンク追加~~
- [x] ~~ヘッダーに「WEBコンテンツ」/「WEBコンテンツ未作成」バッジ表示~~
- [x] ~~Eve V Museのsubcategory_id紐付け修正~~
- [x] ~~internal-site本番デプロイ~~

---

## 確認が必要な点

1. **他のservice_contentsレコードでsubcategory_idがNULLのものはあるか？**
   ```sql
   SELECT id, name_ja, slug, subcategory_id 
   FROM service_contents 
   WHERE subcategory_id IS NULL;
   ```

2. **サービスコンテンツの編集画面でsubcategory_idを選択/変更できるUIは必要か？**

3. **公開サイト本番切り替えのスケジュールは？**

---

## 参考リンク

- 管理サイト: https://ledian-clinic-internal.pages.dev/
- 公開サイト（ステージング）: https://develop.ledian-clinic-public.pages.dev/
