#!/usr/bin/env python3
"""
seed_data.jsonから薬剤データ（medications, medication_plans）を抽出してD1用SQLを生成するスクリプト

薬剤系のサブカテゴリは、その下の治療データをmedicationsとmedication_plansテーブルに変換します。
"""

import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Any


def escape_sql(value):
    """SQL用のエスケープ"""
    if value is None:
        return 'NULL'
    if isinstance(value, bool):
        return '1' if value else '0'
    if isinstance(value, (int, float)):
        return str(value)
    return "'" + str(value).replace("'", "''") + "'"


def extract_quantity_from_name(treatment_name: str) -> str:
    """治療名から量（quantity）を抽出（例：「ジュベルック 2cc」→「2cc」）"""
    # ccやmgなどの単位を含むパターンを抽出
    patterns = [
        r'(\d+(?:\.\d+)?)\s*(cc|mg|ml|単位)',
        r'(\d+(?:\.\d+)?)\s*(cc|mg|ml)',
    ]
    
    for pattern in patterns:
        match = re.search(pattern, treatment_name)
        if match:
            return f"{match.group(1)}{match.group(2)}"
    
    # パターンに一致しない場合は、治療名をそのまま使用
    # 例：「4cc 全顔」→「4cc 全顔」
    return treatment_name


def is_medication_category(category_name: str) -> bool:
    """薬剤系のカテゴリかどうかを判定"""
    medication_keywords = ['肌育注射', 'ヒアルロン酸', '薬剤']
    return any(keyword in category_name for keyword in medication_keywords)


def generate_medication_seed(json_path: str, output_path: str):
    """JSONから薬剤データ用SQLを生成"""
    
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    lines = [
        "-- 薬剤データ（medications, medication_plans）",
        "-- Generated from seed_data.json",
        "-- 薬剤系のサブカテゴリをmedicationsテーブルに、その下の治療データをmedication_plansテーブルに変換",
        "",
    ]
    
    medications: Dict[str, Dict[str, Any]] = {}  # medication_id -> medication_data
    medication_plans: List[Dict[str, Any]] = []
    
    # 薬剤系のカテゴリを処理
    for cat in data['categories']:
        if not is_medication_category(cat['name']):
            continue
        
        for sub in cat['subcategories']:
            # サブカテゴリ名を薬剤名として使用（例：「ジュベルック」）
            medication_name = sub['name']
            medication_id = sub['id']  # サブカテゴリIDを薬剤IDとして使用
            medication_slug = sub['slug']
            
            # 単位を推定（ccが含まれる場合は'cc'、それ以外は'cc'をデフォルト）
            unit = 'cc'  # デフォルト
            if 'mg' in medication_name.lower() or any('mg' in treat['name'] for treat in sub.get('treatments', [])):
                unit = 'mg'
            
            # 薬剤マスターを作成
            if medication_id not in medications:
                medications[medication_id] = {
                    'id': medication_id,
                    'name': medication_name,
                    'slug': medication_slug,
                    'unit': unit,
                    'description': None,
                }
            
            # サブカテゴリの下の治療データをmedication_plansに変換
            for treat in sub.get('treatments', []):
                for plan in treat.get('plans', []):
                    # 治療名から量を抽出（例：「ジュベルック 2cc」→「2cc」、「4cc 全顔」→「4cc」）
                    # まず、planのquantityを使用、なければ治療名から抽出
                    quantity = plan.get('quantity')
                    if not quantity:
                        quantity = extract_quantity_from_name(treat['name'])
                        # 治療名が「4cc 全顔」のような場合、「4cc 全顔」ではなく「4cc」だけにする
                        if quantity == treat['name']:
                            # 量を抽出できなかった場合、治療名から数値と単位を抽出
                            match = re.search(r'(\d+(?:\.\d+)?)\s*(cc|mg|ml|単位)', treat['name'])
                            if match:
                                quantity = f"{match.group(1)}{match.group(2)}"
                    
                    # medication_planを作成
                    medication_plan = {
                        'id': plan['id'],
                        'medication_id': medication_id,
                        'quantity': quantity,
                        'sessions': plan.get('sessions'),
                        'price': plan['price'],
                        'price_taxed': plan['price_taxed'],
                        'campaign_price': plan.get('campaign_price'),
                        'cost_rate': plan.get('cost_rate'),
                        'supply_cost': plan.get('supply_cost'),
                        'staff_cost': plan.get('staff_cost'),
                        'total_cost': plan.get('total_cost'),
                        'staff_discount_rate': plan.get('staff_discount_rate'),
                        'sort_order': plan.get('sort_order', 0),
                    }
                    medication_plans.append(medication_plan)
    
    # medicationsテーブルのINSERT文を生成
    lines.append("-- 薬剤マスター（medications）")
    for med in medications.values():
        lines.append(
            f"INSERT INTO medications (id, name, slug, unit, description, is_active) VALUES "
            f"({escape_sql(med['id'])}, {escape_sql(med['name'])}, {escape_sql(med['slug'])}, "
            f"{escape_sql(med['unit'])}, {escape_sql(med['description'])}, 1);"
        )
    
    lines.append("")
    lines.append("-- 薬剤プラン（medication_plans）")
    for plan in medication_plans:
        lines.append(
            f"INSERT INTO medication_plans ("
            f"id, medication_id, quantity, sessions, price, price_taxed, "
            f"campaign_price, cost_rate, supply_cost, staff_cost, total_cost, "
            f"staff_discount_rate, sort_order, is_active"
            f") VALUES ("
            f"{escape_sql(plan['id'])}, {escape_sql(plan['medication_id'])}, {escape_sql(plan['quantity'])}, "
            f"{escape_sql(plan['sessions'])}, {plan['price']}, {plan['price_taxed']}, "
            f"{escape_sql(plan['campaign_price'])}, {escape_sql(plan['cost_rate'])}, "
            f"{escape_sql(plan['supply_cost'])}, {escape_sql(plan['staff_cost'])}, {escape_sql(plan['total_cost'])}, "
            f"{escape_sql(plan['staff_discount_rate'])}, {plan['sort_order']}, 1"
            f");"
        )
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    print(f"✅ 薬剤データ用SQL生成完了: {output_path}")
    print(f"  薬剤数: {len(medications)}")
    print(f"  薬剤プラン数: {len(medication_plans)}")
    
    # 薬剤名のリストを表示
    print("\n  薬剤リスト:")
    for med in medications.values():
        plan_count = sum(1 for p in medication_plans if p['medication_id'] == med['id'])
        print(f"    - {med['name']} ({plan_count}プラン)")


if __name__ == '__main__':
    json_path = Path(__file__).parent.parent / 'database' / 'seed_data.json'
    output_path = Path(__file__).parent.parent / 'database' / 'd1' / 'seed-medications.sql'
    
    generate_medication_seed(str(json_path), str(output_path))

