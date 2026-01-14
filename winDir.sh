#!/bin/bash
STATUS_FILE="/tmp/hypr_last_focused_window"

# 1. Ambil ID workspace aktif
ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# 2. Ambil address window yang sedang aktif saat ini
CURRENT_ACTIVE=$(hyprctl activewindow -j | jq -r '.address')

# 3. Ambil daftar address window di workspace aktif (urut berdasarkan posisi layar)
mapfile -t WINDOW_ADDRESSES < <(hyprctl clients -j | jq -r --arg ws "$ACTIVE_WS" '
    .[] | select(.workspace.id == ($ws | tonumber)) | "\(.at[0])|\(.at[1])|\(.address)"
' | sort -t'|' -k1,2n | cut -d'|' -f3)

WINDOW_COUNT=${#WINDOW_ADDRESSES[@]}

# Jika tidak ada window atau cuma 1, keluar saja
if [ "$WINDOW_COUNT" -le 1 ]; then
  exit 0
fi

# 4. Cari index window saat ini berdasarkan window yang aktif
CURRENT_INDEX=-1
for i in "${!WINDOW_ADDRESSES[@]}"; do
  if [ "${WINDOW_ADDRESSES[$i]}" = "$CURRENT_ACTIVE" ]; then
    CURRENT_INDEX=$i
    break
  fi
done

# 5. Tentukan target index berikutnya
NEXT_INDEX=$(((CURRENT_INDEX + 1) % WINDOW_COUNT))
NEXT_ADDRESS="${WINDOW_ADDRESSES[$NEXT_INDEX]}"

# 6. Eksekusi perpindahan fokus
hyprctl dispatch focuswindow "address:$NEXT_ADDRESS"

# 7. Ambil info untuk notifikasi
WINDOW_INFO=$(hyprctl clients -j | jq -r --arg addr "$NEXT_ADDRESS" '.[] | select(.address == $addr)')
WINDOW_TITLE=$(echo "$WINDOW_INFO" | jq -r '.title')
WINDOW_CLASS=$(echo "$WINDOW_INFO" | jq -r '.class')

# --- LOGIKA PENCARIAN ICON ---
desktop_file=$(grep -l "StartupWMClass=$WINDOW_CLASS" /usr/share/applications/*.desktop 2>/dev/null | head -n 1)
raw_icon=$([ -n "$desktop_file" ] && grep '^Icon=' "$desktop_file" | cut -d'=' -f2 | head -n 1 || echo "$WINDOW_CLASS" | tr '[:upper:]' '[:lower:]')

# Cari path asli (prioritas hicolor)
full_icon_path=$(find /usr/share/icons/hicolor -name "${raw_icon}.png" -o -name "${raw_icon}.svg" | grep -E "128x128|scalable" | head -n 1)
[ -z "$full_icon_path" ] && full_icon_path=$(find /usr/share/icons -name "${raw_icon}.png" -o -name "${raw_icon}.svg" | head -n 1)
[ -z "$full_icon_path" ] && full_icon_path="$raw_icon"

# 8. Kirim Notifikasi
notify-send -u low -a "Hyprland Focus" -t 1500 -i "$full_icon_path" "Fokus: $WINDOW_CLASS" "$WINDOW_TITLE"

# 9. Simpan address untuk trigger berikutnya (opsional, bisa dihapus jika tidak diperlukan)
echo "$NEXT_ADDRESS" >"$STATUS_FILE"
