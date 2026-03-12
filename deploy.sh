#!/bin/bash
GIT_FOLDER="/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム"

# ※ NFCフォルダ同期を無効化（macOSのUnicode正規化の違いで
#    別フォルダと誤判定し、古いファイルで上書きされる問題を回避）
# 編集はこのフォルダで行い、そのままデプロイしてください。
# ※ デプロイ時にバージョンを自動インクリメント（1.0.0 → 1.0.1 → ...）

cd "$GIT_FOLDER"

# バージョンインクリメント（コードを触った = デプロイ = バージョンアップ）
current=$(grep -o "var APP_VERSION='[^']*'" golf-game.html | sed "s/var APP_VERSION='\(.*\)'/\1/")
major=$(echo "$current" | cut -d. -f1)
minor=$(echo "$current" | cut -d. -f2)
patch=$(echo "$current" | cut -d. -f3)
patch=$((patch + 1))
new_version="$major.$minor.$patch"
sed -i '' "s/var APP_VERSION='[^']*'/var APP_VERSION='$new_version'/" golf-game.html
echo "📦 バージョン: $current → $new_version"

git add -A
git commit -m "update: $(date '+%Y-%m-%d %H:%M') (v$new_version)"
git push
echo "✅ デプロイ完了 v$new_version"
