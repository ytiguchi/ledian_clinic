# ドキュメントインデックス

最終更新: 2024-12-26

## 🎯 スタートガイド

**初めての方へ**:
1. [起動・運用の入口](./START.md) - 迷ったらここ
2. [ロードマップ](./ROADMAP.md) - 現在の進捗と今後の計画
3. [タスク一覧](./tasks.md) - 具体的なタスク
4. [内部サイトの目的](./INTERNAL_SITE_PURPOSE.md) - 何を目指しているか

## 📊 ロードマップ・計画

- [ロードマップ](./ROADMAP.md) ⭐ **進捗状況と今後の計画**
- [タスク一覧](./tasks.md) - 具体的なタスクリスト
- [進捗状況](./internal-site-progress.md) - 詳細な進捗
- [公開サイト構築計画](./PUBLIC_SITE_PLAN.md) ⭐ **ledianclinic.jp 再構築計画**
- [包括的ロードマップ](./COMPREHENSIVE_ROADMAP.md) - 全体像とPhase別計画（参考）

## 🔌 API・連携（デザイナー向け）

- [デザイナー向けAPI仕様](./API_FOR_DESIGNER.md) ⭐ **デザイナーはここから**
- [システム統合ガイド](./DESIGNER_INTEGRATION.md) - デザイナー向け統合ガイド
- [API実装計画](./API_IMPLEMENTATION_PLAN.md) - API実装の方針

## ⚙️ 設定・環境

- [内部サイト設定](./INTERNAL_SITE_CONFIG.md) - 設定ファイルと環境構成
- [D1データベース設定](./D1_SINGLE_DB.md) - D1データベース設定
- [デプロイ手順](./DEPLOY_INTERNAL.md) - デプロイ方法

## 🗄️ データベース

- [D1マイグレーション](../database/d1/migrations/) - D1マイグレーションファイル
- [D1マイグレーション運用](../database/d1/README.md) - 現行スキーマ/運用メモ
- [D1スキーマ（正本）](../database/schema_d1_full.sql) - D1スキーマ定義
- [スキーマ拡張計画](./SCHEMA_EXTENSION_PLAN.md) - 今後の拡張計画

## 🐛 トラブルシューティング

- [APIデバッグ](./DEBUG_API.md) - API動作確認・デバッグ
- [トラブルシューティング](./TROUBLESHOOTING_CAMPAIGNS.md) - キャンペーン管理のトラブル

---

## 目的別ナビゲーション

### デザイナーの方
1. [システム統合ガイド](./DESIGNER_INTEGRATION.md)
2. [デザイナー向けAPI仕様](./API_FOR_DESIGNER.md)

### 開発者の方
1. [ロードマップ](./ROADMAP.md)
2. [進捗状況](./internal-site-progress.md)
3. [内部サイト設定](./INTERNAL_SITE_CONFIG.md)

### プロジェクトマネージャーの方
1. [内部サイトの目的](./INTERNAL_SITE_PURPOSE.md)
2. [ロードマップ](./ROADMAP.md)

---

## 最終的な出口（目標）

### 短期（進行中）
- ✅ 内部サイト基盤構築
- ✅ 料金管理機能
- ✅ 症例写真管理機能
- 🔄 **公開サイト再構築（ledianclinic.jp）** → [計画書](./PUBLIC_SITE_PLAN.md)

### 中期（6-12ヶ月）
- POSシステム連携
- カルテシステム連携

### 長期（12ヶ月以降）
- その他システム連携
- データ分析機能
