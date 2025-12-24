globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, k as renderComponent, l as renderScript, r as renderTemplate, m as maybeRenderHead } from '../../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../../chunks/Layout_Dlq7WWaF.mjs';
export { renderers } from '../../renderers.mjs';

const $$New = createComponent(async ($$result, $$props, $$slots) => {
  return renderTemplate`${renderComponent($$result, "Layout", $$Layout, {}, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="max-w-4xl mx-auto space-y-6"> <div> <a href="/before-afters" class="text-accent hover:underline">← 症例写真管理に戻る</a> <h2 class="text-3xl font-bold mt-4">新規症例写真追加</h2> </div> <form class="bg-white rounded-lg shadow p-6 space-y-6" id="beforeAfterForm"> <!-- 基本情報 --> <div> <h3 class="text-xl font-semibold mb-4">基本情報</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">カテゴリ</label> <select name="category" id="categorySelect" class="w-full px-4 py-2 border rounded-lg" required> <option value="">選択してください</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">サブカテゴリ</label> <select name="subcategory" id="subcategorySelect" class="w-full px-4 py-2 border rounded-lg"> <option value="">選択してください</option> </select> </div> <div class="md:col-span-2"> <label class="block text-sm font-medium mb-1">施術 <span class="text-red-500">*</span></label> <select name="treatment" id="treatmentSelect" class="w-full px-4 py-2 border rounded-lg" required> <option value="">選択してください</option> </select> </div> </div> </div> <!-- 画像アップロード --> <div> <h3 class="text-xl font-semibold mb-4">画像 <span class="text-red-500">*</span></h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-6"> <div> <label class="block text-sm font-medium mb-2">施術前画像URL</label> <input type="url" name="beforeImageUrl" id="beforeImageUrl" placeholder="https://example.com/before.jpg" class="w-full px-4 py-2 border rounded-lg" required> <div class="mt-2 aspect-square bg-gray-100 rounded overflow-hidden"> <img id="beforePreview" src="" alt="施術前プレビュー" class="w-full h-full object-cover hidden"> </div> </div> <div> <label class="block text-sm font-medium mb-2">施術後画像URL</label> <input type="url" name="afterImageUrl" id="afterImageUrl" placeholder="https://example.com/after.jpg" class="w-full px-4 py-2 border rounded-lg" required> <div class="mt-2 aspect-square bg-gray-100 rounded overflow-hidden"> <img id="afterPreview" src="" alt="施術後プレビュー" class="w-full h-full object-cover hidden"> </div> </div> </div> <p class="text-sm text-gray-500 mt-2">
※ 画像アップロード機能は今後実装予定です。現在は画像URLを入力してください。
</p> </div> <!-- 詳細情報 --> <div> <h3 class="text-xl font-semibold mb-4">詳細情報</h3> <div class="space-y-4"> <div> <label class="block text-sm font-medium mb-1">説明文</label> <textarea name="caption" id="caption" rows="3" placeholder="症例の説明を入力してください" class="w-full px-4 py-2 border rounded-lg"></textarea> </div> <div class="grid grid-cols-1 md:grid-cols-4 gap-4"> <div> <label class="block text-sm font-medium mb-1">患者年齢</label> <input type="number" name="patientAge" id="patientAge" min="0" max="150" class="w-full px-4 py-2 border rounded-lg"> </div> <div> <label class="block text-sm font-medium mb-1">性別</label> <select name="patientGender" id="patientGender" class="w-full px-4 py-2 border rounded-lg"> <option value="">選択してください</option> <option value="男性">男性</option> <option value="女性">女性</option> <option value="その他">その他</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">施術回数</label> <input type="number" name="treatmentCount" id="treatmentCount" min="1" class="w-full px-4 py-2 border rounded-lg"> </div> <div> <label class="block text-sm font-medium mb-1">施術期間</label> <input type="text" name="treatmentPeriod" id="treatmentPeriod" placeholder="例: 3ヶ月" class="w-full px-4 py-2 border rounded-lg"> </div> </div> </div> </div> <!-- 公開設定 --> <div> <h3 class="text-xl font-semibold mb-4">公開設定</h3> <div class="flex items-center gap-4"> <label class="flex items-center gap-2 cursor-pointer"> <input type="checkbox" name="isPublished" id="isPublished" class="w-4 h-4 text-accent border-gray-300 rounded"> <span>公開する</span> </label> </div> </div> <!-- アクション --> <div class="flex justify-end gap-4 pt-4 border-t"> <a href="/before-afters" class="px-6 py-2 border rounded-lg hover:bg-gray-50 transition">
キャンセル
</a> <button type="submit" class="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent-light transition">
保存
</button> </div> </form> </div> ` })} ${renderScript($$result, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/before-afters/new.astro?astro&type=script&index=0&lang.ts")}`;
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/before-afters/new.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/before-afters/new.astro";
const $$url = "/before-afters/new";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$New,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
