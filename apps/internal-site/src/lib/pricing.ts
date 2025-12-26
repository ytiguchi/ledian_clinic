const DEFAULT_TAX_RATE = 0.1;

export const normalizeString = (value: unknown) =>
  typeof value === 'string' ? value.trim() : '';

export const parseNullableNumber = (value: unknown) => {
  if (value === null || value === undefined || value === '') return null;
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '' && !Number.isNaN(Number(value))) {
    return Number(value);
  }
  return null;
};

export type PricingInput = {
  subcategory_id?: unknown;
  plan_name?: unknown;
  plan_type?: unknown;
  sessions?: unknown;
  quantity?: unknown;
  price?: unknown;
  price_taxed?: unknown;
  price_per_session?: unknown;
  price_per_session_taxed?: unknown;
  cost_rate?: unknown;
  supply_cost?: unknown;
  staff_cost?: unknown;
  total_cost?: unknown;
  notes?: unknown;
};

type NormalizedPricingInput = {
  subcategoryId: string;
  planName: string;
  planType: string;
  sessions: number | null;
  quantity: string | null;
  price: number;
  priceTaxed: number;
  pricePerSession: number | null;
  pricePerSessionTaxed: number | null;
  costRate: number | null;
  supplyCost: number | null;
  staffCost: number | null;
  totalCost: number | null;
  notes: string | null;
};

type PricingValidationError = {
  field: 'subcategory_id' | 'plan_name' | 'price';
  message: string;
};

export const normalizePricingInput = (
  data: PricingInput,
  taxRate: number
): { values: NormalizedPricingInput | null; errors: PricingValidationError[] } => {
  const errors: PricingValidationError[] = [];
  const subcategoryId = normalizeString(data.subcategory_id);
  const planName = normalizeString(data.plan_name);
  const price = parseNullableNumber(data.price);

  if (!subcategoryId) {
    errors.push({ field: 'subcategory_id', message: 'subcategory_id is required' });
  }
  if (!planName) {
    errors.push({ field: 'plan_name', message: 'plan_name is required' });
  }
  if (price === null) {
    errors.push({ field: 'price', message: 'price is required' });
  }
  if (errors.length > 0) {
    return { values: null, errors };
  }

  const planType = normalizeString(data.plan_type) || 'single';
  const priceTaxed = toTaxedPrice(price as number, taxRate);
  const sessions = parseNullableNumber(data.sessions);
  const quantity = normalizeString(data.quantity) || null;
  const pricePerSession = parseNullableNumber(data.price_per_session);
  const pricePerSessionTaxed =
    pricePerSession === null ? null : toTaxedPrice(pricePerSession, taxRate);
  const costRate = parseNullableNumber(data.cost_rate);
  const supplyCost = parseNullableNumber(data.supply_cost);
  const staffCost = parseNullableNumber(data.staff_cost);
  const totalCost = parseNullableNumber(data.total_cost);
  const notes = normalizeString(data.notes) || null;

  return {
    values: {
      subcategoryId,
      planName,
      planType,
      sessions,
      quantity,
      price: price as number,
      priceTaxed,
      pricePerSession,
      pricePerSessionTaxed,
      costRate,
      supplyCost,
      staffCost,
      totalCost,
      notes,
    },
    errors,
  };
};

export const getTaxRate = (runtime?: App.Locals['runtime']) => {
  const raw = runtime?.env?.TAX_RATE;
  if (typeof raw === 'string') {
    const parsed = Number(raw);
    if (Number.isFinite(parsed) && parsed >= 0) {
      return parsed;
    }
    console.warn(
      `Invalid TAX_RATE env value "${raw}". Using default ${DEFAULT_TAX_RATE}.`
    );
  } else if (raw !== undefined) {
    console.warn(
      `Invalid TAX_RATE env type "${typeof raw}". Using default ${DEFAULT_TAX_RATE}.`
    );
  }
  return DEFAULT_TAX_RATE;
};

export const toTaxedPrice = (amount: number, taxRate: number) =>
  Math.round(amount * (1 + taxRate));
