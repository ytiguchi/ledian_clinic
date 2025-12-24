globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../chunks/astro/server_DMabXZY_.mjs';
import { $ as $$Layout } from '../chunks/Layout_Da37j1AH.mjs';
export { renderers } from '../renderers.mjs';

const $$Index = createComponent(($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, {}, { "default": ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="space-y-6"> <div class="flex justify-between items-center"> <h2 class="text-3xl font-bold">施術管理</h2> <a href="/treatments/new" class="bg-accent text-white px-4 py-2 rounded-lg hover:bg-accent-light transition">
+ 新規施術
</a> </div> <!-- Filter --> <div class="bg-white rounded-lg shadow p-6"> <div class="grid grid-cols-1 md:grid-cols-3 gap-4"> <select class="px-4 py-2 border rounded-lg" id="categoryFilter"> <option value="">すべてのカテゴリ</option> </select> <input type="text" placeholder="施術名で検索..." class="px-4 py-2 border rounded-lg" id="searchInput"> <button class="bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary-light transition">
検索
</button> </div> </div> <!-- Treatment Cards --> <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" id="treatmentGrid"> <div class="bg-white rounded-lg shadow p-6 text-center"> <p class="text-gray-500">データを読み込み中...</p> </div> </div> </div> ` })} ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/treatments/index.astro?astro&type=script&index=0&lang.ts")}`;
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
