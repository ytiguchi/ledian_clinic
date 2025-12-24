#!/usr/bin/env python3
"""
Generate subcategory seed SQL from YAML.
"""

import sys
import uuid
from pathlib import Path

import yaml


category_map = {
    '???': '1cd0f456-20ef-412f-b7d7-88825e9f4b51',
    '?????????': 'a7cc6290-b476-4cfc-9945-25e584bcfeab',
    '??????': '65ff9afd-f113-41de-b2ef-1b62a6198dc6',
    '???????????': '40ba48e2-383a-4054-90c3-e840c8ca0180',
    '??????': 'd53083be-d3e1-4e97-a733-6a07a5e4c436',
    '???????': 'a8fc1bc8-5ab9-45d0-a3b5-d08f0fb93a1f',
    '?????????????': 'b18b7602-59ca-4a04-97ac-d7ea854886e0',
    '????': '8d93d84e-161d-407d-a3a8-5181a7de9c7a',
    '??????': '8fdd9546-77e0-495d-83c4-132933ccb382',
    '????': 'c60302d2-66b2-49cd-81dd-d12babe22ae1',
    '????': 'd2f3ba4b-8d32-4c46-9099-51de61c3dfe6',
    '??????': 'fa8b265c-7079-469a-892e-9c1da2617cce',
    '????': 'e2be8724-0990-42be-833b-cdcc79c403e8',
    '???????': '14568540-1c28-42b9-bc6a-e39f6d062ed5',
    '????????': '23c40fde-fb4d-40a0-9bd9-1ebf7b3cee23',
    '????': '9a9e4250-7086-442e-8e9d-6f33370911ed',
    '????': '2e65bbf8-b6ec-4d0c-8312-86bcbd772f8d',
    '??': '7fb17c6b-74f0-4b43-95f5-9ec3b73c106b',
    '???': '15ccb9bb-b6eb-488f-9d11-9f9e0288ec2c',
    '????????': '638b7d4c-ec3d-495c-b703-b1c749b8155b',
    '??????': 'f8779bc2-0cd7-433e-bd8e-685ffa284df1',
    'ldm': '2c74206a-3794-4f38-a3ba-5478390cf405'
}


def escape_sql(value) -> str:
    if value is None:
        return 'NULL'
    if isinstance(value, (int, float)):
        return str(value)
    return "'" + str(value).replace("'", "''") + "'"


def load_subcategories(yaml_path: Path):
    if not yaml_path.exists():
        raise FileNotFoundError(f'YAML not found: {yaml_path}')
    with yaml_path.open('r', encoding='utf-8') as f:
        data = yaml.safe_load(f)
    if not isinstance(data, list):
        raise ValueError('YAML must contain a list of subcategories')
    return data


def build_sql(subcategories):
    lines = ['-- Subcategories seed', '']
    warnings = 0

    for i, sub in enumerate(subcategories, 1):
        if not isinstance(sub, dict):
            warnings += 1
            print(f'Warning: Invalid entry at index {i}', file=sys.stderr)
            continue

        cat_slug = sub.get('category_slug')
        if not cat_slug:
            warnings += 1
            print(f'Warning: Missing category_slug at index {i}', file=sys.stderr)
            continue

        cat_id = category_map.get(cat_slug)
        if not cat_id:
            warnings += 1
            print(f'Warning: Category not found: {cat_slug}', file=sys.stderr)
            continue

        name = sub.get('name')
        slug = sub.get('slug')
        if not name or not slug:
            warnings += 1
            print(f'Warning: Missing name/slug for {cat_slug}', file=sys.stderr)
            continue

        sub_id = str(uuid.uuid4())
        sort_order = sub.get('sort_order', i)
        is_active = 1 if sub.get('is_active', True) else 0

        lines.append(
            'INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES '
            f'({escape_sql(sub_id)}, {escape_sql(cat_id)}, {escape_sql(name)}, {escape_sql(slug)}, {sort_order}, {is_active});'
        )

    return lines, warnings


def main():
    yaml_path = Path(__file__).parent.parent / 'data' / 'catalog' / 'subcategories.yml'
    output_path = Path(__file__).parent.parent / 'database' / 'd1' / 'seed_subcategories.sql'

    try:
        subcategories = load_subcategories(yaml_path)
    except Exception as exc:
        print(f'[ERROR] {exc}', file=sys.stderr)
        sys.exit(1)

    lines, warnings = build_sql(subcategories)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')

    print('\n'.join(lines))
    print(f'\n[OK] SQL saved to: {output_path}', file=sys.stderr)
    if warnings:
        print(f'[WARN] {warnings} entries skipped', file=sys.stderr)


if __name__ == '__main__':
    main()
