#!/bin/bash

WALLPAPER_DIR="$HOME/media/picture/wallpaper"
CACHE_DIR="$HOME/.cache/rofi-wallpapers"
mkdir -p "$CACHE_DIR"

if pgrep -x rofi >/dev/null; then
  pkill rofi
  exit 0
fi

find "$CACHE_DIR" -type f | while read -r thumb; do
  filename=$(basename "$thumb")
  [ ! -f "$WALLPAPER_DIR/$filename" ] && rm "$thumb"
done

generate_list() {
  for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp,bmp}; do
    [ -e "$img" ] || continue
    filename=$(basename "$img")
    thumb="$CACHE_DIR/$filename"

    if [ ! -f "$thumb" ]; then
      magick "$img" -thumbnail 200x200 -quality 80 "$thumb"
    fi

    echo -en "$filename\0icon\x1f$thumb\n"
  done
}
SELECTED_WALL=$(generate_list | rofi -dmenu -show-icons -theme "$HOME/.config/rofi/satriaSimpleww.rasi")
if [ -n "$SELECTED_WALL" ]; then
  swww img "$WALLPAPER_DIR/$SELECTED_WALL" --transition-type wipe --transition-angle 270 --transition-duration 3 --transition-step 240 --transition-fps 120
  notify-send "Selesai, Nii-san!" "\nWallpaper dirubahh..ya!" -i ~/media/picture/asset/notify/changeWallpaper.jpg

fi
