#!/bin/bash

# Direktori penyimpanan
SS_DIR="$HOME/picture/screenshoot"
REC_DIR="$HOME/Videos/recordings"
mkdir -p "$SS_DIR" "$REC_DIR"

# Nama file (timestamp)
SS_FILE="$SS_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
REC_FILE="$REC_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

# PID file untuk recording
PID_FILE="/tmp/wf-recorder.pid"

# Rofi theme
ROFI_THEME="/home/ego/.config/rofi/satriaSimple.rasi"

# Deteksi apakah recording sedang berjalan
if [ -f "$PID_FILE" ] && ps -p $(cat "$PID_FILE") > /dev/null 2>&1; then
    RECORDING=true
else
    RECORDING=false
fi

# Menu utama
if $RECORDING; then
    MAIN=$(echo -e "Ss\nStop merekamnya" | rofi -dmenu -theme "$ROFI_THEME" -p " ")
else
    MAIN=$(echo -e "Ss\nMerekam" | rofi -dmenu -theme "$ROFI_THEME" -p " ")
fi

case "$MAIN" in
    "Ss")
        MODE=$(echo -e "Fullscreen\nMilih area" | rofi -dmenu -theme "$ROFI_THEME" -p " ")
        case "$MODE" in
            "Fullscreen")
                sleep 0.5 && grim "$SS_FILE"
                ;;
            "Milih area")
                grim -g "$(slurp)" "$SS_FILE"
                ;;
            *)
                exit 1
                ;;
        esac

        ACTION=$(echo -e "Simpen ke hati\nAku ingat" | rofi -dmenu -theme "$ROFI_THEME" -p " ")
        case "$ACTION" in
            "Simpen ke hati")
                notify-send "Sip udah aku simpan 𐔌՞. .՞𐦯" "$SS_FILE"
                ;;
            "Aku ingat")
                wl-copy < "$SS_FILE"
                notify-send "Screenshotnya sudah aku copy di clipboard ya mas 𐔌՞. .՞𐦯"
                ;;
            *)
                rm "$SS_FILE"
                exit 1
                ;;
        esac
        ;;

    "Merekam")
        notify-send "Tunggu 𐔌՞. .՞𐦯 1s..."
        sleep 1
				AUDIO_SRC="alsa_output.pci-0000_03_00.6.analog-stereo.monitor"
				wf-recorder -r 60 -c libx264 -b 20000k -f "$REC_FILE" -a "$AUDIO_SRC" &

        echo $! > "$PID_FILE"
        notify-send "Aku mulai rekam yah 𐔌՞. .՞𐦯" "Tersimpan di $REC_FILE"
        ;;

    "Stop merekamnya")
        if $RECORDING; then
            kill -INT $(cat "$PID_FILE")
            rm -f "$PID_FILE"
            notify-send "Rekaman di-stop 𐔌՞. .՞𐦯" "Tersimpan di $REC_FILE"
        fi
        ;;
    *)
        exit 1
        ;;
esac

