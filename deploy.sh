#!/bin/bash
GIT_FOLDER="/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム"

python3 << 'PYEOF'
import os, shutil, unicodedata

git_folder = '/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム'
parent = '/Users/fukitakatsumi/Desktop/スキル'

for item in os.listdir(parent):
    if unicodedata.normalize('NFC', item) == 'ゴルフゲーム':
        full_path = os.path.join(parent, item)
        if os.path.realpath(full_path) != os.path.realpath(git_folder):
            print(f'NFCフォルダ検出: {full_path}')
            for f in os.listdir(full_path):
                src = os.path.join(full_path, f)
                dst = os.path.join(git_folder, f)
                if os.path.isfile(src):
                    try:
                        shutil.copy2(src, dst)
                        print(f'  同期: {f}')
                    except Exception as e:
                        pass  # 同一ファイルエラーは無視して続行
PYEOF

cd "$GIT_FOLDER"
git add -A
git commit -m "update: $(date '+%Y-%m-%d %H:%M')"
git push
echo "✅ デプロイ完了"
