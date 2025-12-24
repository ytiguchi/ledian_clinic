/**
 * レディアンクリニック コンテンツ管理
 * TypeScript 型定義
 */

import type { UUID, Timestamp, Price, PriceTaxed } from './menu';

// ============================================
// Enum / Union Types
// ============================================

/** タグ種別 */
export type TagType = 
  | 'concern'    // お悩み
  | 'effect'     // 効果
  | 'body_part'  // 施術部位
  | 'feature';   // 特徴

/** 注意事項タイプ */
export type CautionType = 
  | 'contraindication'  // 禁忌
  | 'before'            // 施術前
  | 'after'             // 施術後
  | 'risk';             // リスク

/** 関連施術タイプ */
export type RelationType = 
  | 'recommended'  // おすすめ
  | 'alternative'  // 代替
  | 'upgrade'      // アップグレード
  | 'set_menu';    // セット

// ============================================
// 施術詳細
// ============================================

/** 施術詳細 */
export interface TreatmentDetail {
  id: UUID;
  treatmentId: UUID;
  
  // 基本テキスト
  tagline: string | null;
  taglineEn: string | null;
  summary: string | null;
  description: string | null;
  
  // スペック
  durationMin: number | null;
  durationMax: number | null;
  durationText: string | null;
  downtimeDays: number;
  downtimeText: string | null;
  painLevel: 1 | 2 | 3 | 4 | 5 | null;
  effectDurationMonths: number | null;
  effectDurationText: string | null;
  recommendedSessions: number | null;
  sessionIntervalWeeks: number | null;
  sessionIntervalText: string | null;
  
  // 表示設定
  popularityRank: number | null;
  isFeatured: boolean;
  isNew: boolean;
  
  // メディア
  heroImageUrl: string | null;
  thumbnailUrl: string | null;
  videoUrl: string | null;
  
  // SEO
  metaTitle: string | null;
  metaDescription: string | null;
  
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** 施術スペック（表示用） */
export interface TreatmentSpecs {
  duration: {
    min?: number;
    max?: number;
    text: string;
    icon: string;
  };
  downtime: {
    days: number;
    text: string;
    icon: string;
  };
  painLevel: {
    level: number;
    text: string;
    icon: string;
  };
  effectDuration: {
    months?: number;
    text: string;
    icon: string;
  };
  recommendedSessions: {
    count?: number;
    text: string;
    icon: string;
  };
  sessionInterval: {
    weeks?: number;
    text: string;
    icon: string;
  };
}

// ============================================
// タグ
// ============================================

/** タグ */
export interface Tag {
  id: UUID;
  tagType: TagType;
  name: string;
  slug: string;
  icon: string | null;
  description: string | null;
  sortOrder: number;
  isActive: boolean;
  createdAt: Timestamp;
}

/** 施術×タグ紐付け */
export interface TreatmentTag {
  id: UUID;
  treatmentId: UUID;
  tagId: UUID;
  isPrimary: boolean;
  sortOrder: number;
  createdAt: Timestamp;
}

// ============================================
// 施術フロー
// ============================================

/** 施術フローステップ */
export interface TreatmentFlowStep {
  id: UUID;
  treatmentId: UUID;
  stepNumber: number;
  title: string;
  description: string | null;
  durationMinutes: number | null;
  icon: string | null;
  createdAt: Timestamp;
}

// ============================================
// 注意事項
// ============================================

/** 注意事項 */
export interface TreatmentCaution {
  id: UUID;
  treatmentId: UUID;
  cautionType: CautionType;
  content: string;
  sortOrder: number;
  createdAt: Timestamp;
}

/** 注意事項（グループ化） */
export interface TreatmentCautionsGrouped {
  contraindications: string[];
  before: string[];
  after: string[];
  risks: string[];
}

// ============================================
// FAQ
// ============================================

/** FAQ */
export interface TreatmentFaq {
  id: UUID;
  treatmentId: UUID;
  question: string;
  answer: string;
  sortOrder: number;
  isPublished: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

// ============================================
// ビフォーアフター
// ============================================

/** ビフォーアフター */
export interface TreatmentBeforeAfter {
  id: UUID;
  treatmentId: UUID;
  beforeImageUrl: string;
  afterImageUrl: string;
  caption: string | null;
  patientAge: number | null;
  patientGender: string | null;
  treatmentCount: number | null;
  treatmentPeriod: string | null;
  isPublished: boolean;
  sortOrder: number;
  createdAt: Timestamp;
}

// ============================================
// 関連施術
// ============================================

/** 関連施術 */
export interface TreatmentRelation {
  id: UUID;
  treatmentId: UUID;
  relatedTreatmentId: UUID;
  relationType: RelationType;
  description: string | null;
  sortOrder: number;
  createdAt: Timestamp;
}

/** 関連施術（詳細付き） */
export interface RelatedTreatment {
  id: UUID;
  name: string;
  categoryName: string;
  tagline: string | null;
  thumbnailUrl: string | null;
  minPrice: Price;
  relationType: RelationType;
}

// ============================================
// ギャラリー
// ============================================

/** ギャラリー画像 */
export interface TreatmentGalleryImage {
  id: UUID;
  treatmentId: UUID;
  imageUrl: string;
  caption: string | null;
  imageType: 'general' | 'machine' | 'process' | 'result';
  sortOrder: number;
  createdAt: Timestamp;
}

// ============================================
// キャンペーン
// ============================================

/** キャンペーン */
export interface Campaign {
  id: UUID;
  title: string;
  slug: string;
  description: string | null;
  imageUrl: string | null;
  startDate: string | null;
  endDate: string | null;
  isPublished: boolean;
  sortOrder: number;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** キャンペーン×施術 */
export interface CampaignTreatment {
  id: UUID;
  campaignId: UUID;
  treatmentId: UUID;
  discountType: 'percentage' | 'fixed' | 'special_price' | null;
  discountValue: number | null;
  specialPrice: Price | null;
  createdAt: Timestamp;
}

// ============================================
// サブスクリプション
// ============================================

/** サブスクリプションプラン */
export interface SubscriptionPlan {
  id: UUID;
  name: string;
  slug: string;
  description: string | null;
  monthlyPrice: Price;
  monthlyPriceTaxed: PriceTaxed;
  features: string[];
  imageUrl: string | null;
  isPopular: boolean;
  isActive: boolean;
  sortOrder: number;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

/** サブスク×施術 */
export interface SubscriptionTreatment {
  id: UUID;
  subscriptionId: UUID;
  treatmentId: UUID;
  monthlyLimit: number | null;
  discountRate: number | null;
  createdAt: Timestamp;
}

// ============================================
// 施術ページ全体（API用）
// ============================================

/** 施術詳細ページ用データ */
export interface TreatmentPageData {
  // 基本情報
  id: UUID;
  name: string;
  slug: string;
  categoryName: string;
  subcategoryName: string;
  
