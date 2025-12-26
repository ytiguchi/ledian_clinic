const DEFAULT_TAX_RATE = 0.1;

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
