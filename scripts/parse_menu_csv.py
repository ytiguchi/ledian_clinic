#!/usr/bin/env python3
"""
レディアンクリニック メニューCSV パーサー
CSV → 構造化JSON & SQL INSERT文 変換スクリプト

CSVの構造:
- col[0]: 大カテゴリ（スキンケア、医療脱毛等）
- col[1]: 小カテゴリ（フォトフェイシャル、ハイフ等）
- col[2]: 施術詳細/オプション名
- col[3]: 施術名
- col[4]: 回数・個数
- col[5]: 価格(税抜)
- col[6]: /回
- col[7]: 税込
- col[8]: 税込/回
- col[9]: 原価率
- col[10]: キャンペーン価格
- col[11]: キャンペーン原価率
- col[12]: 旧定価
- col[13]: 備品原価
- col[14]: 医師・看護師原価
- col[15]: 原価合計
- col[16]: 備考
- col[17]: 社販OFF
"""

import csv
import json
import re
import uuid
from pathlib import Path
from dataclasses import dataclass, field, asdict
from typing import Optional
from datetime import datetime


@dataclass
class TreatmentPlan:
    id: str = field(default_factory=lambda: str(uuid.uuid4()))
    plan_name: str = ""
    plan_type: str = "single"
    sessions: Optional[int] = None
    quantity: Optional[str] = None
    price: int = 0
    price_taxed: int = 0
    price_per_session: Optional[int] = None
    price_per_session_taxed: Optional[int] = None
    campaign_price: Optional[int] = None
    campaign_price_taxed: Optional[int] = None
    cost_rate: Optional[float] = None
    campaign_cost_rate: Optional[float] = None
    supply_cost: Optional[int] = None
    staff_cost: Optional[int] = None
    total_cost: Optional[int] = None
    old_price: Optional[int] = None
    staff_discount_rate: Optional[int] = None
    notes: Optional[str] = None
    sort_order: int = 0


@dataclass
class Treatment:
    id: str = field(default_factory=lambda: str(uuid.uuid4()))
    name: str = ""
    slug: str = ""
    description: Optional[str] = None
    plans: list = field(default_factory=list)
    sort_order: int = 0


@dataclass
class Subcategory:
    id: str = field(default_factory=lambda: str(uuid.uuid4()))
    name: str = ""
    slug: str = ""
    treatments: list = field(default_factory=list)
    sort_order: int = 0


@dataclass
class Category:
    id: str = field(default_factory=lambda: str(uuid.uuid4()))
    name: str = ""
    slug: str = ""
    subcategories: list = field(default_factory=list)
    sort_order: int = 0


def slugify(text: str) -> str:
    """日本語テキストをslugに変換"""
    text = text.strip().lower()
    text = re.sub(r'[　\s]+', '-', text)
    text = re.sub(r'[^\w\-]', '', text)
    return text or 'unnamed'


def parse_price(value: str) -> Optional[int]:
    """価格文字列をintに変換"""
    if not value or value.strip() in ['', '-', '#DIV/0!', '#VALUE!']:
        return None
    value = value.replace(',', '').replace('"', '').replace('+', '').strip()
    try:
        return int(float(value))
    except (ValueError, TypeError):
        return None


def parse_percentage(value: str) -> Optional[float]:
    """パーセント文字列をfloatに変換"""
    if not value or value.strip() in ['', '-', '#DIV/0!', '#VALUE!']:
        return None
    value = value.replace('%', '').replace(',', '').strip()
    try:
        return float(value)
    except (ValueError, TypeError):
        return None


def parse_discount(value: str) -> Optional[int]:
    """割引率を抽出"""
    if not value:
        return None
    match = re.search(r'(\d+)\s*[%％]', value)
    if match:
        return int(match.group(1))
    return None


def determine_plan_type(plan_name: str, sessions: Optional[int]) -> str:
    """プラン名から種別を判定"""
    plan_name_lower = plan_name.lower()
    if '初回' in plan_name or 'お試し' in plan_name:
        return 'trial'
    if 'モニター' in plan_name:
        return 'monitor'
    if 'キャンペーン' in plan_name:
        return 'campaign'
    if sessions and sessions > 1:
        return 'course'
    return 'single'


def parse_sessions(value: str) -> tuple[Optional[int], Optional[str]]:
    """回数・個数をパース"""
    if not value:
        return None, None
    
    value = value.strip()
    
    # 回数パターン
    match = re.search(r'(\d+)\s*回', value)
    if match:
        return int(match.group(1)), None
    
    # 個数パターン
    match = re.search(r'(\d+)\s*(cc|単位|T|S|mg|本|個|箇所)', value, re.IGNORECASE)
    if match:
        return None, f"{match.group(1)}{match.group(2)}"
    
    # ショットパターン
    match = re.search(r'(\d+)\s*(SHOT|ショット)', value, re.IGNORECASE)
    if match:
        return None, f"{match.group(1)}SHOT"
    
    return None, value if value else None


