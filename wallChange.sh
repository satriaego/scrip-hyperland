#!/bin/bash

# Simple Wallpaper Selector with thumbnails for swww
# Usage: ./wallChange.sh

# Configuration
WALLPAPER_DIR="$HOME/Downloads/picture/wallpaper/"  # Change this path
cd "$WALLPAPER_DIR" || { echo "Directory not found: $WALLPAPER_DIR"; exit 1; }

# Simple one-liner approach with thumbnails
SELECTED_WALL=$(for a in *.jpg *.jpeg *.png *.webp *.bmp; do 
    [ -f "$a" ] && echo -en "$a\0icon\x1f$PWD/$a\n"
done | rofi -dmenu -show-icons -theme /home/ego/.config/rofi/satriaSimpleww.rasi -p "󰸉 ")

# Set wallpaper if selected
if [ -n "$SELECTED_WALL" ]; then
    # Start swww daemon if not running
    pgrep -x "swww-daemon" > /dev/null || { swww-daemon & sleep 2; }
    
    # Set the wallpaper
    swww img "$WALLPAPER_DIR/$SELECTED_WALL" --transition-type wipe --transition-duration 1
    
    echo "Wallpaper changed to: $SELECTED_WALL"
else
    echo "No wallpaper selected"
fi
