#!/usr/bin/env python3
"""
Ledian Clinic menu CSV parser.
Builds 4-tier structure: Category -> Subcategory -> Treatment -> Plan.
"""

import sys
import io

# Windows cp932 encoding fix
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

import csv
import json
import re
import uuid
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Optional


PUNCT_RE = re.compile(r"[\s\u3000/()?????,??!???:?;?\[\]{}]+")
NON_WORD_RE = re.compile(r"[^\w\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF-]")
MULTI_DASH_RE = re.compile(r"-+")


def generate_uuid() -> str:
    return str(uuid.uuid4())


def slugify(text: str) -> str:
    if not text:
        return ""
    slug = text.lower().strip()
    slug = PUNCT_RE.sub("-", slug)
    slug = NON_WORD_RE.sub("", slug)
    slug = MULTI_DASH_RE.sub("-", slug)
    return slug.strip("-")


def parse_int(value: Optional[str]) -> Optional[int]:
    if value is None:
        return None
    s = str(value).strip()
    if s == "":
        return None
    s = re.sub(r"[,\s]", "", s)
    try:
        return int(float(s))
    except (ValueError, TypeError):
        return None


def parse_percent_float(value: Optional[str]) -> Optional[float]:
    if value is None:
        return None
    s = str(value).strip()
    if s == "" or s == "#DIV/0!":
        return None
    s = re.sub(r"[%\s]", "", s)
    try:
        return float(s)
    except (ValueError, TypeError):
        return None


def parse_percent_int(value: Optional[str]) -> Optional[int]:
    if value is None:
        return None
    s = str(value).strip()
    if s == "" or s == "-":
        return None
    s = re.sub(r"[%\s]", "", s)
    try:
        return int(float(s))
    except (ValueError, TypeError):
        return None


@dataclass
class TreatmentPlan:
    id: str
    treatment_id: str
    plan_name: str
    plan_type: str = "single"
    sessions: int = 1
    quantity: Optional[str] = None
    price: int = 0
    price_taxed: int = 0
    price_per_session: Optional[int] = None
    price_per_session_taxed: Optional[int] = None
    supply_cost: int = 0
    labor_cost: int = 0
    total_cost: int = 0
    cost_rate: Optional[float] = None
    staff_discount_rate: Optional[int] = None
    staff_price: Optional[int] = None
    old_price: Optional[int] = None
    old_price_taxed: Optional[int] = None
    campaign_price: Optional[int] = None
    campaign_price_taxed: Optional[int] = None
    campaign_cost_rate: Optional[float] = None
    notes: Optional[str] = None
    sort_order: int = 0
    is_active: int = 1
    is_public: int = 1


@dataclass
class Treatment:
    id: str
    subcategory_id: str
    name: str
    slug: str
    description: Optional[str] = None
    target_area: Optional[str] = None
    sort_order: int = 0
    is_active: int = 1
    is_public: int = 1
    plans: list = field(default_factory=list)


@dataclass
class Subcategory:
    id: str
    category_id: str
    name: str
    slug: str
    description: Optional[str] = None
    device_name: Optional[str] = None
    sort_order: int = 0
    is_active: int = 1
    is_public: int = 1
    treatments: list = field(default_factory=list)


@dataclass
class Category:
    id: str
    name: str
    slug: str
    description: Optional[str] = None
    sort_order: int = 0
    is_active: int = 1
    is_public: int = 1
    subcategories: list = field(default_factory=list)


def determine_plan_type(sessions_str: Optional[str]) -> tuple[str, int, Optional[str]]:
    if not sessions_str:
        return "single", 1, None

    s = sessions_str.strip()

    if "??" in s or "???" in s:
        return "trial", 1, None

    if "????" in s:
        match = re.search(r"(\d+)?", s)
        if match:
            return "monitor", int(match.group(1)), None
        return "monitor", 1, None

    match = re.search(r"^(\d+)?", s)
    if match:
        sessions = int(match.group(1))
        if sessions > 1:
            return "course", sessions, None
        return "single", 1, None

    match = re.search(r"^(\d+)?", s)
    if match:
        return "single", 1, f"{match.group(1)}?"

    match = re.search(r"^(\d+)?", s)
    if match:
        return "single", 1, f"{match.group(1)}?"

    match = re.search(r"^(\d+)S", s, re.IGNORECASE)
    if match:
        return "single", 1, f"{match.group(1)}S"

    match = re.search(r"(\d+)cc", s, re.IGNORECASE)
    if match:
        return "single", 1, f"{match.group(1)}cc"

    match = re.search(r"(\d+)??", s)
    if match:
        return "single", 1, f"{match.group(1)}??"

    if "????" in s or "????" in s:
        return "single", 1, s

    return "single", 1, s if s else None


