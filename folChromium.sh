#!/bin/bash
ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class')
# Hanya jalankan kalau Chromium
if [[ "$ACTIVE_CLASS" =~ [Cc]hromium ]]; then
  if [[ "$1" == "tabs" ]]; then
    echo -n "@tabs" | wl-copy
    ydotool key --key-delay 50 29:1 38:1 38:0 29:0
    ydotool key --key-delay 50 29:1 47:1 47:0 29:0
    ydotool key 57:1 57:0 # Tekan spasi
  elif [[ "$1" == "bookmarks" ]]; then
    echo -n "@bookmarks" | wl-copy
    ydotool key --key-delay 50 29:1 38:1 38:0 29:0
    ydotool key --key-delay 50 29:1 47:1 47:0 29:0
    ydotool key 57:1 57:0 # Tekan spasi
  fi
fi
