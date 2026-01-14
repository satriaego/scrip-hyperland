#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
  pkill rofi
else
  # Ambil data lengkap dengan ID
  CLIPHIST_DATA=$(cliphist list --max-items 100)

  # Tampilkan hanya preview (tanpa ID) di rofi
  SELECTED=$(echo "$CLIPHIST_DATA" |
    awk -F $'\t' '{print $2}' |
    rofi -dmenu -i -theme ~/.config/rofi/satriaSimpledmenu.rasi -p "󰨸 ")

  if [ -n "$SELECTED" ]; then
    # Cari baris asli yang mengandung preview tersebut, lalu decode
    echo "$CLIPHIST_DATA" |
      grep -F "$SELECTED" |
      head -n1 |
      cliphist decode |
      wl-copy

    ydotool key 42:1 29:1 47:1 47:0 29:0 42:0
    notify-send "Udah, Nii-san!" "\nRiwayat clipboardnya udah aku paste-in!" -i ~/media/picture/asset/notify/animegirls1.jpg
  fi
fi
