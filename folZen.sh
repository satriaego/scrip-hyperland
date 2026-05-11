#!/bin/bash

# Ambil class window yang aktif dari hyprctl
ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class')

# Filter ketat: Hanya jalan jika class mengandung kata "zen" (case-insensitive)
if [[ "$ACTIVE_CLASS" =~ [Zz]en ]]; then
  # Kirim Ctrl + T menggunakan ydotool
  # 29:1 (Ctrl Press), 20:1 (T Press), 20:0 (T Release), 29:0 (Ctrl Release)
  ydotool key 29:1 20:1 20:0 29:0
else
  # Jika bukan Zen, kamu bisa biarkan kosong atau beri perintah lain
  exit 0
fi
