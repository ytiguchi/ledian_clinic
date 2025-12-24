globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../chunks/Layout_Dlq7WWaF.mjs';
/* empty css                                 */
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "data-astro-cid-23f53c3h": true }, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="training-page" data-astro-cid-23f53c3h> <!-- Page Header --> <div class="page-header" data-astro-cid-23f53c3h> <div data-astro-cid-23f53c3h> <h1 class="page-title" data-astro-cid-23f53c3h>施術研修コンテンツ</h1> <p class="page-subtitle" data-astro-cid-23f53c3h>カテゴリ → 施術 → 詳細情報をドリルダウンで確認</p> </div> </div> <!-- Navigation Breadcrumb --> <nav class="nav-breadcrumb" id="navBreadcrumb" data-astro-cid-23f53c3h> <button class="breadcrumb-item active" data-level="category" data-astro-cid-23f53c3h> <span class="breadcrumb-icon" data-astro-cid-23f53c3h>🏠</span>
カテゴリ一覧
</button> </nav> <!-- Level 1: Category Grid --> <div class="content-level" id="categoryLevel" data-astro-cid-23f53c3h> <div class="category-grid" id="categoryGrid" data-astro-cid-23f53c3h> <div class="loading-state" data-astro-cid-23f53c3h>読み込み中...</div> </div> </div> <!-- Level 2: Subcategory & Treatment List --> <div class="content-level hidden" id="subcategoryLevel" data-astro-cid-23f53c3h> <div class="two-column-layout" data-astro-cid-23f53c3h> <aside class="sidebar-nav" id="subcategorySidebar" data-astro-cid-23f53c3h> <!-- Subcategory list will be rendered here --> </aside> <main class="treatment-list" id="treatmentList" data-astro-cid-23f53c3h> <!-- Treatment cards will be rendered here --> </main> </div> </div> <!-- Level 3: Treatment Detail --> <div class="content-level hidden" id="detailLevel" data-astro-cid-23f53c3h> <div class="detail-container" id="treatmentDetail" data-astro-cid-23f53c3h> <!-- Treatment detail will be rendered here --> </div> </div> </div> ` })}  ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/treatments/index.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/treatments/index.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/treatments/index.astro";
const $$url = "/treatments";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
