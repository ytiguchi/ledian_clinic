# 起動・運用の入口（運用向け）

## 結論（迷ったらこれ）

内部サイトで **API（D1）込みで動かす**場合は、以下です。

```bash
cd apps/internal-site
npm run build
npm run dev:local
```

ブラウザ: `http://localhost:8788`

---

## 前提

- Node.js: **v20+ 推奨**
- `npm run dev` は **UI確認向け**（API Routes は基本動きません）

---

## 2つの開発モード

### 1) UI開発（API不要）

```bash
cd apps/internal-site
npm run dev
```

### 2) API動作確認（D1接続）

```bash
cd apps/internal-site
npm run build
npm run dev:local
```

---

## トラブルシューティング（最小）

- **APIが404**: buildできてるか、`dev:local` で起動してるか確認
- **データが出ない**: D1にデータが入っているか、`/api/categories` を叩いて確認

関連: `docs/DEBUG_API.md` / `database/d1/README.md`