def is_skip_row(row: list) -> bool:
    """スキップすべき行かどうか判定"""
    # 全て空
    if not any(cell.strip() for cell in row[:8]):
        return True
    
    # コメント行（※で始まる）
    for cell in row[:4]:
        cell = cell.strip()
        if cell and cell.startswith('※'):
            return True
    
    return False


def get_safe(row: list, idx: int) -> str:
    """安全にrowから値を取得"""
    if idx < len(row):
        return row[idx].strip()
    return ""


def parse_csv(csv_path: str) -> list[Category]:
    """CSVをパースして構造化データに変換"""
    
    categories: dict[str, Category] = {}
    
    # 現在の状態を保持
    current_category = ""
    current_subcategory = ""
    current_treatment = ""
    
    category_order = 0
    subcategory_order = 0
    treatment_order = 0
    plan_order = 0
    
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        
        # ヘッダー行をスキップ（1行 - CSVは改行を含むフィールドがあるため）
        next(reader, None)
        
        for row_num, row in enumerate(reader, start=4):
            if len(row) < 6:
                continue
            
            # スキップ判定
            if is_skip_row(row):
                continue
            
            # カラム抽出
            col_category = get_safe(row, 0)      # 大カテゴリ
            col_subcategory = get_safe(row, 1)   # 小カテゴリ
            col_detail = get_safe(row, 2)        # 施術詳細
            col_treatment = get_safe(row, 3)     # 施術名
            col_sessions = get_safe(row, 4)      # 回数・個数
            col_price = get_safe(row, 5)         # 価格(税抜)
            col_price_per = get_safe(row, 6)     # /回
            col_price_taxed = get_safe(row, 7)   # 税込
            col_price_per_taxed = get_safe(row, 8)  # 税込/回
            col_cost_rate = get_safe(row, 9)     # 原価率
            col_campaign = get_safe(row, 10)     # キャンペーン価格
            col_campaign_rate = get_safe(row, 11)  # キャンペーン原価率
            col_old_price = get_safe(row, 12)    # 旧定価
            col_supply_cost = get_safe(row, 13)  # 備品原価
            col_staff_cost = get_safe(row, 14)   # 医師・看護師原価
            col_total_cost = get_safe(row, 15)   # 原価合計
            col_notes = get_safe(row, 16)        # 備考
            col_discount = get_safe(row, 17)     # 社販OFF
            
            # ========================================
            # カテゴリ処理
            # ========================================
            if col_category:
                # 無効なカテゴリ名をスキップ
                if col_category.startswith('※') or '割引' in col_category or 'OFF' in col_category.upper():
                    continue
                
                current_category = col_category
                current_subcategory = ""
                current_treatment = ""
                subcategory_order = 0
                
                if current_category not in categories:
                    category_order += 1
                    categories[current_category] = Category(
                        name=current_category,
                        slug=slugify(current_category),
                        sort_order=category_order
                    )
            
            if not current_category:
                continue
            
            category = categories[current_category]
            
            # ========================================
            # サブカテゴリ処理
            # ========================================
            if col_subcategory:
                # 無効なサブカテゴリ名をスキップ
                if col_subcategory.startswith('※') or '×' in col_subcategory:
                    pass
                else:
                    if col_subcategory != current_subcategory:
                        current_subcategory = col_subcategory
                        current_treatment = ""
                        subcategory_order += 1
                        treatment_order = 0
                        
                        # 既存のサブカテゴリを探す
                        existing = next(
                            (sc for sc in category.subcategories if sc.name == current_subcategory),
                            None
                        )
                        if not existing:
                            new_sub = Subcategory(
                                name=current_subcategory,
                                slug=slugify(current_subcategory),
                                sort_order=subcategory_order
                            )
                            category.subcategories.append(new_sub)
            
            # サブカテゴリがない場合、カテゴリ名をデフォルトとして使用
            if not current_subcategory:
                current_subcategory = current_category
                existing = next(
                    (sc for sc in category.subcategories if sc.name == current_subcategory),
                    None
                )
                if not existing:
                    subcategory_order += 1
                    new_sub = Subcategory(
                        name=current_subcategory,
                        slug=slugify(current_subcategory),
                        sort_order=subcategory_order
                    )
                    category.subcategories.append(new_sub)
            
            subcategory = next(
                (sc for sc in category.subcategories if sc.name == current_subcategory),
                None
            )
            if not subcategory:
                continue
            
            # ========================================
            # 施術名の決定
            # ========================================
            # 優先順位: col_treatment > col_detail > current_treatment
            treatment_name = col_treatment if col_treatment else col_detail
            if not treatment_name:
                treatment_name = current_treatment
            if not treatment_name:
                treatment_name = current_subcategory
            
            # ========================================
            # 価格チェック
            # ========================================
            price = parse_price(col_price)
            if price is None:
                # 価格がない行はスキップ（コメント行など）
                continue
            
            # ========================================
            # 施術の取得または作成
            # ========================================
            if treatment_name != current_treatment:
                current_treatment = treatment_name
                treatment_order += 1
                plan_order = 0
                
                existing_treatment = next(
                    (t for t in subcategory.treatments if t.name == current_treatment),
                    None
                )
                if not existing_treatment:
                    new_treatment = Treatment(
                        name=current_treatment,
                        slug=slugify(current_treatment),
                        sort_order=treatment_order
                    )
                    subcategory.treatments.append(new_treatment)
            
            treatment = next(
                (t for t in subcategory.treatments if t.name == current_treatment),
                None
            )
            if not treatment:
                continue
            
            # ========================================
            # プラン作成
            # ========================================
            sessions, quantity = parse_sessions(col_sessions)
            plan_name = col_sessions if col_sessions else "1回"
            plan_order += 1
            
            campaign_price = parse_price(col_campaign)
            
            plan = TreatmentPlan(
                plan_name=plan_name,
                plan_type=determine_plan_type(plan_name, sessions),
                sessions=sessions,
                quantity=quantity,
                price=price,
                price_taxed=parse_price(col_price_taxed) or int(price * 1.1),
                price_per_session=parse_price(col_price_per),
                price_per_session_taxed=parse_price(col_price_per_taxed),
                campaign_price=campaign_price,
                campaign_price_taxed=int(campaign_price * 1.1) if campaign_price else None,
                cost_rate=parse_percentage(col_cost_rate),
                campaign_cost_rate=parse_percentage(col_campaign_rate),
                supply_cost=parse_price(col_supply_cost),
                staff_cost=parse_price(col_staff_cost),
                total_cost=parse_price(col_total_cost),
                old_price=parse_price(col_old_price),
                staff_discount_rate=parse_discount(col_discount),
                notes=col_notes if col_notes else None,
                sort_order=plan_order
            )
            
            treatment.plans.append(plan)
    
    return list(categories.values())


