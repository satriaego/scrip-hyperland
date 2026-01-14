#!/bin/bash
brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)
percentage=$(((brightness * 100 / max_brightness)))

# Membuat bar karakter (---60%---)
filled_len=$((percentage / 10))
bar=""
for ((i = 0; i < 10; i++)); do
  if [ $i -lt $filled_len ]; then bar+="━"; else bar+=" "; fi
done

icons=("" "" "" "" "" "" "" "" "")
icon_index=$((percentage * 8 / 100))
[ "$icon_index" -gt 8 ] && icon_index=8
icon="${icons[$icon_index]}"

# Header berdasarkan range
if [ "$percentage" -le 25 ]; then
  header="Gelap-gelapan yuk!"
elif [ "$percentage" -le 50 ]; then
  header="Gini aja mas.."
elif [ "$percentage" -le 75 ]; then
  header="Standard lah ya!"
else header="Pagi banget ya mas?!"; fi

# Hapus flag -h int:value:$percentage agar bar bawaan hilang
notify-send -h string:x-canonical-private-synchronous:brightness \
  -u low \
  -i "$HOME/media/picture/asset/notify/kecerahan.jpg" \
  "$header" "\n$icon $bar $percentage%"