  // 詳細
  detail: TreatmentDetail | null;
  specs: TreatmentSpecs;
  
  // コンテンツ
  concerns: Tag[];
  effects: Tag[];
  bodyParts: Tag[];
  flow: TreatmentFlowStep[];
  cautions: TreatmentCautionsGrouped;
  faqs: TreatmentFaq[];
  beforeAfters: TreatmentBeforeAfter[];
  gallery: TreatmentGalleryImage[];
  
  // 料金
  plans: import('./menu').TreatmentPlan[];
  
  // 関連
  relatedTreatments: RelatedTreatment[];
  
  // キャンペーン
  activeCampaign: Campaign | null;
}

/** 施術一覧用データ */
export interface TreatmentListItem {
  id: UUID;
  name: string;
  slug: string;
  categoryName: string;
  tagline: string | null;
  thumbnailUrl: string | null;
  minPrice: Price;
  minPriceTaxed: PriceTaxed;
  popularityRank: number | null;
  isFeatured: boolean;
  isNew: boolean;
  concerns: string[];
}

// ============================================
// 入力型
// ============================================

/** 施術詳細作成 */
export interface CreateTreatmentDetailInput {
  treatmentId: UUID;
  tagline?: string;
  taglineEn?: string;
  summary?: string;
  description?: string;
  durationMin?: number;
  durationMax?: number;
  durationText?: string;
  downtimeDays?: number;
  downtimeText?: string;
  painLevel?: 1 | 2 | 3 | 4 | 5;
  effectDurationMonths?: number;
  effectDurationText?: string;
  recommendedSessions?: number;
  sessionIntervalWeeks?: number;
  sessionIntervalText?: string;
  popularityRank?: number;
  isFeatured?: boolean;
  isNew?: boolean;
  heroImageUrl?: string;
  thumbnailUrl?: string;
  videoUrl?: string;
}

/** FAQ作成 */
export interface CreateFaqInput {
  treatmentId: UUID;
  question: string;
  answer: string;
  sortOrder?: number;
}

/** 施術フロー作成 */
export interface CreateFlowStepInput {
  treatmentId: UUID;
  stepNumber: number;
  title: string;
  description?: string;
  durationMinutes?: number;
  icon?: string;
}

