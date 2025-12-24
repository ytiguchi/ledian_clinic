globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../chunks/Layout_Dlq7WWaF.mjs';
/* empty css                                 */
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "data-astro-cid-245b2vpe": true }, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="campaigns-page" data-astro-cid-245b2vpe> <!-- Page Header --> <div class="page-header" data-astro-cid-245b2vpe> <div data-astro-cid-245b2vpe> <h1 class="page-title" data-astro-cid-245b2vpe>キャンペーン管理</h1> <p class="page-subtitle" data-astro-cid-245b2vpe>プロモーション・割引キャンペーンを管理します</p> </div> <a href="/campaigns/new" class="btn btn-primary" data-astro-cid-245b2vpe> <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" data-astro-cid-245b2vpe> <line x1="12" y1="5" x2="12" y2="19" data-astro-cid-245b2vpe></line> <line x1="5" y1="12" x2="19" y2="12" data-astro-cid-245b2vpe></line> </svg>
新規キャンペーン
</a> </div> <!-- Filter Bar --> <div class="filter-bar" data-astro-cid-245b2vpe> <div class="filter-grid" data-astro-cid-245b2vpe> <div class="filter-item" data-astro-cid-245b2vpe> <label class="label" data-astro-cid-245b2vpe>ステータス</label> <select class="select" id="publishedFilter" data-astro-cid-245b2vpe> <option value="" data-astro-cid-245b2vpe>すべて</option> <option value="published" data-astro-cid-245b2vpe>公開中のみ</option> <option value="unpublished" data-astro-cid-245b2vpe>非公開のみ</option> </select> </div> </div> </div> <!-- Campaign Table --> <div class="table-container" data-astro-cid-245b2vpe> <table class="table" data-astro-cid-245b2vpe> <thead data-astro-cid-245b2vpe> <tr data-astro-cid-245b2vpe> <th data-astro-cid-245b2vpe>キャンペーン名</th> <th data-astro-cid-245b2vpe>期間</th> <th class="text-center" data-astro-cid-245b2vpe>対象プラン数</th> <th class="text-center" data-astro-cid-245b2vpe>状態</th> <th class="text-center" data-astro-cid-245b2vpe>操作</th> </tr> </thead> <tbody id="campaignTableBody" data-astro-cid-245b2vpe> <tr data-astro-cid-245b2vpe> <td colspan="5" data-astro-cid-245b2vpe> <div class="loading" data-astro-cid-245b2vpe>読み込み中...</div> </td> </tr> </tbody> </table> </div> </div> ` })}  ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/index.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/index.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/index.astro";
const $$url = "/campaigns";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
