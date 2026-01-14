#!/usr/bin/env bash
ICON_DIR="$HOME/.config/rofi/icons"

if pgrep -x rofi >/dev/null; then
  pkill rofi
else
  # Format: Teks Menu\0icon\x1fPathKeGambar
  LIST="istirahat bentar yah\0icon\x1f$ICON_DIR/suspend.png\nmulai ulang yuk\0icon\x1f$ICON_DIR/reboot.png\ntidur bentar yaa\0icon\x1f$ICON_DIR/shutdown.png"

  CHOICE=$(echo -e "$LIST" | rofi -dmenu -i -theme ~/.config/rofi/satriaSimpledmenunsearch.rasi -p " ")

  case "$CHOICE" in
  *istirahat*) systemctl suspend ;;
  *mulai*) systemctl reboot -i ;;
  *tidur*) shutdown now ;;
  *) exit 1 ;;
  esac
fi
