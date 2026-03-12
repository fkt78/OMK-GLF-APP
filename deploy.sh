#!/bin/bash
cd "/Users/fukitakatsumi/Desktop/スキル/ゴルフゲーム"
git add -A
git commit -m "update: $(date '+%Y-%m-%d %H:%M')"
git push
echo "✅ デプロイ完了"
