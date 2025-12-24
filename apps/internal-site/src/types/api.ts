/**
 * API Type Definitions for Ledian Clinic Management System
 * Based on 4-tier schema: Category → Subcategory → Treatment → TreatmentPlan
 */

// ============================================
// Core Entities
// ============================================

export interface Category {
  id: string;
  name: string;
  slug: string;
  description?: string;
  icon?: string;
  color?: string;
  sort_order: number;
  is_active: boolean;
  is_public: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface Subcategory {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  description?: string;
  device_name?: string;
  sort_order: number;
  is_active: boolean;
  is_public: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface Treatment {
  id: string;
  subcategory_id: string;
  name: string;
  slug: string;
  description?: string;
  sort_order: number;
  is_active: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface TreatmentPlan {
  id: string;
  treatment_id: string;
  plan_name: string;
  plan_type?: string;
  sessions?: number;
  quantity?: string;
  price?: number;
  price_taxed?: number;
  price_per_session?: number;
  price_per_session_taxed?: number;
  cost_rate?: number;
  supply_cost?: number;
  labor_cost?: number;
  total_cost?: number;
  staff_discount_rate?: number;
  staff_price?: number;
  old_price?: number;
  old_price_taxed?: number;
  notes?: string;
  sort_order: number;
  is_active: boolean;
  created_at?: string;
  updated_at?: string;
}

// ============================================
// Related Entities
// ============================================

export interface BeforeAfter {
  id: string;
  treatment_id: string;
  title?: string;
  before_image_url?: string;
  after_image_url?: string;
  description?: string;
  patient_age?: number;
  patient_gender?: string;
  treatment_count?: number;
  is_published: boolean;
  is_internal: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface TrainingModule {
  id: string;
  subcategory_id: string;
  title: string;
  description?: string;
  difficulty_level?: string;
  estimated_minutes?: number;
  sort_order: number;
  is_published: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface TreatmentProtocol {
  id: string;
  treatment_id: string;
  title: string;
  description?: string;
  version?: string;
  is_published: boolean;
  created_at?: string;
  updated_at?: string;
}

export interface Campaign {
  id: string;
  title: string;
  slug: string;
  description?: string;
  start_date?: string;
  end_date?: string;
  is_published: boolean;
  is_featured: boolean;
  discount_type?: string;
  discount_value?: number;
  created_at?: string;
  updated_at?: string;
}

// ============================================
// Service Content (Scraped from Web)
// ============================================

export interface ServiceContent {
  id: string;
  subcategory_id?: string;
  name_ja: string;
  name_en?: string;
  slug: string;
  source_url?: string;
  about_subtitle?: string;
  about_description?: string;
  hero_image_url?: string;
  is_published: boolean;
  scraped_at?: string;
  last_edited_at?: string;
}

export interface ServiceFeature {
  id: string;
  service_content_id: string;
  title: string;
  description?: string;
  icon_url?: string;
  sort_order: number;
}

export interface ServiceRecommendation {
  id: string;
  service_content_id: string;
  text: string;
  sort_order: number;
}

export interface ServiceOverview {
  id: string;
  service_content_id: string;
  duration?: string;
  downtime?: string;
  frequency?: string;
  makeup?: string;
  bathing?: string;
  contraindications?: string;
}

export interface ServiceFaq {
  id: string;
  service_content_id: string;
  question: string;
  answer?: string;
  sort_order: number;
}

// ============================================
// API Response Types
// ============================================

export interface CategorySummary {
  id: string;
  name: string;
  slug?: string;
}

export interface SubcategorySummary {
  id: string;
  name: string;
  slug?: string;
  device_name?: string;
  category_id: string;
  category_name: string;
}

export interface PricePlan {
  id: string;
  plan_name: string;
  plan_type?: string;
  sessions?: number;
  quantity?: string;
  price?: number;
  price_taxed?: number;
  price_per_session?: number;
  price_per_session_taxed?: number;
  cost_rate?: number;
  supply_cost?: number;
  labor_cost?: number;
  total_cost?: number;
  notes?: string;
  treatment_id: string;
  treatment_name: string;
  treatment_slug?: string;
  treatment_description?: string;
  subcategory_id: string;
  subcategory_name: string;
  device_name?: string;
  category_id: string;
  category_name: string;
}

// ============================================
// API Responses
// ============================================

export interface CategoriesResponse {
  categories: CategorySummary[];
}

export interface SubcategoriesResponse {
  subcategories: SubcategorySummary[];
}

export interface PricingResponse {
  plans: PricePlan[];
}

export interface MenuDetailResponse {
  subcategory: SubcategorySummary & {
    description?: string;
    category: CategorySummary;
  };
  treatments: (Treatment & {
    plans: TreatmentPlan[];
  })[];
  beforeAfters: BeforeAfter[];
  trainingModules: TrainingModule[];
  protocols: TreatmentProtocol[];
  serviceContent?: {
    nameJa: string;
    nameEn?: string;
    slug: string;
    sourceUrl?: string;
    aboutSubtitle?: string;
    aboutDescription?: string;
    heroImageUrl?: string;
    features: Pick<ServiceFeature, 'title' | 'description' | 'sort_order'>[];
    recommendations: Pick<ServiceRecommendation, 'text' | 'sort_order'>[];
    overview?: Pick<ServiceOverview, 'duration' | 'downtime' | 'frequency' | 'makeup' | 'bathing' | 'contraindications'>;
    faqs: Pick<ServiceFaq, 'question' | 'answer' | 'sort_order'>[];
  };
}
