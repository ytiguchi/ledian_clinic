#!/usr/bin/env python3
"""
seed_data.jsonからD1用のSQLを生成するスクリプト
"""

import io
import json
import sys
from pathlib import Path


# Windows cp932 encoding fix
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

def escape_sql(value):
    """SQL用のエスケープ"""
    if value is None:
        return 'NULL'
    if isinstance(value, bool):
        return '1' if value else '0'
    if isinstance(value, (int, float)):
        return str(value)
    return "'" + str(value).replace("'", "''") + "'"


def generate_d1_seed(json_path: str, output_path: str):
    """JSONからD1用SQLを生成"""
    
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    lines = [
        "-- D1用シードデータ",
        "-- Generated from seed_data.json",
        "",
    ]
    
    # カテゴリ
    lines.append("-- カテゴリ")
    for cat in data['categories']:
        lines.append(
            f"INSERT INTO categories (id, name, slug, sort_order, is_active) VALUES "
            f"({escape_sql(cat['id'])}, {escape_sql(cat['name'])}, {escape_sql(cat['slug'])}, {cat.get('sort_order', 0)}, 1);"
        )
    
    lines.append("")
    lines.append("-- サブカテゴリ")
    for cat in data['categories']:
        for sub in cat['subcategories']:
            lines.append(
                f"INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES "
                f"({escape_sql(sub['id'])}, {escape_sql(cat['id'])}, {escape_sql(sub['name'])}, {escape_sql(sub['slug'])}, {sub.get('sort_order', 0)}, 1);"
            )
    
    lines.append("")
    lines.append("-- 施術")
    for cat in data['categories']:
        for sub in cat['subcategories']:
            for treat in sub['treatments']:
                description = treat.get('description')
                lines.append(
                    f"INSERT INTO treatments (id, subcategory_id, name, slug, description, sort_order, is_active) VALUES "
                    f"({escape_sql(treat['id'])}, {escape_sql(sub['id'])}, {escape_sql(treat['name'])}, {escape_sql(treat['slug'])}, {escape_sql(description)}, {treat.get('sort_order', 0)}, 1);"
                )
    
    lines.append("")
    lines.append("-- 料金プラン")
    for cat in data['categories']:
        for sub in cat['subcategories']:
            for treat in sub['treatments']:
                for plan in treat.get('plans', []):
                    lines.append(
                        f"INSERT INTO treatment_plans ("
                        f"id, treatment_id, plan_name, plan_type, sessions, quantity, "
                        f"price, price_taxed, price_per_session, price_per_session_taxed, "
                        f"campaign_price, campaign_price_taxed, cost_rate, supply_cost, staff_cost, total_cost, sort_order, is_active"
                        f") VALUES ("
                        f"{escape_sql(plan['id'])}, {escape_sql(treat['id'])}, {escape_sql(plan['plan_name'])}, "
                        f"{escape_sql(plan['plan_type'])}, {escape_sql(plan.get('sessions'))}, {escape_sql(plan.get('quantity'))}, "
                        f"{plan['price']}, {plan['price_taxed']}, {escape_sql(plan.get('price_per_session'))}, {escape_sql(plan.get('price_per_session_taxed'))}, "
                        f"{escape_sql(plan.get('campaign_price'))}, {escape_sql(plan.get('campaign_price_taxed'))}, {escape_sql(plan.get('cost_rate'))}, "
                        f"{escape_sql(plan.get('supply_cost'))}, {escape_sql(plan.get('staff_cost'))}, {escape_sql(plan.get('total_cost'))}, "
                        f"{plan.get('sort_order', 0)}, 1"
                        f");"
                    )
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    print(f"OK D1用SQL生成完了: {output_path}")
    
    # 統計情報
    cat_count = len(data['categories'])
    sub_count = sum(len(cat['subcategories']) for cat in data['categories'])
    treat_count = sum(len(sub['treatments']) for cat in data['categories'] for sub in cat['subcategories'])
    plan_count = sum(len(treat.get('plans', [])) for cat in data['categories'] for sub in cat['subcategories'] for treat in sub['treatments'])
    
    print(f"  カテゴリ: {cat_count}")
    print(f"  サブカテゴリ: {sub_count}")
    print(f"  施術: {treat_count}")
    print(f"  料金プラン: {plan_count}")


if __name__ == '__main__':
    json_path = Path(__file__).parent.parent / 'database' / 'seed_data.json'
    output_path = Path(__file__).parent.parent / 'database' / 'd1' / 'seed-all.sql'
    
    generate_d1_seed(str(json_path), str(output_path))

