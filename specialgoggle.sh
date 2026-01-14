#!/bin/bash

# ID unik agar tidak menumpuk
UNIQUE_ID="ws_google_$(date +%s%N)"

# 1. Cek apakah special workspace "google" sedang aktif/terbuka
IS_GOOGLE_OPEN=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -w "special:google")

if [ "$IS_GOOGLE_OPEN" = "special:google" ]; then
  # --- KELUAR DARI GOOGLE ---
  hyprctl dispatch togglespecialworkspace google

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! ($WINDOW_CLASS)" "Kembali ke workspace biasa!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_ID" \
    -i ~/media/picture/asset/notify/regulerwin1.jpg \
    -t 700

else
  # --- MASUK KE GOOGLE ---
  hyprctl dispatch togglespecialworkspace google

  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! (Goggle)" "Berpindah ke special workspace google!" \
    -h string:x-dunst-stack-tag:"$UNIQUE_ID" \
    -i ~/media/picture/asset/notify/window.jpg \
    -t 700
fi
