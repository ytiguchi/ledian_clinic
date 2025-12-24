globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../chunks/Layout_Dlq7WWaF.mjs';
/* empty css                                 */
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "data-astro-cid-ym4a2o7m": true }, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="pricing-page" data-astro-cid-ym4a2o7m> <!-- Page Header --> <div class="page-header" data-astro-cid-ym4a2o7m> <div data-astro-cid-ym4a2o7m> <h1 class="page-title" data-astro-cid-ym4a2o7m>料金管理</h1> <p class="page-subtitle" data-astro-cid-ym4a2o7m>施術メニューの料金を管理します</p> </div> <a href="/pricing/new" class="btn btn-primary" data-astro-cid-ym4a2o7m> <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-ym4a2o7m> <line x1="12" y1="5" x2="12" y2="19" data-astro-cid-ym4a2o7m></line> <line x1="5" y1="12" x2="19" y2="12" data-astro-cid-ym4a2o7m></line> </svg>
新規プラン追加
</a> </div> <!-- Filter Bar --> <div class="filter-bar" data-astro-cid-ym4a2o7m> <div class="filter-grid" data-astro-cid-ym4a2o7m> <div class="filter-item filter-search" data-astro-cid-ym4a2o7m> <label class="label" data-astro-cid-ym4a2o7m>検索</label> <input type="text" placeholder="施術名・プラン名・カテゴリで検索..." class="input" id="searchInput" data-astro-cid-ym4a2o7m> </div> <div class="filter-item" data-astro-cid-ym4a2o7m> <label class="label" data-astro-cid-ym4a2o7m>カテゴリ</label> <select class="select" id="categoryFilter" data-astro-cid-ym4a2o7m> <option value="" data-astro-cid-ym4a2o7m>すべてのカテゴリ</option> </select> </div> <div class="filter-item" data-astro-cid-ym4a2o7m> <label class="label" data-astro-cid-ym4a2o7m>サブカテゴリ</label> <select class="select" id="subcategoryFilter" data-astro-cid-ym4a2o7m> <option value="" data-astro-cid-ym4a2o7m>すべてのサブカテゴリ</option> </select> </div> <div class="filter-item filter-actions" data-astro-cid-ym4a2o7m> <button class="btn btn-secondary" id="clearBtn" title="検索条件をクリア" data-astro-cid-ym4a2o7m> <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-ym4a2o7m> <line x1="18" y1="6" x2="6" y2="18" data-astro-cid-ym4a2o7m></line> <line x1="6" y1="6" x2="18" y2="18" data-astro-cid-ym4a2o7m></line> </svg>
クリア
</button> </div> </div> </div> <!-- Price Table --> <div class="table-container" data-astro-cid-ym4a2o7m> <table class="table" data-astro-cid-ym4a2o7m> <thead data-astro-cid-ym4a2o7m> <tr data-astro-cid-ym4a2o7m> <th data-astro-cid-ym4a2o7m>カテゴリ</th> <th data-astro-cid-ym4a2o7m>サブカテゴリ</th> <th data-astro-cid-ym4a2o7m>プラン名</th> <th data-astro-cid-ym4a2o7m>種別</th> <th class="text-center" data-astro-cid-ym4a2o7m>回数</th> <th class="text-right" data-astro-cid-ym4a2o7m>税抜価格</th> <th class="text-right" data-astro-cid-ym4a2o7m>税込価格</th> <th class="text-right" data-astro-cid-ym4a2o7m>原価率</th> <th class="text-right" data-astro-cid-ym4a2o7m>原価合計</th> <th class="text-center" data-astro-cid-ym4a2o7m>操作</th> </tr> </thead> <tbody id="priceTableBody" data-astro-cid-ym4a2o7m> <tr data-astro-cid-ym4a2o7m> <td colspan="10" data-astro-cid-ym4a2o7m> <div class="loading" data-astro-cid-ym4a2o7m>読み込み中...</div> </td> </tr> </tbody> </table> </div> </div> ` })}  ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/index.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/index.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/pricing/index.astro";
const $$url = "/pricing";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
