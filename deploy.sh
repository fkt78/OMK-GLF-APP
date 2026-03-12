#!/bin/bash
# ゴルフゲーム デプロイスクリプト（NFC/NFD自動同期対応版）

GIT_FOLDER="/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム"

# Step1: CoworkがNFCフォルダに書いたファイルを自動でgitフォルダに同期
python3 << 'PYEOF'
import os, shutil, unicodedata

git_folder = '/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム'
parent = '/Users/fukitakatsumi/Desktop/スキル'

try:
    for item in os.listdir(parent):
        if unicodedata.normalize('NFC', item) == 'ゴルフゲーム':
            full_path = os.path.join(parent, item)
            if os.path.realpath(full_path) != os.path.realpath(git_folder):
                print(f'NFCフォルダを検出 → gitフォルダへ同期中...')
                for f in os.listdir(full_path):
                    src = os.path.join(full_path, f)
                    dst = os.path.join(git_folder, f)
                    if os.path.isfile(src):
                        shutil.copy2(src, dst)
                        print(f'  同期: {f}')
except Exception as e:
    print(f'同期スキップ: {e}')
PYEOF

# Step2: コミット & プッシュ
cd "$GIT_FOLDER"
git add -A
git commit -m "update: $(date '+%Y-%m-%d %H:%M')"
git push
echo "✅ デプロイ完了"
