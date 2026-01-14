#!/bin/bash
sleep 0.05
volume_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
percentage=$(echo "$volume_raw" | awk '{print int($2 * 100)}')

# File sementara untuk simpan status terakhir (Mute/Unmute)
state_file="/tmp/vol_state"
[ -f $state_file ] || echo "unmuted" >$state_file
last_state=$(cat $state_file)

# Cek status sekarang
if echo "$volume_raw" | grep -q "MUTED"; then
  current_state="muted"
else
  current_state="unmuted"
fi

if [ "$current_state" != "$last_state" ]; then
  dunstctl close-all
  echo "$current_state" >$state_file
fi

# Logika Bar
filled_len=$((percentage / 10))
bar=""
for ((i = 0; i < 10; i++)); do
  if [ $i -lt $filled_len ]; then bar+="━"; else bar+=" "; fi
done

sync_id="string:x-canonical-private-synchronous:volume_master"

if [ "$current_state" = "muted" ]; then
  icon="󰝟"
  img="$HOME/media/picture/asset/notify/animesuara1.jpg"
  # Versi perbaikan:
  notify-send -h "$sync_id" -i "$img" \
    "$(printf "Aaaaaaa...\nspeakernya matii\n$icon mutted")"
else
  img="$HOME/media/picture/asset/notify/animesuara.jpg"
  icons=("󰕿" "󰕿" "󰖀" "󰖀" "󰕾" "󰕾" "󰕾" "󰕾" "󰕾")
  icon_index=$((percentage * 8 / 100))
  [ "$icon_index" -gt 8 ] && icon_index=8
  icon="${icons[$icon_index]}"

  if [ "$percentage" -le 25 ]; then
    header="Pelan-pelan aja ah!"
  elif [ "$percentage" -le 50 ]; then
    header="Kencengin dikit mas?"
  elif [ "$percentage" -le 75 ]; then
    header="Oke sip gini aja.."
  else header="AMPUUNN KERASNYA!!"; fi

  notify-send -h "$sync_id" -u low -i "$img" \
    "$header" "\n$icon $bar $percentage%"
fi
