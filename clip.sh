#!/usr/bin/env bash
if pgrep -x rofi >/dev/null; then
  pkill rofi
else
  # 1. Ambil data mentah (ID + Preview)
  # cliphist list akan menampilkan "[ID] [Teks]" atau "[ID] [[ binary data ... ]]"
  SELECTED_RAW=$(cliphist list | rofi -dmenu -i -theme ~/.config/rofi/satriaSimpledmenu.rasi -p "󰨸 ")

  if [ -n "$SELECTED_RAW" ]; then
    # 2. Decode langsung dari baris yang dipilih (cliphist butuh ID di awal baris)
    echo "$SELECTED_RAW" | cliphist decode | wl-copy

    # 3. Paste otomatis menggunakan ydotool
    ydotool key 42:1 29:1 47:1 47:0 29:0 42:0

    notify-send "Udah, Nii-san!" "\nClipboard (Teks/Gambar) udah aku paste-in!" -i ~/media/picture/asset/notify/animegirls1.jpg
  fi
fi
