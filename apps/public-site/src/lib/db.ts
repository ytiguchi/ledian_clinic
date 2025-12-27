/**
 * D1 Database helpers for public site
 */

export type Category = {
  id: string;
  name: string;
  slug: string;
  sort_order: number;
  is_active: number;
};

export type Subcategory = {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  description: string | null;
  sort_order: number;
  is_active: number;
};

export type Treatment = {
  id: string;
  subcategory_id: string;
  name: string;
  slug: string;
  description: string | null;
  sort_order: number;
  is_active: number;
};

export type TreatmentWithDetails = Treatment & {
  category_name: string;
  category_slug: string;
  subcategory_name: string;
  subcategory_slug: string;
  thumbnail_url?: string;
  tagline?: string;
  is_featured?: number;
  is_new?: number;
};

export type TreatmentPlan = {
  id: string;
  treatment_id: string;
  plan_name: string;
  plan_type: string;
  sessions: number | null;
  quantity: string | null;
  price: number;
  price_taxed: number;
  campaign_price: number | null;
  campaign_price_taxed: number | null;
};

export type Campaign = {
  id: string;
  title: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  start_date: string | null;
  end_date: string | null;
  campaign_type: string;
  is_published: number;
};

export type BeforeAfter = {
  id: string;
  treatment_id: string;
  before_image_url: string;
  after_image_url: string;
  caption: string | null;
  patient_age: number | null;
  is_published: number;
};

// Helpers
export function formatPrice(price: number): string {
  return new Intl.NumberFormat('ja-JP').format(price);
}

export function formatPriceWithTax(price: number, taxed: number): string {
  return `¥${formatPrice(price)}（税込 ¥${formatPrice(taxed)}）`;
}

