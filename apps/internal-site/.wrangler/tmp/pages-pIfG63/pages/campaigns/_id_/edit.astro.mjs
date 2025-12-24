globalThis.process ??= {}; globalThis.process.env ??= {};
import { e as createComponent, f as createAstro, r as renderTemplate, n as defineScriptVars, k as renderComponent, m as maybeRenderHead } from '../../../chunks/astro/server_BRXg5whf.mjs';
import { $ as $$Layout } from '../../../chunks/Layout_Dlq7WWaF.mjs';
export { renderers } from '../../../renderers.mjs';

var __freeze = Object.freeze;
var __defProp = Object.defineProperty;
var __template = (cooked, raw) => __freeze(__defProp(cooked, "raw", { value: __freeze(raw || cooked.slice()) }));
var _a;
const $$Astro = createAstro();
const prerender = false;
const $$Edit = createComponent(async ($$result, $$props, $$slots) => {
  const Astro2 = $$result.createAstro($$Astro, $$props, $$slots);
  Astro2.self = $$Edit;
  const id = Astro2.params.id;
  return renderTemplate(_a || (_a = __template(["", " <script>(function(){", `
  interface CampaignData {
    id: string;
    title: string;
    slug: string;
    description: string | null;
    start_date: string | null;
    end_date: string | null;
    campaign_type: string;
    priority: number;
    is_published: number;
  }

  interface Plan {
    id?: string;
    treatment_plan_id: string;
    discount_type: string;
    discount_value: number | null;
    special_price: number | null;
    special_price_taxed: number | null;
  }

  let campaign: CampaignData | null = null;
  let plans: Plan[] = [];
  let allTreatmentPlans: Array<{ 
    id: string; 
    plan_name: string; 
    treatment_name: string; 
    treatment_id: string;
    category_name: string;
    subcategory_name: string;
    price: number;
    price_taxed: number;
  }> = [];

  async function loadData() {
    try {
      // \u30AD\u30E3\u30F3\u30DA\u30FC\u30F3\u30C7\u30FC\u30BF\u53D6\u5F97
      const res = await fetch(\`/api/campaigns/\${campaignId}\`);
      if (!res.ok) {
        throw new Error('\u30AD\u30E3\u30F3\u30DA\u30FC\u30F3\u304C\u898B\u3064\u304B\u308A\u307E\u305B\u3093');
      }
      const data = await res.json();
      campaign = data.campaign as CampaignData;
      plans = data.plans || [];

      // \u30D7\u30E9\u30F3\u4E00\u89A7\u53D6\u5F97\uFF08\u5BFE\u8C61\u30D7\u30E9\u30F3\u9078\u629E\u7528\uFF09
      await loadTreatmentPlans();

      // \u30D5\u30A9\u30FC\u30E0\u306B\u5024\u3092\u8A2D\u5B9A
      populateForm(campaign);

      // \u30D5\u30A9\u30FC\u30E0\u3092\u8868\u793A
      document.getElementById('loadingMessage')?.classList.add('hidden');
      const form = document.getElementById('campaignForm');
      if (form) {
        form.classList.remove('hidden');
      }

      // \u30D7\u30E9\u30F3\u30EA\u30B9\u30C8\u3092\u8868\u793A
      renderPlanList();
    } catch (error) {
      console.error('\u30C7\u30FC\u30BF\u8AAD\u307F\u8FBC\u307F\u30A8\u30E9\u30FC:', error);
      const loadingMsg = document.getElementById('loadingMessage');
      if (loadingMsg) {
        loadingMsg.innerHTML = \`<p class="text-red-500">\u30C7\u30FC\u30BF\u306E\u8AAD\u307F\u8FBC\u307F\u306B\u5931\u6557\u3057\u307E\u3057\u305F: \${error instanceof Error ? error.message : 'Unknown error'}</p>\`;
      }
    }
  }

  async function loadTreatmentPlans() {
    try {
      const res = await fetch('/api/pricing');
      const data = await res.json();
      allTreatmentPlans = (data.plans || []).map((p: any) => ({
        id: p.id,
        plan_name: p.plan_name,
        treatment_name: p.treatment_name,
        treatment_id: p.treatment_id,
        category_name: p.category_name,
        subcategory_name: p.subcategory_name,
        price: p.price,
        price_taxed: p.price_taxed
      }));
      renderAvailablePlans();
    } catch (error) {
      console.error('\u30D7\u30E9\u30F3\u4E00\u89A7\u8AAD\u307F\u8FBC\u307F\u30A8\u30E9\u30FC:', error);
    }
  }

  function togglePlanSelector() {
    const modal = document.getElementById('planSelectorModal');
    if (modal) {
      modal.classList.toggle('hidden');
      if (!modal.classList.contains('hidden')) {
        renderAvailablePlans();
      }
    }
  }

  function filterPlans() {
    renderAvailablePlans();
  }

  function renderAvailablePlans() {
    const container = document.getElementById('availablePlans');
    if (!container) return;

    const searchTerm = (document.getElementById('planSearchInput') as HTMLInputElement)?.value.toLowerCase() || '';
    const selectedPlanIds = plans.map(p => p.treatment_plan_id);
    
    // \u30AB\u30C6\u30B4\u30EA\u30FB\u30B5\u30D6\u30AB\u30C6\u30B4\u30EA\u3067\u30B0\u30EB\u30FC\u30D7\u5316
    const grouped: Record<string, Record<string, typeof allTreatmentPlans>> = {};
    allTreatmentPlans
      .filter(plan => {
        const matchesSearch = !searchTerm || 
          plan.treatment_name.toLowerCase().includes(searchTerm) ||
          plan.plan_name.toLowerCase().includes(searchTerm) ||
          plan.category_name.toLowerCase().includes(searchTerm) ||
          plan.subcategory_name.toLowerCase().includes(searchTerm);
        return matchesSearch && !selectedPlanIds.includes(plan.id);
      })
      .forEach(plan => {
        if (!grouped[plan.category_name]) {
          grouped[plan.category_name] = {};
        }
        if (!grouped[plan.category_name][plan.subcategory_name]) {
          grouped[plan.category_name][plan.subcategory_name] = [];
        }
        grouped[plan.category_name][plan.subcategory_name].push(plan);
      });

    if (Object.keys(grouped).length === 0) {
      container.innerHTML = '<p class="text-gray-500 text-center py-8">\u8A72\u5F53\u3059\u308B\u30D7\u30E9\u30F3\u304C\u898B\u3064\u304B\u308A\u307E\u305B\u3093</p>';
      return;
    }

    container.innerHTML = Object.entries(grouped).map(([categoryName, subcategories]) => \`
      <div class="mb-6">
        <h5 class="font-semibold text-lg mb-3 text-gray-700 border-b pb-2">\${escapeHtml(categoryName)}</h5>
        \${Object.entries(subcategories).map(([subcategoryName, plans]) => \`
          <div class="ml-4 mb-4">
            <h6 class="font-medium text-sm text-gray-600 mb-2">\${escapeHtml(subcategoryName)}</h6>
            <div class="space-y-1">
              \${plans.map(plan => \`
                <label class="flex items-center p-3 border rounded-lg hover:bg-gray-50 cursor-pointer transition">
                  <input
                    type="checkbox"
                    class="mr-3 w-4 h-4 text-accent"
                    value="\${plan.id}"
                    onchange="handlePlanSelection('\${plan.id}', this.checked)"
                  />
                  <div class="flex-1">
                    <div class="font-medium">\${escapeHtml(plan.treatment_name)}</div>
                    <div class="text-sm text-gray-600">\${escapeHtml(plan.plan_name)}</div>
                    <div class="text-sm text-gray-500">\xA5\${plan.price_taxed.toLocaleString()}\uFF08\u7A0E\u8FBC\uFF09</div>
                  </div>
                </label>
              \`).join('')}
            </div>
          </div>
        \`).join('')}
      </div>
    \`).join('');
  }

  function handlePlanSelection(planId: string, isSelected: boolean) {
    if (isSelected) {
      const plan = allTreatmentPlans.find(p => p.id === planId);
      if (plan) {
        plans.push({
          treatment_plan_id: planId,
          discount_type: 'percentage',
          discount_value: null,
          special_price: null,
          special_price_taxed: null
        });
      }
    } else {
      plans = plans.filter(p => p.treatment_plan_id !== planId);
    }
    renderPlanList();
    renderAvailablePlans(); // \u9078\u629E\u6E08\u307F\u3092\u9664\u5916\u3059\u308B\u305F\u3081\u306B\u518D\u63CF\u753B
  }

  function populateForm(data: CampaignData) {
    (document.getElementById('campaignId') as HTMLInputElement).value = data.id;
    (document.getElementById('title') as HTMLInputElement).value = data.title;
    (document.getElementById('slug') as HTMLInputElement).value = data.slug;
    (document.getElementById('description') as HTMLTextAreaElement).value = data.description || '';
    (document.getElementById('campaignType') as HTMLSelectElement).value = data.campaign_type;
    (document.getElementById('priority') as HTMLInputElement).value = data.priority.toString();
    
    if (data.start_date) {
      (document.getElementById('startDate') as HTMLInputElement).value = data.start_date.split('T')[0];
    }
    if (data.end_date) {
      (document.getElementById('endDate') as HTMLInputElement).value = data.end_date.split('T')[0];
    }
    
    (document.getElementById('isPublished') as HTMLInputElement).checked = data.is_published === 1;
  }

  function renderPlanList() {
    const planList = document.getElementById('planList');
    if (!planList) return;

    if (plans.length === 0) {
      planList.innerHTML = '<p class="text-sm text-gray-500">\u30D7\u30E9\u30F3\u3092\u8FFD\u52A0\u3057\u3066\u304F\u3060\u3055\u3044</p>';
      return;
    }

    planList.innerHTML = plans.map((plan, index) => {
      const selectedPlan = allTreatmentPlans.find(p => p.id === plan.treatment_plan_id);
      const originalPrice = selectedPlan?.price_taxed || 0;
      let campaignPrice = originalPrice;
      
      if (plan.special_price_taxed) {
        campaignPrice = plan.special_price_taxed;
      } else if (plan.discount_type === 'percentage' && plan.discount_value) {
        campaignPrice = Math.floor(originalPrice * (1 - plan.discount_value / 100));
      } else if (plan.discount_type === 'fixed' && plan.discount_value) {
        campaignPrice = Math.max(0, originalPrice - plan.discount_value);
      }
      
      const discountAmount = originalPrice - campaignPrice;
      const discountRate = originalPrice > 0 ? Math.round((discountAmount / originalPrice) * 100) : 0;

      return \`
        <div class="border rounded-lg p-4 bg-white plan-item shadow-sm" data-index="\${index}">
          <div class="flex justify-between items-start mb-4">
            <div class="flex-1">
              <div class="font-semibold text-lg">\${escapeHtml(selectedPlan?.treatment_name || '')}</div>
              <div class="text-sm text-gray-600 mt-1">\${escapeHtml(selectedPlan?.category_name || '')} / \${escapeHtml(selectedPlan?.subcategory_name || '')}</div>
              <div class="text-sm text-gray-500 mt-1">\${escapeHtml(selectedPlan?.plan_name || '')}</div>
              <div class="mt-2 flex items-center gap-4">
                <div>
                  <span class="text-sm text-gray-500">\u901A\u5E38\u4FA1\u683C:</span>
                  <span class="text-lg font-semibold ml-2">\xA5\${originalPrice.toLocaleString()}</span>
                </div>
                \${discountAmount > 0 ? \`
                  <div class="text-accent">
                    <span class="text-sm">\u30AD\u30E3\u30F3\u30DA\u30FC\u30F3\u4FA1\u683C:</span>
                    <span class="text-lg font-semibold ml-2">\xA5\${campaignPrice.toLocaleString()}</span>
                    <span class="text-sm ml-2">(\${discountRate}% OFF)</span>
                  </div>
                \` : ''}
              </div>
            </div>
            <button
              type="button"
              onclick="removePlan(\${index})"
              class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition text-sm"
            >
              \u524A\u9664
            </button>
          </div>
          
          <input type="hidden" name="plan_\${index}_treatment_plan_id" value="\${plan.treatment_plan_id}" />
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t">
            <div>
              <label class="block text-sm font-medium mb-1">\u5272\u5F15\u30BF\u30A4\u30D7 <span class="text-red-500">*</span></label>
              <select name="plan_\${index}_discount_type" class="w-full px-4 py-2 border rounded-lg discount-type-select" onchange="updatePlanPreview(\${index})">
                <option value="percentage" \${plan.discount_type === 'percentage' ? 'selected' : ''}>\u30D1\u30FC\u30BB\u30F3\u30C8\u5272\u5F15</option>
                <option value="fixed" \${plan.discount_type === 'fixed' ? 'selected' : ''}>\u56FA\u5B9A\u984D\u5272\u5F15</option>
                <option value="special_price" \${plan.discount_type === 'special_price' ? 'selected' : ''}>\u7279\u5225\u4FA1\u683C</option>
              </select>
            </div>
            <div id="plan_\${index}_discount_value_container">
              <label class="block text-sm font-medium mb-1">\u5272\u5F15\u5024</label>
              <input
                type="number"
                name="plan_\${index}_discount_value"
                value="\${plan.discount_value || ''}"
                placeholder="\u30D1\u30FC\u30BB\u30F3\u30C8(%) \u307E\u305F\u306F \u56FA\u5B9A\u984D(\u5186)"
                class="w-full px-4 py-2 border rounded-lg"
                oninput="updatePlanPreview(\${index})"
              />
            </div>
            <div id="plan_\${index}_special_price_container" class="\${plan.discount_type === 'special_price' ? '' : 'hidden'}">
              <label class="block text-sm font-medium mb-1">\u7279\u5225\u4FA1\u683C\uFF08\u7A0E\u629C\uFF09</label>
              <input
                type="number"
                name="plan_\${index}_special_price"
                value="\${plan.special_price || ''}"
                placeholder="\u7279\u5225\u4FA1\u683C\u3092\u8A2D\u5B9A"
                class="w-full px-4 py-2 border rounded-lg"
                oninput="updatePlanPreview(\${index})"
              />
            </div>
          </div>
        </div>
      \`;
    }).join('');
    
    // \u5272\u5F15\u30BF\u30A4\u30D7\u306B\u5FDC\u3058\u3066\u8868\u793A/\u975E\u8868\u793A\u3092\u5207\u308A\u66FF\u3048
    plans.forEach((plan, index) => {
      const discountTypeSelect = document.querySelector(\`select[name="plan_\${index}_discount_type"]\`) as HTMLSelectElement;
      const discountValueContainer = document.getElementById(\`plan_\${index}_discount_value_container\`);
      const specialPriceContainer = document.getElementById(\`plan_\${index}_special_price_container\`);
      
      if (discountTypeSelect && discountValueContainer && specialPriceContainer) {
        discountTypeSelect.addEventListener('change', () => {
          if (discountTypeSelect.value === 'special_price') {
            discountValueContainer.classList.add('hidden');
            specialPriceContainer.classList.remove('hidden');
          } else {
            discountValueContainer.classList.remove('hidden');
            specialPriceContainer.classList.add('hidden');
          }
        });
      }
    });
  }

  function removePlan(index: number) {
    plans.splice(index, 1);
    renderPlanList();
    renderAvailablePlans(); // \u9078\u629E\u89E3\u9664\u3055\u308C\u305F\u30D7\u30E9\u30F3\u3092\u518D\u5EA6\u8868\u793A
  }

  function updatePlanPreview(index: number) {
    // \u30D7\u30EC\u30D3\u30E5\u30FC\u66F4\u65B0\uFF08\u5FC5\u8981\u306B\u5FDC\u3058\u3066\u5B9F\u88C5\uFF09
    // \u73FE\u5728\u306F renderPlanList \u3067\u518D\u8A08\u7B97\u3055\u308C\u308B\u306E\u3067\u3001\u3053\u3053\u3067\u306F\u7279\u306B\u51E6\u7406\u4E0D\u8981
  }

  function escapeHtml(text: string): string {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  document.addEventListener('DOMContentLoaded', () => {
    loadData();

    const form = document.getElementById('campaignForm') as HTMLFormElement;
    
    form?.addEventListener('submit', async (e) => {
      e.preventDefault();
      const formData = new FormData(form);
      
      // \u30D7\u30E9\u30F3\u30C7\u30FC\u30BF\u3092\u53CE\u96C6
      const planData: Plan[] = [];
      plans.forEach((plan, index) => {
        const discountType = formData.get(\`plan_\${index}_discount_type\`) as string;
        const discountValue = formData.get(\`plan_\${index}_discount_value\`);
        const specialPrice = formData.get(\`plan_\${index}_special_price\`);
        
        planData.push({
          treatment_plan_id: plan.treatment_plan_id,
          discount_type: discountType || plan.discount_type,
          discount_value: discountValue ? Number(discountValue) : null,
          special_price: specialPrice ? Number(specialPrice) : null,
          special_price_taxed: specialPrice ? Math.round(Number(specialPrice) * 1.1) : null
        });
      });
      
      const data = {
        title: formData.get('title'),
        slug: formData.get('slug'),
        description: formData.get('description') || null,
        campaign_type: formData.get('campaignType') || 'discount',
        priority: formData.get('priority') ? Number(formData.get('priority')) : 0,
        start_date: formData.get('startDate') || null,
        end_date: formData.get('endDate') || null,
        is_published: formData.get('isPublished') === 'on',
        sort_order: 0,
        plans: planData
      };

      try {
        const res = await fetch(\`/api/campaigns/\${campaignId}\`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data),
        });

        if (res.ok) {
          alert('\u66F4\u65B0\u3057\u307E\u3057\u305F');
          window.location.reload();
        } else {
          const error = await res.json();
          alert(\`\u66F4\u65B0\u306B\u5931\u6557\u3057\u307E\u3057\u305F: \${error.message || 'Unknown error'}\`);
        }
      } catch (error) {
        console.error('\u66F4\u65B0\u30A8\u30E9\u30FC:', error);
        alert('\u66F4\u65B0\u306B\u5931\u6557\u3057\u307E\u3057\u305F');
      }
    });
  });

  (window as any).togglePlanSelector = togglePlanSelector;
  (window as any).filterPlans = filterPlans;
  (window as any).handlePlanSelection = handlePlanSelection;
  (window as any).removePlan = removePlan;
  (window as any).updatePlanPreview = updatePlanPreview;
})();<\/script>`], ["", " <script>(function(){", `
  interface CampaignData {
    id: string;
    title: string;
    slug: string;
    description: string | null;
    start_date: string | null;
    end_date: string | null;
    campaign_type: string;
    priority: number;
    is_published: number;
  }

  interface Plan {
    id?: string;
    treatment_plan_id: string;
    discount_type: string;
    discount_value: number | null;
    special_price: number | null;
    special_price_taxed: number | null;
  }

  let campaign: CampaignData | null = null;
  let plans: Plan[] = [];
  let allTreatmentPlans: Array<{ 
    id: string; 
    plan_name: string; 
    treatment_name: string; 
    treatment_id: string;
    category_name: string;
    subcategory_name: string;
    price: number;
    price_taxed: number;
  }> = [];

  async function loadData() {
    try {
      // \u30AD\u30E3\u30F3\u30DA\u30FC\u30F3\u30C7\u30FC\u30BF\u53D6\u5F97
      const res = await fetch(\\\`/api/campaigns/\\\${campaignId}\\\`);
      if (!res.ok) {
        throw new Error('\u30AD\u30E3\u30F3\u30DA\u30FC\u30F3\u304C\u898B\u3064\u304B\u308A\u307E\u305B\u3093');
      }
      const data = await res.json();
      campaign = data.campaign as CampaignData;
      plans = data.plans || [];

      // \u30D7\u30E9\u30F3\u4E00\u89A7\u53D6\u5F97\uFF08\u5BFE\u8C61\u30D7\u30E9\u30F3\u9078\u629E\u7528\uFF09
      await loadTreatmentPlans();

      // \u30D5\u30A9\u30FC\u30E0\u306B\u5024\u3092\u8A2D\u5B9A
      populateForm(campaign);

      // \u30D5\u30A9\u30FC\u30E0\u3092\u8868\u793A
      document.getElementById('loadingMessage')?.classList.add('hidden');
      const form = document.getElementById('campaignForm');
      if (form) {
        form.classList.remove('hidden');
      }

      // \u30D7\u30E9\u30F3\u30EA\u30B9\u30C8\u3092\u8868\u793A
      renderPlanList();
    } catch (error) {
      console.error('\u30C7\u30FC\u30BF\u8AAD\u307F\u8FBC\u307F\u30A8\u30E9\u30FC:', error);
      const loadingMsg = document.getElementById('loadingMessage');
      if (loadingMsg) {
        loadingMsg.innerHTML = \\\`<p class="text-red-500">\u30C7\u30FC\u30BF\u306E\u8AAD\u307F\u8FBC\u307F\u306B\u5931\u6557\u3057\u307E\u3057\u305F: \\\${error instanceof Error ? error.message : 'Unknown error'}</p>\\\`;
      }
    }
  }

  async function loadTreatmentPlans() {
    try {
      const res = await fetch('/api/pricing');
      const data = await res.json();
      allTreatmentPlans = (data.plans || []).map((p: any) => ({
        id: p.id,
        plan_name: p.plan_name,
        treatment_name: p.treatment_name,
        treatment_id: p.treatment_id,
        category_name: p.category_name,
        subcategory_name: p.subcategory_name,
        price: p.price,
        price_taxed: p.price_taxed
      }));
      renderAvailablePlans();
    } catch (error) {
      console.error('\u30D7\u30E9\u30F3\u4E00\u89A7\u8AAD\u307F\u8FBC\u307F\u30A8\u30E9\u30FC:', error);
    }
  }

  function togglePlanSelector() {
    const modal = document.getElementById('planSelectorModal');
    if (modal) {
      modal.classList.toggle('hidden');
      if (!modal.classList.contains('hidden')) {
        renderAvailablePlans();
      }
    }
  }

  function filterPlans() {
    renderAvailablePlans();
  }

  function renderAvailablePlans() {
    const container = document.getElementById('availablePlans');
    if (!container) return;

    const searchTerm = (document.getElementById('planSearchInput') as HTMLInputElement)?.value.toLowerCase() || '';
    const selectedPlanIds = plans.map(p => p.treatment_plan_id);
    
    // \u30AB\u30C6\u30B4\u30EA\u30FB\u30B5\u30D6\u30AB\u30C6\u30B4\u30EA\u3067\u30B0\u30EB\u30FC\u30D7\u5316
    const grouped: Record<string, Record<string, typeof allTreatmentPlans>> = {};
    allTreatmentPlans
      .filter(plan => {
        const matchesSearch = !searchTerm || 
          plan.treatment_name.toLowerCase().includes(searchTerm) ||
          plan.plan_name.toLowerCase().includes(searchTerm) ||
          plan.category_name.toLowerCase().includes(searchTerm) ||
          plan.subcategory_name.toLowerCase().includes(searchTerm);
        return matchesSearch && !selectedPlanIds.includes(plan.id);
      })
      .forEach(plan => {
        if (!grouped[plan.category_name]) {
          grouped[plan.category_name] = {};
        }
        if (!grouped[plan.category_name][plan.subcategory_name]) {
          grouped[plan.category_name][plan.subcategory_name] = [];
        }
        grouped[plan.category_name][plan.subcategory_name].push(plan);
      });

    if (Object.keys(grouped).length === 0) {
      container.innerHTML = '<p class="text-gray-500 text-center py-8">\u8A72\u5F53\u3059\u308B\u30D7\u30E9\u30F3\u304C\u898B\u3064\u304B\u308A\u307E\u305B\u3093</p>';
      return;
    }

    container.innerHTML = Object.entries(grouped).map(([categoryName, subcategories]) => \\\`
      <div class="mb-6">
        <h5 class="font-semibold text-lg mb-3 text-gray-700 border-b pb-2">\\\${escapeHtml(categoryName)}</h5>
        \\\${Object.entries(subcategories).map(([subcategoryName, plans]) => \\\`
          <div class="ml-4 mb-4">
            <h6 class="font-medium text-sm text-gray-600 mb-2">\\\${escapeHtml(subcategoryName)}</h6>
            <div class="space-y-1">
              \\\${plans.map(plan => \\\`
                <label class="flex items-center p-3 border rounded-lg hover:bg-gray-50 cursor-pointer transition">
                  <input
                    type="checkbox"
                    class="mr-3 w-4 h-4 text-accent"
                    value="\\\${plan.id}"
                    onchange="handlePlanSelection('\\\${plan.id}', this.checked)"
                  />
                  <div class="flex-1">
                    <div class="font-medium">\\\${escapeHtml(plan.treatment_name)}</div>
                    <div class="text-sm text-gray-600">\\\${escapeHtml(plan.plan_name)}</div>
                    <div class="text-sm text-gray-500">\xA5\\\${plan.price_taxed.toLocaleString()}\uFF08\u7A0E\u8FBC\uFF09</div>
                  </div>
                </label>
              \\\`).join('')}
            </div>
          </div>
        \\\`).join('')}
      </div>
    \\\`).join('');
  }

  function handlePlanSelection(planId: string, isSelected: boolean) {
    if (isSelected) {
      const plan = allTreatmentPlans.find(p => p.id === planId);
      if (plan) {
        plans.push({
          treatment_plan_id: planId,
          discount_type: 'percentage',
          discount_value: null,
          special_price: null,
          special_price_taxed: null
        });
      }
    } else {
      plans = plans.filter(p => p.treatment_plan_id !== planId);
    }
    renderPlanList();
    renderAvailablePlans(); // \u9078\u629E\u6E08\u307F\u3092\u9664\u5916\u3059\u308B\u305F\u3081\u306B\u518D\u63CF\u753B
  }

  function populateForm(data: CampaignData) {
    (document.getElementById('campaignId') as HTMLInputElement).value = data.id;
    (document.getElementById('title') as HTMLInputElement).value = data.title;
    (document.getElementById('slug') as HTMLInputElement).value = data.slug;
    (document.getElementById('description') as HTMLTextAreaElement).value = data.description || '';
    (document.getElementById('campaignType') as HTMLSelectElement).value = data.campaign_type;
    (document.getElementById('priority') as HTMLInputElement).value = data.priority.toString();
    
    if (data.start_date) {
      (document.getElementById('startDate') as HTMLInputElement).value = data.start_date.split('T')[0];
    }
    if (data.end_date) {
      (document.getElementById('endDate') as HTMLInputElement).value = data.end_date.split('T')[0];
    }
    
    (document.getElementById('isPublished') as HTMLInputElement).checked = data.is_published === 1;
  }

  function renderPlanList() {
    const planList = document.getElementById('planList');
    if (!planList) return;

    if (plans.length === 0) {
      planList.innerHTML = '<p class="text-sm text-gray-500">\u30D7\u30E9\u30F3\u3092\u8FFD\u52A0\u3057\u3066\u304F\u3060\u3055\u3044</p>';
      return;
    }

    planList.innerHTML = plans.map((plan, index) => {
      const selectedPlan = allTreatmentPlans.find(p => p.id === plan.treatment_plan_id);
      const originalPrice = selectedPlan?.price_taxed || 0;
      let campaignPrice = originalPrice;
      
      if (plan.special_price_taxed) {
        campaignPrice = plan.special_price_taxed;
      } else if (plan.discount_type === 'percentage' && plan.discount_value) {
        campaignPrice = Math.floor(originalPrice * (1 - plan.discount_value / 100));
      } else if (plan.discount_type === 'fixed' && plan.discount_value) {
        campaignPrice = Math.max(0, originalPrice - plan.discount_value);
      }
      
      const discountAmount = originalPrice - campaignPrice;
      const discountRate = originalPrice > 0 ? Math.round((discountAmount / originalPrice) * 100) : 0;

      return \\\`
        <div class="border rounded-lg p-4 bg-white plan-item shadow-sm" data-index="\\\${index}">
          <div class="flex justify-between items-start mb-4">
            <div class="flex-1">
              <div class="font-semibold text-lg">\\\${escapeHtml(selectedPlan?.treatment_name || '')}</div>
              <div class="text-sm text-gray-600 mt-1">\\\${escapeHtml(selectedPlan?.category_name || '')} / \\\${escapeHtml(selectedPlan?.subcategory_name || '')}</div>
              <div class="text-sm text-gray-500 mt-1">\\\${escapeHtml(selectedPlan?.plan_name || '')}</div>
              <div class="mt-2 flex items-center gap-4">
                <div>
                  <span class="text-sm text-gray-500">\u901A\u5E38\u4FA1\u683C:</span>
                  <span class="text-lg font-semibold ml-2">\xA5\\\${originalPrice.toLocaleString()}</span>
                </div>
                \\\${discountAmount > 0 ? \\\`
                  <div class="text-accent">
                    <span class="text-sm">\u30AD\u30E3\u30F3\u30DA\u30FC\u30F3\u4FA1\u683C:</span>
                    <span class="text-lg font-semibold ml-2">\xA5\\\${campaignPrice.toLocaleString()}</span>
                    <span class="text-sm ml-2">(\\\${discountRate}% OFF)</span>
                  </div>
                \\\` : ''}
              </div>
            </div>
            <button
              type="button"
              onclick="removePlan(\\\${index})"
              class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition text-sm"
            >
              \u524A\u9664
            </button>
          </div>
          
          <input type="hidden" name="plan_\\\${index}_treatment_plan_id" value="\\\${plan.treatment_plan_id}" />
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t">
            <div>
              <label class="block text-sm font-medium mb-1">\u5272\u5F15\u30BF\u30A4\u30D7 <span class="text-red-500">*</span></label>
              <select name="plan_\\\${index}_discount_type" class="w-full px-4 py-2 border rounded-lg discount-type-select" onchange="updatePlanPreview(\\\${index})">
                <option value="percentage" \\\${plan.discount_type === 'percentage' ? 'selected' : ''}>\u30D1\u30FC\u30BB\u30F3\u30C8\u5272\u5F15</option>
                <option value="fixed" \\\${plan.discount_type === 'fixed' ? 'selected' : ''}>\u56FA\u5B9A\u984D\u5272\u5F15</option>
                <option value="special_price" \\\${plan.discount_type === 'special_price' ? 'selected' : ''}>\u7279\u5225\u4FA1\u683C</option>
              </select>
            </div>
            <div id="plan_\\\${index}_discount_value_container">
              <label class="block text-sm font-medium mb-1">\u5272\u5F15\u5024</label>
              <input
                type="number"
                name="plan_\\\${index}_discount_value"
                value="\\\${plan.discount_value || ''}"
                placeholder="\u30D1\u30FC\u30BB\u30F3\u30C8(%) \u307E\u305F\u306F \u56FA\u5B9A\u984D(\u5186)"
                class="w-full px-4 py-2 border rounded-lg"
                oninput="updatePlanPreview(\\\${index})"
              />
            </div>
            <div id="plan_\\\${index}_special_price_container" class="\\\${plan.discount_type === 'special_price' ? '' : 'hidden'}">
              <label class="block text-sm font-medium mb-1">\u7279\u5225\u4FA1\u683C\uFF08\u7A0E\u629C\uFF09</label>
              <input
                type="number"
                name="plan_\\\${index}_special_price"
                value="\\\${plan.special_price || ''}"
                placeholder="\u7279\u5225\u4FA1\u683C\u3092\u8A2D\u5B9A"
                class="w-full px-4 py-2 border rounded-lg"
                oninput="updatePlanPreview(\\\${index})"
              />
            </div>
          </div>
        </div>
      \\\`;
    }).join('');
    
    // \u5272\u5F15\u30BF\u30A4\u30D7\u306B\u5FDC\u3058\u3066\u8868\u793A/\u975E\u8868\u793A\u3092\u5207\u308A\u66FF\u3048
    plans.forEach((plan, index) => {
      const discountTypeSelect = document.querySelector(\\\`select[name="plan_\\\${index}_discount_type"]\\\`) as HTMLSelectElement;
      const discountValueContainer = document.getElementById(\\\`plan_\\\${index}_discount_value_container\\\`);
      const specialPriceContainer = document.getElementById(\\\`plan_\\\${index}_special_price_container\\\`);
      
      if (discountTypeSelect && discountValueContainer && specialPriceContainer) {
        discountTypeSelect.addEventListener('change', () => {
          if (discountTypeSelect.value === 'special_price') {
            discountValueContainer.classList.add('hidden');
            specialPriceContainer.classList.remove('hidden');
          } else {
            discountValueContainer.classList.remove('hidden');
            specialPriceContainer.classList.add('hidden');
          }
        });
      }
    });
  }

  function removePlan(index: number) {
    plans.splice(index, 1);
    renderPlanList();
    renderAvailablePlans(); // \u9078\u629E\u89E3\u9664\u3055\u308C\u305F\u30D7\u30E9\u30F3\u3092\u518D\u5EA6\u8868\u793A
  }

  function updatePlanPreview(index: number) {
    // \u30D7\u30EC\u30D3\u30E5\u30FC\u66F4\u65B0\uFF08\u5FC5\u8981\u306B\u5FDC\u3058\u3066\u5B9F\u88C5\uFF09
    // \u73FE\u5728\u306F renderPlanList \u3067\u518D\u8A08\u7B97\u3055\u308C\u308B\u306E\u3067\u3001\u3053\u3053\u3067\u306F\u7279\u306B\u51E6\u7406\u4E0D\u8981
  }

  function escapeHtml(text: string): string {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  document.addEventListener('DOMContentLoaded', () => {
    loadData();

    const form = document.getElementById('campaignForm') as HTMLFormElement;
    
    form?.addEventListener('submit', async (e) => {
      e.preventDefault();
      const formData = new FormData(form);
      
      // \u30D7\u30E9\u30F3\u30C7\u30FC\u30BF\u3092\u53CE\u96C6
      const planData: Plan[] = [];
      plans.forEach((plan, index) => {
        const discountType = formData.get(\\\`plan_\\\${index}_discount_type\\\`) as string;
        const discountValue = formData.get(\\\`plan_\\\${index}_discount_value\\\`);
        const specialPrice = formData.get(\\\`plan_\\\${index}_special_price\\\`);
        
        planData.push({
          treatment_plan_id: plan.treatment_plan_id,
          discount_type: discountType || plan.discount_type,
          discount_value: discountValue ? Number(discountValue) : null,
          special_price: specialPrice ? Number(specialPrice) : null,
          special_price_taxed: specialPrice ? Math.round(Number(specialPrice) * 1.1) : null
        });
      });
      
      const data = {
        title: formData.get('title'),
        slug: formData.get('slug'),
        description: formData.get('description') || null,
        campaign_type: formData.get('campaignType') || 'discount',
        priority: formData.get('priority') ? Number(formData.get('priority')) : 0,
        start_date: formData.get('startDate') || null,
        end_date: formData.get('endDate') || null,
        is_published: formData.get('isPublished') === 'on',
        sort_order: 0,
        plans: planData
      };

      try {
        const res = await fetch(\\\`/api/campaigns/\\\${campaignId}\\\`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data),
        });

        if (res.ok) {
          alert('\u66F4\u65B0\u3057\u307E\u3057\u305F');
          window.location.reload();
        } else {
          const error = await res.json();
          alert(\\\`\u66F4\u65B0\u306B\u5931\u6557\u3057\u307E\u3057\u305F: \\\${error.message || 'Unknown error'}\\\`);
        }
      } catch (error) {
        console.error('\u66F4\u65B0\u30A8\u30E9\u30FC:', error);
        alert('\u66F4\u65B0\u306B\u5931\u6557\u3057\u307E\u3057\u305F');
      }
    });
  });

  (window as any).togglePlanSelector = togglePlanSelector;
  (window as any).filterPlans = filterPlans;
  (window as any).handlePlanSelection = handlePlanSelection;
  (window as any).removePlan = removePlan;
  (window as any).updatePlanPreview = updatePlanPreview;
})();<\/script>`])), renderComponent($$result, "Layout", $$Layout, {}, { "default": async ($$result2) => renderTemplate` ${maybeRenderHead()}<div class="max-w-4xl mx-auto space-y-6"> <div> <a href="/campaigns" class="text-accent hover:underline">← キャンペーン管理に戻る</a> <h2 class="text-3xl font-bold mt-4">キャンペーン編集</h2> </div> <div id="loadingMessage" class="bg-white rounded-lg shadow p-8 text-center"> <p class="text-gray-500">データを読み込み中...</p> </div> <form class="bg-white rounded-lg shadow p-6 space-y-6 hidden" id="campaignForm"> <input type="hidden" name="id" id="campaignId"> <!-- 基本情報 --> <div> <h3 class="text-xl font-semibold mb-4">基本情報</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">キャンペーン名 <span class="text-red-500">*</span></label> <input type="text" name="title" id="title" class="w-full px-4 py-2 border rounded-lg" required> </div> <div> <label class="block text-sm font-medium mb-1">スラッグ <span class="text-red-500">*</span></label> <input type="text" name="slug" id="slug" class="w-full px-4 py-2 border rounded-lg" required> </div> <div class="md:col-span-2"> <label class="block text-sm font-medium mb-1">説明</label> <textarea name="description" id="description" rows="3" class="w-full px-4 py-2 border rounded-lg"></textarea> </div> <div> <label class="block text-sm font-medium mb-1">キャンペーン種別</label> <select name="campaignType" id="campaignType" class="w-full px-4 py-2 border rounded-lg"> <option value="discount">割引</option> <option value="bundle">セット</option> <option value="point">ポイント</option> <option value="referral">紹介</option> </select> </div> <div> <label class="block text-sm font-medium mb-1">優先度</label> <input type="number" name="priority" id="priority" min="0" class="w-full px-4 py-2 border rounded-lg"> </div> </div> </div> <!-- 期間設定 --> <div> <h3 class="text-xl font-semibold mb-4">期間設定</h3> <div class="grid grid-cols-1 md:grid-cols-2 gap-4"> <div> <label class="block text-sm font-medium mb-1">開始日</label> <input type="date" name="startDate" id="startDate" class="w-full px-4 py-2 border rounded-lg"> </div> <div> <label class="block text-sm font-medium mb-1">終了日</label> <input type="date" name="endDate" id="endDate" class="w-full px-4 py-2 border rounded-lg"> </div> </div> </div> <!-- 対象プラン --> <div> <div class="flex justify-between items-center mb-4"> <h3 class="text-xl font-semibold">対象プラン</h3> <button type="button" onclick="togglePlanSelector()" class="px-4 py-2 bg-accent text-white rounded-lg hover:bg-accent-light transition text-sm">
+ プラン追加
</button> </div> <!-- プラン選択モーダル --> <div id="planSelectorModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"> <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[80vh] flex flex-col"> <div class="p-4 border-b flex justify-between items-center"> <h4 class="text-lg font-semibold">通常メニューから選択</h4> <button onclick="togglePlanSelector()" class="text-gray-500 hover:text-gray-700 text-xl">&times;</button> </div> <div class="p-4 border-b"> <input type="text" id="planSearchInput" placeholder="施術名・プラン名で検索..." class="w-full px-4 py-2 border rounded-lg" oninput="filterPlans()"> </div> <div class="flex-1 overflow-y-auto p-4"> <div id="availablePlans" class="space-y-2"> <p class="text-gray-500 text-center py-8">読み込み中...</p> </div> </div> </div> </div> <!-- 選択済みプランリスト --> <div id="planList" class="space-y-4"> <p class="text-sm text-gray-500">プランを追加してください</p> </div> </div> <!-- 公開設定 --> <div> <h3 class="text-xl font-semibold mb-4">公開設定</h3> <div class="flex items-center gap-4"> <label class="flex items-center gap-2 cursor-pointer"> <input type="checkbox" name="isPublished" id="isPublished" class="w-4 h-4 text-accent border-gray-300 rounded"> <span>公開する</span> </label> </div> </div> <!-- アクション --> <div class="flex justify-end gap-4 pt-4 border-t"> <a href="/campaigns" class="px-6 py-2 border rounded-lg hover:bg-gray-50 transition">
キャンセル
</a> <button type="submit" class="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent-light transition">
更新
</button> </div> </form> </div> ` }), defineScriptVars({ campaignId: id }));
}, "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/[id]/edit.astro", void 0);

const $$file = "/Users/iguchiyuuta/Dev/ledian_clinic/apps/internal-site/src/pages/campaigns/[id]/edit.astro";
const $$url = "/campaigns/[id]/edit";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Edit,
  file: $$file,
  prerender,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