def parse_csv(csv_path: str) -> list[Category]:
    categories: dict[str, Category] = {}
    subcategory_map: dict[str, Subcategory] = {}
    treatment_map: dict[str, Treatment] = {}

    with open(csv_path, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.reader(f)
        next(reader, None)
        next(reader, None)

        category_order = 0
        subcategory_orders: dict[str, int] = {}
        treatment_orders: dict[str, int] = {}
        plan_orders: dict[str, int] = {}

        current_cat_name = None
        current_subcat_name = None
        current_treat_name = None

        for row in reader:
            if len(row) < 8:
                continue

            cat_name = row[0].strip() if row[0] else None
            subcat_name = row[1].strip() if row[1] else None
            treat_name = row[2].strip() if row[2] else None
            description = row[3].strip() if len(row) > 3 and row[3] else None
            sessions_str = row[4].strip() if len(row) > 4 and row[4] else None
            price_str = row[5] if len(row) > 5 else None
            price_per_str = row[6] if len(row) > 6 else None
            price_taxed_str = row[7] if len(row) > 7 else None
            price_per_taxed_str = row[8] if len(row) > 8 else None
            cost_rate_str = row[9] if len(row) > 9 else None
            campaign_price_str = row[10] if len(row) > 10 else None
            campaign_rate_str = row[11] if len(row) > 11 else None
            old_price_str = row[12] if len(row) > 12 else None
            supply_cost_str = row[13] if len(row) > 13 else None
            labor_cost_str = row[14] if len(row) > 14 else None
            total_cost_str = row[15] if len(row) > 15 else None
            notes_str = row[16] if len(row) > 16 else None
            staff_discount_str = row[17] if len(row) > 17 else None

            if not cat_name and not subcat_name and not treat_name and not sessions_str:
                continue

            price = parse_int(price_str)
            price_taxed = parse_int(price_taxed_str)
            if price is None and price_taxed is None:
                continue

            if cat_name:
                current_cat_name = cat_name
                if cat_name not in categories:
                    category_order += 1
                    categories[cat_name] = Category(
                        id=generate_uuid(),
                        name=cat_name,
                        slug=slugify(cat_name),
                        sort_order=category_order,
                    )
                    subcategory_orders[cat_name] = 0

            if not current_cat_name:
                continue

            category = categories[current_cat_name]

            effective_subcat_name = subcat_name if subcat_name else current_cat_name
            if effective_subcat_name:
                current_subcat_name = effective_subcat_name
                subcat_key = f"{current_cat_name}|{effective_subcat_name}"

                if subcat_key not in subcategory_map:
                    subcategory_orders[current_cat_name] = subcategory_orders.get(current_cat_name, 0) + 1
                    new_sub = Subcategory(
                        id=generate_uuid(),
                        category_id=category.id,
                        name=effective_subcat_name,
                        slug=slugify(effective_subcat_name),
                        device_name=subcat_name if subcat_name else None,
                        sort_order=subcategory_orders[current_cat_name],
                    )
                    category.subcategories.append(new_sub)
                    subcategory_map[subcat_key] = new_sub
                    treatment_orders[subcat_key] = 0

            if not current_subcat_name:
                continue

            subcat_key = f"{current_cat_name}|{current_subcat_name}"
            if subcat_key not in subcategory_map:
                continue

            subcategory = subcategory_map[subcat_key]

            if treat_name:
                actual_treat_name = treat_name
            elif description:
                actual_treat_name = description
                description = None
            else:
                actual_treat_name = sessions_str if sessions_str else "??"

            if actual_treat_name != current_treat_name:
                current_treat_name = actual_treat_name

            treat_key = f"{subcat_key}|{actual_treat_name}"
            treatment = treatment_map.get(treat_key)

            if not treatment:
                treatment_orders[subcat_key] += 1
                treatment = Treatment(
                    id=generate_uuid(),
                    subcategory_id=subcategory.id,
                    name=actual_treat_name,
                    slug=slugify(actual_treat_name),
                    description=description,
                    sort_order=treatment_orders[subcat_key],
                )
                subcategory.treatments.append(treatment)
                treatment_map[treat_key] = treatment
                plan_orders[treat_key] = 0

            plan_orders[treat_key] = plan_orders.get(treat_key, 0) + 1

            plan_type, sessions, quantity = determine_plan_type(sessions_str)

            if sessions_str:
                plan_name = sessions_str
            elif description:
                plan_name = description
            else:
                plan_name = "1?"

            plan = TreatmentPlan(
                id=generate_uuid(),
                treatment_id=treatment.id,
                plan_name=plan_name,
                plan_type=plan_type,
                sessions=sessions,
                quantity=quantity,
                price=price or 0,
                price_taxed=price_taxed or 0,
                price_per_session=parse_int(price_per_str),
                price_per_session_taxed=parse_int(price_per_taxed_str),
                supply_cost=parse_int(supply_cost_str) or 0,
                labor_cost=parse_int(labor_cost_str) or 0,
                total_cost=parse_int(total_cost_str) or 0,
                cost_rate=parse_percent_float(cost_rate_str),
                staff_discount_rate=parse_percent_int(staff_discount_str),
                old_price=parse_int(old_price_str),
                campaign_price=parse_int(campaign_price_str),
                campaign_cost_rate=parse_percent_float(campaign_rate_str),
                notes=notes_str.strip() if notes_str else None,
                sort_order=plan_orders[treat_key],
            )

            if plan.staff_discount_rate and plan.price_taxed:
                plan.staff_price = int(plan.price_taxed * plan.staff_discount_rate / 100)

            treatment.plans.append(plan)

    return list(categories.values())


def escape_sql(value) -> str:
    if value is None:
        return "NULL"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, bool):
        return "1" if value else "0"
    return "'" + str(value).replace("'", "''") + "'"


