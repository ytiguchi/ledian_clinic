#!/usr/bin/env python3
"""D1データベースにシードデータを投入するスクリプト"""
import subprocess
import sys
import time

def run_command(cmd):
    """コマンドを実行"""
    print(f"実行中: {cmd[:100]}...")
    result = subprocess.run(
        cmd,
        shell=True,
        capture_output=True,
        text=True,
        timeout=30
    )
    if result.returncode != 0:
        print(f"エラー: {result.stderr}")
        return False
    return True

def main():
    config_file = "wrangler.internal.toml"
    db_name = "ledian-internal-prod"
    
    # シードファイルを分割
    seed_file = "database/seed_d1_ignore.sql"
    
    print("📊 シードデータを分割して投入します...")
    
    # 1. カテゴリ
    print("\n1. カテゴリを投入中...")
    cmd = f"grep '^INSERT.*categories' {seed_file} | head -n 25"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.stdout:
        for line in result.stdout.strip().split('\n'):
            if line.strip():
                cmd = f"npx wrangler@4.56.0 d1 execute {db_name} --config {config_file} --local --command \"{line}\""
                if not run_command(cmd):
                    print(f"失敗: {line[:50]}")
                    return
        print("✅ カテゴリ投入完了")
    
    # 2. サブカテゴリ
    print("\n2. サブカテゴリを投入中...")
    cmd = f"grep '^INSERT.*subcategories' {seed_file} | head -n 50"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.stdout:
        for line in result.stdout.strip().split('\n'):
            if line.strip():
                cmd = f"npx wrangler@4.56.0 d1 execute {db_name} --config {config_file} --local --command \"{line}\""
                if not run_command(cmd):
                    print(f"失敗: {line[:50]}")
                    return
        print("✅ サブカテゴリ投入完了")
    
    # 3. 施術
    print("\n3. 施術を投入中...")
    cmd = f"grep '^INSERT.*treatments' {seed_file} | head -n 50"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.stdout:
        for line in result.stdout.strip().split('\n'):
            if line.strip():
                cmd = f"npx wrangler@4.56.0 d1 execute {db_name} --config {config_file} --local --command \"{line}\""
                if not run_command(cmd):
                    print(f"失敗: {line[:50]}")
                    return
        print("✅ 施術投入完了")
    
    # 4. プラン（最初の50件のみ）
    print("\n4. プランを投入中（最初の50件）...")
    cmd = f"grep '^INSERT.*treatment_plans' {seed_file} | head -n 50"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.stdout:
        for line in result.stdout.strip().split('\n'):
            if line.strip():
                cmd = f"npx wrangler@4.56.0 d1 execute {db_name} --config {config_file} --local --command \"{line}\""
                if not run_command(cmd):
                    print(f"失敗: {line[:50]}")
                    return
        print("✅ プラン投入完了（最初の50件）")
    
    print("\n✨ 完了！データベースの状態を確認してください。")

if __name__ == "__main__":
    main()


