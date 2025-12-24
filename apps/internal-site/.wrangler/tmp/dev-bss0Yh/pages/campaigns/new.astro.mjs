globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../../chunks/astro/server_DMabXZY_.mjs';
import { $ as $$Layout } from '../../chunks/Layout_Da37j1AH.mjs';
export { renderers } from '../../renderers.mjs';

const $$New = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, {}, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="max-w-4xl mx-auto space-y-6"> <div> <a href="/campaigns" class="text-accent hover:underline">← キャンペーン管理に戻る</a> <h2 class="text-3xl font-bold mt-4">新規キャンペーン作成</h2> </div> <form class="bg-white rounded-lg shadow p-6 space-y-6" id="campaignForm"> <!-- 基本情報 --> <div> <h3 class="text-xl font-semibold mb-4">基本情報</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">キャンペーン名 <span class="text-red-500">*</span></label> <input type="text" name="title" id="title" placeholder="例: 初回限定30%OFF" class="w-full px-4 py-2 border rounded-lg" required> </div> <div> <label class="block text-sm font-medium mb-1">スラッグ <span class="text-red-500">*</span></label> <input type="text" name="slug" id="slug" placeholder="例: first-time-30off" class="w-full px-4 py-2 border rounded-lg" required> <p class="text-xs text-gray-500 mt-1">URL用の識別子（英数字とハイフンのみ）</p> </div> <div class="md:col-span-2"> <label class="block text-sm font-medium mb-1">説明</label> <textarea name="description" id="description" rows="3" placeholder="キャンペーンの説明を入力してください" class="w-full px-4 py-2 border rounded-lg"></textarea> </div> <div> <label class="block text-sm font-medium mb-1">キャンペーン種別</label> <select name="campaignType" id="campaignType" class="w-full px-4 py-2 border rounded-lg"> <option value="discount">割引</option> <option value="bundle">セット</option> <option value="point">ポイント</option> <option value="referral">紹介</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">優先度</label> <input type="number" name="priority" id="priority" value="0" min="0" class="w-full px-4 py-2 border rounded-lg"> <p class="text-xs text-gray-500 mt-1">複数キャンペーン適用時、数値が大きいほど優先</p> </div> </div> </div> <!-- 期間設定 --> <div> <h3 class="text-xl font-semibold mb-4">期間設定</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">開始日</label> <input type="date" name="startDate" id="startDate" class="w-full px-4 py-2 border rounded-lg"> <p class="text-xs text-gray-500 mt-1">未設定の場合は無期限開始</p> </div> <div> <label class="block text-sm font-medium mb-1">終了日</label> <input type="date" name="endDate" id="endDate" class="w-full px-4 py-2 border rounded-lg"> <p class="text-xs text-gray-500 mt-1">未設定の場合は無期限</p> </div> </div> </div> <!-- 対象プラン --> <div> <h3 class="text-xl font-semibold mb-4">対象プラン</h3> <div class="border rounded-lg p-4 bg-gray-50"> <p class="text-sm text-gray-600 mb-4">
キャンペーン作成後、編集画面で対象プランを設定できます。
</p> <div id="selectedPlans" class="space-y-2"> <p class="text-sm text-gray-500">（プラン設定は編集画面で行います）</p> </div> </div> </div> <!-- 公開設定 --> <div> <h3 class="text-xl font-semibold mb-4">公開設定</h3> <div class="flex items-center gap-4"> <label class="flex items-center gap-2 cursor-pointer"> <input type="checkbox" name="isPublished" id="isPublished" class="w-4 h-4 text-accent border-gray-300 rounded"> <span>公開する</span> </label> </div> </div> <!-- アクション --> <div class="flex justify-end gap-4 pt-4 border-t"> <a href="/campaigns" class="px-6 py-2 border rounded-lg hover:bg-gray-50 transition">
キャンセル
</a> <button type="submit" class="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent-light transition">
作成
</button> </div> </form> </div> ` })} ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/new.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/new.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/new.astro";
const $$url = "/campaigns/new";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$New,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
