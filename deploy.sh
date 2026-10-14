#!/usr/bin/env bash
# Повторная публикация сайта на GitHub Pages.
#   ./deploy.sh
# Токен читается из ~/.github-token и в вывод/конфиг не попадает.
set -euo pipefail
cd "$(dirname "$0")"

OWNER="semkastler12"
REPO="topus-wrong-transfer"
TOKEN_FILE="$HOME/.github-token"

[ -f "$TOKEN_FILE" ] || { echo "Нет файла с токеном: $TOKEN_FILE" >&2; exit 1; }
TOKEN="$(tr -d ' \t\r\n' < "$TOKEN_FILE")"

# index.html — та же статья, чтобы корень сайта открывался сразу
cp -f TOPUS_Wrong_transfer_A4_dark.html index.html
touch .nojekyll

[ -d .git ] || {
  git init -q
  git config user.name "I.NR.D"
  git config user.email "semkastler12@users.noreply.github.com"
  git remote add origin "https://github.com/$OWNER/$REPO.git"
}
git add -A
git commit -q -m "Обновление сайта: ошибочный перевод на карту" || echo "(нечего коммитить)"
git branch -M main

git -c credential.helper= push "https://$OWNER:${TOKEN}@github.com/$OWNER/$REPO.git" main:main --force

echo
echo "Готово: https://$OWNER.github.io/$REPO/"
