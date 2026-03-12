#!/bin/bash
GIT_FOLDER="/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム"

# ※ NFCフォルダ同期を無効化（macOSのUnicode正規化の違いで
#    別フォルダと誤判定し、古いファイルで上書きされる問題を回避）
# 編集はこのフォルダで行い、そのままデプロイしてください。

cd "$GIT_FOLDER"
git add -A
git commit -m "update: $(date '+%Y-%m-%d %H:%M')"
git push
echo "✅ デプロイ完了"
