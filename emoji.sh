#!/bin/bash

if pgrep -x rofi >/dev/null; then
  pkill rofi
else

  DB_FILE="$HOME/scripts/database.txt"
  THEME="$HOME/.config/rofi/satriaSimpledmenu.rasi"

  CHOICE=$(rofi -dmenu -i -theme "$THEME" <"$DB_FILE")
  CHOICE=$(echo "$CHOICE" | xargs)

  [ -z "$CHOICE" ] && exit 0

  if [[ "$CHOICE" =~ ^[[:alnum:]] ]]; then
    COPY=$(echo "$CHOICE" | cut -d'|' -f1 | xargs)
    TYPE="Command"
  else
    COPY=${CHOICE%% *}
    TYPE="Emoji"
  fi

  if [ -n "$COPY" ]; then
    wl-copy <<<"$COPY"
    ydotool key 42:1 29:1 47:1 47:0 29:0 42:0
    notify-send "Iya udah, Nii-san!" "\nEmojinya udah aku paste-in!" -i ~/media/picture/asset/notify/animegirls1.jpg

  fi
fi