def generate_sql(categories: list[Category], output_path: str):
    lines = [
        "-- ============================================",
        "-- Ledian Clinic seed data v3",
        f"-- Generated: {datetime.now().isoformat()}",
        "-- Category -> Subcategory unique",
        "-- ============================================",
        "",
        "-- Clear existing data",
        "DELETE FROM treatment_plans;",
        "DELETE FROM treatments;",
        "DELETE FROM subcategories;",
        "DELETE FROM categories;",
        "",
    ]

    lines.append("-- Categories")
    for cat in categories:
        lines.append(
            "INSERT INTO categories (id, name, slug, sort_order, is_active, is_public) VALUES "
            f"({escape_sql(cat.id)}, {escape_sql(cat.name)}, {escape_sql(cat.slug)}, {cat.sort_order}, 1, 1);"
        )

    lines.append("")
    lines.append("-- Subcategories")
    for cat in categories:
        for sub in cat.subcategories:
            lines.append(
                "INSERT INTO subcategories (id, category_id, name, slug, device_name, sort_order, is_active, is_public) VALUES "
                f"({escape_sql(sub.id)}, {escape_sql(cat.id)}, {escape_sql(sub.name)}, {escape_sql(sub.slug)}, "
                f"{escape_sql(sub.device_name)}, {sub.sort_order}, 1, 1);"
            )

    lines.append("")
    lines.append("-- Treatments")
    for cat in categories:
        for sub in cat.subcategories:
            for treat in sub.treatments:
                lines.append(
                    "INSERT INTO treatments (id, subcategory_id, name, slug, description, sort_order, is_active, is_public) VALUES "
                    f"({escape_sql(treat.id)}, {escape_sql(sub.id)}, {escape_sql(treat.name)}, {escape_sql(treat.slug)}, "
                    f"{escape_sql(treat.description)}, {treat.sort_order}, 1, 1);"
                )

    lines.append("")
    lines.append("-- Treatment plans")
    for cat in categories:
        for sub in cat.subcategories:
            for treat in sub.treatments:
                for plan in treat.plans:
                    lines.append(
                        "INSERT INTO treatment_plans ("
                        "id, treatment_id, plan_name, plan_type, sessions, quantity, "
                        "price, price_taxed, price_per_session, price_per_session_taxed, "
                        "supply_cost, labor_cost, total_cost, cost_rate, "
                        "staff_discount_rate, staff_price, old_price, notes, sort_order, is_active, is_public"
                        ") VALUES ("
                        f"{escape_sql(plan.id)}, {escape_sql(plan.treatment_id)}, {escape_sql(plan.plan_name)}, "
                        f"{escape_sql(plan.plan_type)}, {plan.sessions}, {escape_sql(plan.quantity)}, "
                        f"{plan.price}, {plan.price_taxed}, {escape_sql(plan.price_per_session)}, {escape_sql(plan.price_per_session_taxed)}, "
                        f"{plan.supply_cost}, {plan.labor_cost}, {plan.total_cost}, {escape_sql(plan.cost_rate)}, "
                        f"{escape_sql(plan.staff_discount_rate)}, {escape_sql(plan.staff_price)}, {escape_sql(plan.old_price)}, "
                        f"{escape_sql(plan.notes)}, {plan.sort_order}, 1, 1);"
                    )

    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"[OK] SQL: {output_path}")