def to_dict(obj) -> dict:
    """dataclassを再帰的にdictに変換"""
    if hasattr(obj, '__dataclass_fields__'):
        return {k: to_dict(v) for k, v in asdict(obj).items()}
    elif isinstance(obj, list):
        return [to_dict(item) for item in obj]
    elif isinstance(obj, dict):
        return {k: to_dict(v) for k, v in obj.items()}
    return obj


def generate_json(categories: list[Category], output_path: str):
    """JSONファイル出力"""
    data = {
        "generated_at": datetime.now().isoformat(),
        "categories": [to_dict(cat) for cat in categories]
    }
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"✅ JSON出力: {output_path}")


def escape_sql(value: str) -> str:
    """SQLエスケープ"""
    if value is None:
        return 'NULL'
    return "'" + str(value).replace("'", "''") + "'"


def generate_sql(categories: list[Category], output_path: str):
    """SQLインサート文出力"""
    
    lines = [
        "-- ============================================",
        "-- レディアンクリニック シードデータ",
        f"-- Generated: {datetime.now().isoformat()}",
        "-- ============================================",
        "",
        "BEGIN;",
        "",
        "-- カテゴリ",
    ]
    
    for cat in categories:
        lines.append(
            f"INSERT INTO categories (id, name, slug, sort_order) VALUES "
            f"({escape_sql(cat.id)}, {escape_sql(cat.name)}, {escape_sql(cat.slug)}, {cat.sort_order});"
        )
    
    lines.append("")
    lines.append("-- サブカテゴリ")
    
    for cat in categories:
        for sub in cat.subcategories:
            lines.append(
                f"INSERT INTO subcategories (id, category_id, name, slug, sort_order) VALUES "
                f"({escape_sql(sub.id)}, {escape_sql(cat.id)}, {escape_sql(sub.name)}, {escape_sql(sub.slug)}, {sub.sort_order});"
            )
    
    lines.append("")
    lines.append("-- 施術")
    
    for cat in categories:
        for sub in cat.subcategories:
            for treat in sub.treatments:
                lines.append(
                    f"INSERT INTO treatments (id, subcategory_id, name, slug, sort_order) VALUES "
                    f"({escape_sql(treat.id)}, {escape_sql(sub.id)}, {escape_sql(treat.name)}, {escape_sql(treat.slug)}, {treat.sort_order});"
                )
    
    lines.append("")
    lines.append("-- 料金プラン")
    
    for cat in categories:
        for sub in cat.subcategories:
            for treat in sub.treatments:
                for plan in treat.plans:
                    sessions = plan.sessions if plan.sessions else 'NULL'
                    quantity = escape_sql(plan.quantity) if plan.quantity else 'NULL'
                    price_per = plan.price_per_session if plan.price_per_session else 'NULL'
                    price_per_taxed = plan.price_per_session_taxed if plan.price_per_session_taxed else 'NULL'
                    campaign = plan.campaign_price if plan.campaign_price else 'NULL'
                    campaign_taxed = plan.campaign_price_taxed if plan.campaign_price_taxed else 'NULL'
                    cost_rate = plan.cost_rate if plan.cost_rate else 'NULL'
                    campaign_rate = plan.campaign_cost_rate if plan.campaign_cost_rate else 'NULL'
                    supply = plan.supply_cost if plan.supply_cost else 'NULL'
                    staff = plan.staff_cost if plan.staff_cost else 'NULL'
                    total = plan.total_cost if plan.total_cost else 'NULL'
                    old = plan.old_price if plan.old_price else 'NULL'
                    discount = plan.staff_discount_rate if plan.staff_discount_rate else 'NULL'
                    notes = escape_sql(plan.notes) if plan.notes else 'NULL'
                    
                    lines.append(
                        f"INSERT INTO treatment_plans "
                        f"(id, treatment_id, plan_name, plan_type, sessions, quantity, "
                        f"price, price_taxed, price_per_session, price_per_session_taxed, "
                        f"campaign_price, campaign_price_taxed, cost_rate, campaign_cost_rate, "
                        f"supply_cost, staff_cost, total_cost, old_price, staff_discount_rate, notes, sort_order) VALUES "
                        f"({escape_sql(plan.id)}, {escape_sql(treat.id)}, {escape_sql(plan.plan_name)}, "
                        f"{escape_sql(plan.plan_type)}, {sessions}, {quantity}, "
                        f"{plan.price}, {plan.price_taxed}, {price_per}, {price_per_taxed}, "
                        f"{campaign}, {campaign_taxed}, {cost_rate}, {campaign_rate}, "
                        f"{supply}, {staff}, {total}, {old}, {discount}, {notes}, {plan.sort_order});"
                    )
    
    lines.append("")
    lines.append("COMMIT;")
    lines.append("")
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    print(f"✅ SQL出力: {output_path}")


