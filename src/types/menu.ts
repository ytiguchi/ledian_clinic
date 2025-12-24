/**
 * レディアンクリニック メニュー管理システム
 * TypeScript 型定義
 */

// ============================================
// 基本型
// ============================================

/** UUID型（文字列として扱う） */
export type UUID = string;

/** 日時型 */
export type Timestamp = string;

/** 価格（整数、税抜） */
export type Price = number;

/** 価格（税込） */
export type PriceTaxed = number;

/** パーセンテージ（0-100） */
export type Percentage = number;

// ============================================
// Enum / Union Types
// ============================================

/** プラン種別 */
export type PlanType = 
  | 'single'    // 単発
  | 'course'    // 回数コース
  | 'trial'     // 初回お試し
  | 'monitor'   // モニター価格
  | 'campaign'; // キャンペーン

// ============================================
// エンティティ型
// ============================================

/** カテゴリ（大分類） */
export interface Category {
  id: UUID;
  name: string;
  slug: string;
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** カテゴリ（サブカテゴリ含む） */
export interface CategoryWithSubcategories extends Category {
  subcategories: SubcategoryWithTreatments[];
}

/** サブカテゴリ（中分類/治療法グループ） */
export interface Subcategory {
  id: UUID;
  categoryId: UUID;
  name: string;
  slug: string;
  description: string | null;
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** サブカテゴリ（施術含む） */
export interface SubcategoryWithTreatments extends Subcategory {
  treatments: TreatmentWithPlans[];
}

/** 施術（小分類/個別施術） */
export interface Treatment {
  id: UUID;
  subcategoryId: UUID;
  name: string;
  slug: string;
  description: string | null;
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** 施術（プラン含む） */
export interface TreatmentWithPlans extends Treatment {
  plans: TreatmentPlan[];
}

/** 施術（フル情報） */
export interface TreatmentFull extends Treatment {
  categoryId: UUID;
  categoryName: string;
  subcategoryName: string;
  plans: TreatmentPlan[];
}

/** 施術プラン（料金体系） */
export interface TreatmentPlan {
  id: UUID;
  treatmentId: UUID;
  
  // プラン情報
  planName: string;
  planType: PlanType;
  sessions: number | null;
  quantity: string | null;
  
  // 価格情報
  price: Price;
  priceTaxed: PriceTaxed;
  pricePerSession: Price | null;
  pricePerSessionTaxed: PriceTaxed | null;
  
  // キャンペーン価格
  campaignPrice: Price | null;
  campaignPriceTaxed: PriceTaxed | null;
  
  // 原価情報
  costRate: Percentage | null;
  campaignCostRate: Percentage | null;
  supplyCost: Price | null;
  staffCost: Price | null;
  totalCost: Price | null;
  
  // その他
  oldPrice: Price | null;
  staffDiscountRate: Percentage | null;
  notes: string | null;
  
  // メタ情報
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** オプション（麻酔等） */
export interface TreatmentOption {
  id: UUID;
  name: string;
  description: string | null;
  price: Price;
  priceTaxed: PriceTaxed;
  isGlobal: boolean;
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** 薬剤 */
export interface Medication {
  id: UUID;
  name: string;
  slug: string;
  description: string | null;
  unit: string;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** 薬剤プラン */
export interface MedicationPlan {
  id: UUID;
  medicationId: UUID;
  quantity: string;
  sessions: number | null;
  price: Price;
  priceTaxed: PriceTaxed;
  campaignPrice: Price | null;
  costRate: Percentage | null;
  supplyCost: Price | null;
  staffCost: Price | null;
  totalCost: Price | null;
  staffDiscountRate: Percentage | null;
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

// ============================================
// API レスポンス型
// ============================================

/** 料金表一覧（ビュー用） - 4階層構造 */
export interface PriceListItem {
  categoryName: string;
  subcategoryName: string;
  treatmentName: string;
  planName: string;
  planType: PlanType;
  sessions: number | null;
  quantity: string | null;
  price: Price;
  priceTaxed: PriceTaxed;
  pricePerSession: Price | null;
  campaignPrice: Price | null;
  campaignPriceTaxed: PriceTaxed | null;
  costRate: Percentage | null;
  notes: string | null;
}

/** カテゴリ別メニュー */
export interface MenuByCategory {
  category: Category;
  subcategories: {
    subcategory: Subcategory;
    treatments: {
      treatment: Treatment;
      plans: TreatmentPlan[];
    }[];
  }[];
}

// ============================================
// 入力型（作成・更新用）
// ============================================

/** カテゴリ作成 */
export interface CreateCategoryInput {
  name: string;
  slug?: string;
  sortOrder?: number;
}

/** カテゴリ更新 */
export interface UpdateCategoryInput {
  name?: string;
  slug?: string;
  sortOrder?: number;
  isActive?: boolean;
}

/** サブカテゴリ作成 */
export interface CreateSubcategoryInput {
  categoryId: UUID;
  name: string;
  slug?: string;
  description?: string;
  sortOrder?: number;
}

/** 施術作成 */
export interface CreateTreatmentInput {
  subcategoryId: UUID;
  name: string;
  slug?: string;
  description?: string;
  sortOrder?: number;
}

/** プラン作成 */
export interface CreateTreatmentPlanInput {
  treatmentId: UUID;
  planName: string;
  planType?: PlanType;
  sessions?: number;
  quantity?: string;
  price: Price;
  priceTaxed?: PriceTaxed;
  pricePerSession?: Price;
  pricePerSessionTaxed?: PriceTaxed;
  campaignPrice?: Price;
  costRate?: Percentage;
  supplyCost?: Price;
  staffCost?: Price;
  notes?: string;
  sortOrder?: number;
}

/** プラン更新 */
export interface UpdateTreatmentPlanInput {
  planName?: string;
  planType?: PlanType;
  sessions?: number | null;
  quantity?: string | null;
  price?: Price;
  priceTaxed?: PriceTaxed;
  pricePerSession?: Price | null;
  pricePerSessionTaxed?: PriceTaxed | null;
  campaignPrice?: Price | null;
  campaignPriceTaxed?: PriceTaxed | null;
  costRate?: Percentage | null;
  supplyCost?: Price | null;
  staffCost?: Price | null;
  totalCost?: Price | null;
  notes?: string | null;
  sortOrder?: number;
  isActive?: boolean;
}

// ============================================
// 検索・フィルタ型
// ============================================

/** 施術検索パラメータ */
export interface SearchTreatmentsParams {
  query?: string;
  categoryId?: UUID;
  subcategoryId?: UUID;
  planType?: PlanType;
  minPrice?: Price;
  maxPrice?: Price;
  isActive?: boolean;
  limit?: number;
  offset?: number;
}

/** ページネーション */
export interface PaginatedResult<T> {
  items: T[];
  total: number;
  limit: number;
  offset: number;
  hasMore: boolean;
}

// ============================================
// ユーティリティ型
// ============================================

/** DB行からエンティティへの変換ヘルパー */
export type DbRow<T> = {
  [K in keyof T as K extends string 
    ? K extends `${infer First}${infer Rest}` 
      ? `${Lowercase<First>}${Rest extends `${infer F}${infer R}` 
          ? F extends Uppercase<F> 
            ? `_${Lowercase<F>}${R}` 
            : `${F}${R}` 
          : Rest}`
      : K
    : K
  ]: T[K];
};

/** Nullable型 */
export type Nullable<T> = T | null;

/** Optional型（undefinedも許可） */
export type Optional<T> = T | null | undefined;



