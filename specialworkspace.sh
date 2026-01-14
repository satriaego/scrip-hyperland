#!/bin/bash

UNIQUE_ID=$(date +%s%N)

# Cek status sebelum pindah
IS_MEMEKA_OPEN=$(hyprctl monitors -j | jq -r '.[] | .specialWorkspace.name' | grep -w "special:memeka")

if [ "$IS_MEMEKA_OPEN" = "special:memeka" ]; then
  # 1. Pindah dulu keluar
  hyprctl dispatch togglespecialworkspace memeka
  # 3. Ambil class window setelah pindah
  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! ($WINDOW_CLASS)" "Kembali ke workspace biasa!" \
    -h string:x-dunst-stack-tag:ws_$UNIQUE_ID \
    -i ~/media/picture/asset/notify/regulerwin1.jpg \
    -t 700
else
  # 1. Pindah dulu masuk ke special
  hyprctl dispatch togglespecialworkspace memeka
  # 3. Ambil class window di dalam special
  WINDOW_CLASS=$(hyprctl activewindow -j | jq -r '.class // "Desktop"')

  notify-send "Iya mas! ($WINDOW_CLASS)" "Berpindah ke special workspace!" \
    -h string:x-dunst-stack-tag:ws_$UNIQUE_ID \
    -i ~/media/picture/asset/notify/window.jpg \
    -t 700

fi
