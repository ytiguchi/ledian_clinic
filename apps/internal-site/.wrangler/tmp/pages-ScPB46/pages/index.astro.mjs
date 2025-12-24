globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, f as createAstro, o as renderHead, r as renderTemplate } from '../chunks/astro/server_DMabXZY_.mjs';
/* empty css                                 */
export { renderers } from '../renderers.mjs';

const $$Astro = createAstro();
const $$Index = createComponent(($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro, $$props, $$slots);
  Astro2.self = $$Index;
  const title = "Ledian Internal (Draft)";
  return renderTemplate`<html lang="ja" data-astro-cid-j7pv25f6> <head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>${title}</title>${renderHead()}</head> <body data-astro-cid-j7pv25f6> <header data-astro-cid-j7pv25f6> <div class="tag" data-astro-cid-j7pv25f6>Internal Draft</div> <h1 data-astro-cid-j7pv25f6>Ledian Internal Portal (Draft)</h1> <p data-astro-cid-j7pv25f6>Access で保護する社内向けビューの仮トップ。データは D1 を参照する予定です。</p> </header> <main data-astro-cid-j7pv25f6> <section class="card" data-astro-cid-j7pv25f6> <h2 data-astro-cid-j7pv25f6>メニュー/料金プレビュー</h2> <p data-astro-cid-j7pv25f6>今後、D1 (internal) からカテゴリ/施術/料金を一覧表示する予定です。</p> </section> <section class="card" data-astro-cid-j7pv25f6> <h2 data-astro-cid-j7pv25f6>エクスポート</h2> <p data-astro-cid-j7pv25f6>CSV/PDF/JSON の出力をここにまとめ、Bot/カウンセリング向けの内容を確認できるようにします。</p> </section> <section class="card" data-astro-cid-j7pv25f6> <h2 data-astro-cid-j7pv25f6>ステータス</h2> <ul data-astro-cid-j7pv25f6> <li data-astro-cid-j7pv25f6>フレームワーク: Astro minimal</li> <li data-astro-cid-j7pv25f6>ビルド出力: dist → Cloudflare Pages (internal)</li> <li data-astro-cid-j7pv25f6>DB: D1 (internal prod/stg)</li> </ul> </section> </main> </body></html>`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/index.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/index.astro";
const $$url = "";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
