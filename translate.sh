#!/bin/bash
hyprctl dispatch exec "[float; size 700 550; center] chromium \
  --app='https://translate.google.co.id/?hl=id&sl=en&tl=id&op=translate' \
  --user-data-dir=/tmp/chromium-floating \
  --hide-scrollbars \
  --disable-features=TranslateUI \
  --disk-cache-dir=/tmp/chromium-cache \
  --disable-extensions \
  --no-first-run \
  --no-default-browser-check \
  --disable-backgrounding-occluded-windows"
