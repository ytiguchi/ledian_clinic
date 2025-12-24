export interface CategorySummary {
  id: string;
  name: string;
}

export interface SubcategorySummary {
  id: string;
  name: string;
  category_id: string;
  category_name: string;
}

export interface PricePlan {
  id: string;
  plan_name: string;
  plan_type: string;
  sessions: number | null;
  price: number;
  price_taxed: number;
  campaign_price: number | null;
  campaign_price_taxed: number | null;
  cost_rate: number | null;
  supply_cost: number | null;
  staff_cost: number | null;
  total_cost: number | null;
  treatment_id: string;
  treatment_name: string;
  treatment_slug?: string;
  subcategory_id: string;
  subcategory_name: string;
  category_id: string;
  category_name: string;
  name?: string;
}

export interface MedicationPlan {
  id: string;
  medication_id?: string;
  medication_name: string;
  medication_slug?: string;
  medication_unit: string;
  quantity: string;
  sessions: number | null;
  price: number;
  price_taxed: number;
  campaign_price: number | null;
  cost_rate: number | null;
  supply_cost: number | null;
  staff_cost: number | null;
  total_cost: number | null;
  sort_order?: number;
}

export interface PricingResponse {
  plans: PricePlan[];
}

export interface MedicationPlansResponse {
  plans: MedicationPlan[];
}

export interface CategoriesResponse {
  categories: CategorySummary[];
}

export interface SubcategoriesResponse {
  subcategories: SubcategorySummary[];
}