def print_summary(categories: list[Category]):
    """サマリー表示"""
    print("\n📊 パース結果サマリー")
    print("=" * 60)
    
    total_subcategories = 0
    total_treatments = 0
    total_plans = 0
    
    for cat in categories:
        cat_subcategories = len(cat.subcategories)
        cat_treatments = sum(len(sub.treatments) for sub in cat.subcategories)
        cat_plans = sum(
            len(t.plans) for sub in cat.subcategories for t in sub.treatments
        )
        total_subcategories += cat_subcategories
        total_treatments += cat_treatments
        total_plans += cat_plans
        
        print(f"\n📁 {cat.name}")
        for sub in cat.subcategories[:5]:  # 最初の5つのみ表示
            sub_treatments = len(sub.treatments)
            sub_plans = sum(len(t.plans) for t in sub.treatments)
            print(f"   └─ {sub.name}: {sub_treatments}施術, {sub_plans}プラン")
        if len(cat.subcategories) > 5:
            print(f"   └─ ... 他{len(cat.subcategories) - 5}サブカテゴリ")
    
    print("\n" + "=" * 60)
    print(f"✨ 合計: {len(categories)}カテゴリ, {total_subcategories}サブカテゴリ, {total_treatments}施術, {total_plans}プラン")


def main():
    # パス設定
    script_dir = Path(__file__).parent
    project_dir = script_dir.parent
    
    csv_path = Path.home() / "Desktop" / "レディアンクリニックメニュー表 - メニュー一覧.csv"
    json_output = project_dir / "database" / "seed_data.json"
    sql_output = project_dir / "database" / "seed.sql"
    
    if not csv_path.exists():
        print(f"❌ CSVファイルが見つかりません: {csv_path}")
        return
    
    print(f"📄 CSVファイル読み込み: {csv_path}")
    
    # パース実行
    categories = parse_csv(str(csv_path))
    
    # サマリー表示
    print_summary(categories)
    
    # 出力
    json_output.parent.mkdir(parents=True, exist_ok=True)
    generate_json(categories, str(json_output))
    generate_sql(categories, str(sql_output))
    
    print("\n✨ 完了！")


if __name__ == "__main__":
    main()
