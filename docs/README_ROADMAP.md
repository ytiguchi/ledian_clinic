# 内部サイト ドキュメント一覧（整理中）

このページは互換のために残しています。入口は以下に集約します。

- 入口（ルート）: `README.md`
- 起動手順: `docs/START.md`
- 来週（運用タスク）: `docs/NEXT_WEEK.md`
- ロードマップ（いつか）: `docs/ROADMAP.md`
- 詳細目次: `docs/INDEX.md`

---

## 📋 概要・目的（参考）

- [内部サイトの目的](./INTERNAL_SITE_PURPOSE.md) - 内部サイトの目的と方針
- [包括的ロードマップ](./COMPREHENSIVE_ROADMAP.md) - 全体のロードマップとPhase別計画
- [データ正規化ロードマップ](./DATA_NORMALIZATION_ROADMAP.md) - データ拡張・正規化の詳細計画

## 🔧 技術ドキュメント

### 設定・環境

- [内部サイト設定](./INTERNAL_SITE_CONFIG.md) - 設定ファイルと環境構成
- [D1データベース設定](./D1_SINGLE_DB.md) - D1データベースの設定（プレビュー環境廃止）
- [デプロイ手順](./DEPLOY_INTERNAL.md) - デプロイ方法

### API・連携

- [デザイナー向けAPI仕様](./API_FOR_DESIGNER.md) - デザイナーが使用するAPI仕様
- [システム統合ガイド](./DESIGNER_INTEGRATION.md) - デザイナー向け統合ガイド
- [API実装計画](./API_IMPLEMENTATION_PLAN.md) - API実装の方針と計画

### データベース

- [PostgreSQLスキーマ](../database/schema.sql) - PostgreSQLスキーマ定義
- [D1スキーマ](../database/d1/migrations/) - D1マイグレーションファイル

## 🚀 運用

### 開発・デバッグ

- [トラブルシューティング](./TROUBLESHOOTING_CAMPAIGNS.md) - キャンペーン管理のトラブルシューティング
- [APIデバッグ](./DEBUG_API.md) - API動作確認・デバッグガイド

### マイグレーション

- [マイグレーション実行](../database/d1/migrate.sh) - D1マイグレーション実行スクリプト

## 📝 メモ・参考

- [APIルーティング修正](./_archive/API_ROUTING_FIX.md) - APIルーティング問題の修正履歴
- [FIXED_API_ERRORS](./_archive/FIXED_API_ERRORS.md) - APIエラー修正履歴

## クイックスタート

### 新規参加者向け

1. [内部サイトの目的](./INTERNAL_SITE_PURPOSE.md) を読んで目的を理解
2. [包括的ロードマップ](./COMPREHENSIVE_ROADMAP.md) で全体像を把握
3. [デザイナー向けAPI仕様](./API_FOR_DESIGNER.md) でAPI仕様を確認（デザイナーの場合）

### 開発者向け

1. [内部サイト設定](./INTERNAL_SITE_CONFIG.md) で環境構築
2. [デプロイ手順](./DEPLOY_INTERNAL.md) でデプロイ方法を確認
3. [データ正規化ロードマップ](./DATA_NORMALIZATION_ROADMAP.md) でデータ構造拡張計画を確認

### デザイナー向け

1. [システム統合ガイド](./DESIGNER_INTEGRATION.md) でシステム構成を理解
2. [デザイナー向けAPI仕様](./API_FOR_DESIGNER.md) でAPI仕様を確認
3. [PostgreSQLスキーマ](../database/schema.sql) でデータ構造を確認

## 最終的な出口（目標）

### 短期（3-6ヶ月）

- ✅ デザイナー向けAPI実装
- ✅ データエクスポート機能

### 中期（6-12ヶ月）

- POSシステム連携
- カルテシステム連携

### 長期（12ヶ月以降）

- その他システム連携
- データ分析機能

詳細は [包括的ロードマップ](./COMPREHENSIVE_ROADMAP.md) を参照してください。