def generate_json(categories: list[Category], output_path: str):
    def to_dict(obj):
        if hasattr(obj, "__dict__"):
            return {k: to_dict(v) for k, v in obj.__dict__.items()}
        if isinstance(obj, list):
            return [to_dict(i) for i in obj]
        return obj

    data = [to_dict(cat) for cat in categories]

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"[OK] JSON: {output_path}")


def print_tree(categories: list[Category]):
    print("\n" + "=" * 70)
    print("4-tier structure: Category -> Subcategory -> Treatment -> Plan")
    print("=" * 70)

    total_sub = 0
    total_treat = 0
    total_plan = 0

    for cat in categories:
        sub_count = len(cat.subcategories)
        treat_count = sum(len(sub.treatments) for sub in cat.subcategories)
        plan_count = sum(
            len(treat.plans)
            for sub in cat.subcategories
            for treat in sub.treatments
        )

        total_sub += sub_count
        total_treat += treat_count
        total_plan += plan_count

        print(f"\n[{cat.sort_order}] {cat.name}")

        for sub in cat.subcategories:
            print(f"  +-- {sub.name}")
            for treat in sub.treatments[:3]:
                plan_summary = ", ".join([p.plan_name for p in treat.plans[:3]])
                if len(treat.plans) > 3:
                    plan_summary += f" (+{len(treat.plans) - 3})"
                print(f"      +-- {treat.name}: [{plan_summary}]")
            if len(sub.treatments) > 3:
                print(f"      +-- ... ({len(sub.treatments) - 3} more)")

    print("\n" + "=" * 70)
    print(f"Total: {len(categories)} categories, {total_sub} subcategories,")
    print(f"       {total_treat} treatments, {total_plan} plans")
    print("=" * 70)


def main():
    import sys

    csv_path = Path(__file__).parent.parent / "data" / "raw" / "menu.csv"
    if len(sys.argv) > 1:
        csv_path = Path(sys.argv[1])

    if not csv_path.exists():
        print(f"[ERROR] CSV not found: {csv_path}")
        sys.exit(1)

    print(f"[INFO] CSV: {csv_path}")

    categories = parse_csv(str(csv_path))
    print_tree(categories)

    output_dir = Path(__file__).parent.parent / "database" / "d1"
    output_dir.mkdir(parents=True, exist_ok=True)

    sql_path = output_dir / "seed_menu_v3.sql"
    json_path = output_dir / "seed_menu_v3.json"

    generate_sql(categories, str(sql_path))
    generate_json(categories, str(json_path))

    print("\n[DONE]")


if __name__ == "__main__":
    main()

