#!/bin/bash
# ~/.config/hypr/rofi-toggle.sh

# cek apakah rofi sedang berjalan
if pgrep -x rofi >/dev/null; then
  pkill rofi
else
  rofi -show drun -show-icons -theme /home/ego/.config/rofi/satriaSimple.rasi &
  #rofi -show drun -show-icons -theme /home/ego/scripts/rofiTheme &
fi
