#!/bin/bash

# ID unik agar notifikasi tidak saling tindih (stacking)
UNIQUE_TAG="ws_translate_$(date +%s%N)"

# 1. Cek apakah special workspace "translate" sedang terbuka
IS_TRANSLATE_OPEN=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -w "special:translate")

if [ "$IS_TRANSLATE_OPEN" = "special:translate" ]; then
  # --- PROSES KELUAR ---
  hyprctl dispatch togglespecialworkspace translate

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! ($WINDOW_CLASS)" "Kembali ke workspace biasa!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_TAG" \
    -i ~/media/picture/asset/notify/regulerwin1.jpg \
    -t 700
else
  # --- PROSES MASUK ---
  hyprctl dispatch togglespecialworkspace translate

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! (Translate)" "Berpindah ke special workspace translate!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_TAG" \
    -i ~/media/picture/asset/notify/window.jpg \
    -t 700
fi
