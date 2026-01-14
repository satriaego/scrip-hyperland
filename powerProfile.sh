#!/bin/bash
# Power Profile Switcher dengan Rofi
if pgrep -x rofi > /dev/null

then
    pkill rofi
else 
# Set display untuk Rofi di Wayland/X11
export DISPLAY=${DISPLAY:-:0}
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}

# Full path untuk commands
POWERCTL="/usr/sbin/powerprofilesctl"
ROFI="/usr/sbin/rofi"

# Ambil profil aktif saat ini
ACTIVE=$($POWERCTL get)

# Ambil daftar profil
PROFILES=$($POWERCTL list | grep ":" | grep -v "Driver\|Degraded\|Platform" | sed 's/^[* ]*//' | sed 's/:$//')

# Buat menu dengan tanda ★ di profil aktif
MENU=$(echo "$PROFILES" | while read p; do
    if [[ "$p" == "$ACTIVE" ]]; then
        echo " $p"
    else
        echo "    $p"
    fi
done)

# Tampilkan di Rofi dan ambil pilihan
CHOICE=$(echo "$MENU" | $ROFI -dmenu -theme /home/ego/.config/rofi/satriaSimpledmenuNoinputBar.rasi -p "Power Profile: ($ACTIVE)" | sed 's/★ //' | sed 's/^[[:space:]]*//')

# Set profil jika ada yang dipilih dan berbeda dengan aktif
if [[ -n "$CHOICE" ]] && [[ "$CHOICE" != "$ACTIVE" ]]; then
    sudo $POWERCTL set "$CHOICE"
    
    # Custom message untuk setiap profile
    case "$CHOICE" in
        "performance")
            notify-send "Adik~ ☁️⋅♡🪐༘⋆" "MODE GANASSS😈\nAW~ KAKAK"
            ;;
        "balanced")
            notify-send "Adik~ ☁️⋅♡🪐༘⋆" "MODE SERIUS ON AKTIF 🤓\nYA..YA..YA.."
            ;;
        "power-saver")
            notify-send "Adik~ ☁️⋅♡🪐༘⋆" "SANTAYY MODE ON 🥱\n... ZZZ..BUAT NANTI MALAM YA!"
            ;;
    esac
fi
fi
