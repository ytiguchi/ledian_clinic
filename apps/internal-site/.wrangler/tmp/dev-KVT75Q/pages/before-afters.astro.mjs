globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../chunks/Layout_Dlq7WWaF.mjs';
/* empty css                                 */
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "data-astro-cid-u5hodu75": true }, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="before-afters-page" data-astro-cid-u5hodu75> <!-- Page Header --> <div class="page-header" data-astro-cid-u5hodu75> <div data-astro-cid-u5hodu75> <h1 class="page-title" data-astro-cid-u5hodu75>症例写真管理</h1> <p class="page-subtitle" data-astro-cid-u5hodu75>ビフォーアフター写真を管理します</p> </div> <a href="/before-afters/new" class="btn btn-primary" data-astro-cid-u5hodu75> <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-u5hodu75> <line x1="12" y1="5" x2="12" y2="19" data-astro-cid-u5hodu75></line> <line x1="5" y1="12" x2="19" y2="12" data-astro-cid-u5hodu75></line> </svg>
新規症例追加
</a> </div> <!-- Filter Bar --> <div class="filter-bar" data-astro-cid-u5hodu75> <div class="filter-grid" data-astro-cid-u5hodu75> <div class="filter-item" data-astro-cid-u5hodu75> <label class="label" data-astro-cid-u5hodu75>カテゴリ</label> <select class="select" id="categoryFilter" data-astro-cid-u5hodu75> <option value="" data-astro-cid-u5hodu75>すべてのカテゴリ</option> </select> </div> <div class="filter-item" data-astro-cid-u5hodu75> <label class="label" data-astro-cid-u5hodu75>施術</label> <select class="select" id="treatmentFilter" data-astro-cid-u5hodu75> <option value="" data-astro-cid-u5hodu75>すべての施術</option> </select> </div> <div class="filter-item" data-astro-cid-u5hodu75> <label class="label" data-astro-cid-u5hodu75>公開状態</label> <select class="select" id="publishedFilter" data-astro-cid-u5hodu75> <option value="" data-astro-cid-u5hodu75>すべて</option> <option value="published" data-astro-cid-u5hodu75>公開中のみ</option> <option value="unpublished" data-astro-cid-u5hodu75>非公開のみ</option> </select> </div> </div> </div> <!-- Before/After Grid --> <div class="gallery-grid" id="beforeAfterGrid" data-astro-cid-u5hodu75> <div class="loading-container" data-astro-cid-u5hodu75> <div class="loading" data-astro-cid-u5hodu75>読み込み中...</div> </div> </div> </div> ` })}  ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/before-afters/index.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/before-afters/index.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/before-afters/index.astro";
const $$url = "/before-afters";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
