#!/bin/bash

# ID Unik agar Dunst menganggapnya pesan baru setiap kali dijalankan
UNIQUE_ID="ws_minitext_$(date +%s%N)"

# 1. Cek apakah special workspace "mini-text" sedang aktif di monitor
IS_MINITEXT_OPEN=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -w "special:mini-text")

if [ "$IS_MINITEXT_OPEN" = "special:mini-text" ]; then
  # --- PROSES KELUAR ---
  hyprctl dispatch togglespecialworkspace mini-text

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! ($WINDOW_CLASS)" "Kembali ke workspace biasa!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_ID" \
    -i ~/media/picture/asset/notify/regulerwin1.jpg \
    -t 700
else
  # --- PROSES MASUK ---
  hyprctl dispatch togglespecialworkspace mini-text

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! (mini-text)" "Berpindah ke special workspace mini-text!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_ID" \
    -i ~/media/picture/asset/notify/window.jpg \
    -t 700
fi
