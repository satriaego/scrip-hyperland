#!/bin/bash

# ID unik agar notifikasi muncul sebagai pesan baru (tidak menumpuk di tag yang sama)
UNIQUE_ID="ws_scratch_$(date +%s%N)"

# 1. Cek apakah special workspace "scratch" sedang aktif/terbuka
IS_SCRATCH_OPEN=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -w "special:scratch")

if [ "$IS_SCRATCH_OPEN" = "special:scratch" ]; then
  # --- PROSES KELUAR ---
  hyprctl dispatch togglespecialworkspace scratch

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! ($WINDOW_CLASS)" "Kembali ke workspace biasa!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_ID" \
    -i ~/media/picture/asset/notify/regulerwin1.jpg \
    -t 700
else
  # --- PROSES MASUK ---
  hyprctl dispatch togglespecialworkspace scratch

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! (Terminal)" "Berpindah ke special workspace terminal!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_ID" \
    -i ~/media/picture/asset/notify/window.jpg \
    -t 700
fi
