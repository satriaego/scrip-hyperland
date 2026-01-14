#!/bin/bash
if pgrep -x rofi >/dev/null; then
  pkill rofi
else
  SS_DIR="$HOME/media/picture/screenshoot"
  REC_DIR="$HOME/media/videos/recordings/"
  mkdir -p "$SS_DIR" "$REC_DIR"

  SS_FILE="$SS_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
  REC_FILE="$REC_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

  PID_FILE="/tmp/wf-recorder.pid"

  ROFI_THEME="/home/ego/.config/rofi/satriaSimpledmenuNoinputBar.rasi"

  if [ -f "$PID_FILE" ] && ps -p $(cat "$PID_FILE") >/dev/null 2>&1; then
    RECORDING=true
  else
    RECORDING=false
  fi

  if $RECORDING; then
    MAIN=$(echo -e "Ss\nStop merekamnya" | rofi -i -dmenu -theme "$ROFI_THEME" -p " ")
  else
    MAIN=$(echo -e "Ss\nMerekam" | rofi -dmenu -i -theme "$ROFI_THEME" -p " ")
  fi

  case "$MAIN" in
  "Ss")
    MODE=$(echo -e "Fullscreen\nMilih area" | rofi -i -dmenu -theme "$ROFI_THEME" -p " ")
    case "$MODE" in
    "Fullscreen")
      sleep 0.5 && grim "$SS_FILE"
      ;;
    "Milih area")
      SS_GEOM="$(slurp)"
      sleep 0.2
      grim -g "$SS_GEOM" "$SS_FILE"
      ;;
    *)
      exit 1
      ;;
    esac

    ACTION=$(echo -e "Simpen ke hati\nAku ingat" | rofi -i -dmenu -theme "$ROFI_THEME" -p " ")
    case "$ACTION" in
    "Simpen ke hati")
      CURRENT_DEST="$HOME"
      while true; do
        # Ambil daftar folder, tambahkan opsi "SIMPAN DISINI" dan ".."
        CHOICE=$(ls -F "$CURRENT_DEST" | grep '/$' | sed 's/\///' | printf "SAVE\n..\n%s" "$(cat)" | rofi -i -dmenu -theme "$ROFI_THEME" -p "Pilih Folder: $CURRENT_DEST")

        case "$CHOICE" in
        "SAVE")
          FINAL_PATH="$CURRENT_DEST/$(basename "$SS_FILE")"
          mv "$SS_FILE" "$FINAL_PATH"
          #notify-send "Sip udah aku simpan di $CURRENT_DEST 𐔌՞. .՞𐦯"
          notify-send "Dah, Nii-san!" "\naku simpan di $CURRENT_DEST !" -i ~/media/picture/asset/notify/simpan.jpg
          break
          ;;
        "..")
          CURRENT_DEST=$(dirname "$CURRENT_DEST")
          ;;
        "") # Jika tekan ESC
          rm "$SS_FILE"
          exit 1
          ;;
        *)
          # Masuk ke folder yang dipilih
          CURRENT_DEST="${CURRENT_DEST}/${CHOICE}"
          ;;
        esac
      done
      ;;
    "Aku ingat")
      wl-copy <"$SS_FILE"
      rm "$SS_FILE"
      notify-send "Udah ya kak!" "\naku simpan di clipboard!" -i ~/media/picture/asset/notify/simpanclipboard.jpg
      ;;
    *)
      rm "$SS_FILE"
      exit 1
      ;;
    esac
    ;;

  "Merekam")
    notify-send "Tunggu 1s..."
    sleep 1
    AUDIO_SRC="alsa_output.pci-0000_03_00.6.analog-stereo.monitor"

    # Simpan sementara di /tmp agar tidak nyampah di folder video sebelum dipilih
    TEMP_REC="/tmp/recording-$(date +%Y%m%d-%H%M%S).mp4"

    wf-recorder -r 60 -c libx264rgb -b 30000k -f "$TEMP_REC" -a "$AUDIO_SRC" &

    echo $! >"$PID_FILE"
    # Simpan path file sementara ke file lain agar bisa dibaca saat stop
    echo "$TEMP_REC" >"/tmp/wf-recorder.path"

    notify-send "Adek mulai rekam yah" "merekam..." -i ~/media/picture/asset/notify/2.jpg
    ;;

  "Stop merekamnya")
    if $RECORDING; then
      # Ambil path file sementara yang tadi dibuat
      TEMP_REC=$(cat "/tmp/wf-recorder.path")

      kill -INT $(cat "$PID_FILE")
      rm -f "$PID_FILE"
      rm -f "/tmp/wf-recorder.path"

      # Tunggu sebentar sampai wf-recorder selesai menulis file
      sleep 1

      # Logika File Picker dimulai
      CURRENT_DEST="$HOME"
      while true; do
        CHOICE=$(ls -F "$CURRENT_DEST" | grep '/$' | sed 's/\///' | printf "SAVE\n..\n%s" "$(cat)" | rofi i -dmenu -theme "$ROFI_THEME" -p "Simpan rekaman di: $CURRENT_DEST")

        case "$CHOICE" in
        "SAVE")
          FINAL_PATH="$CURRENT_DEST/$(basename "$TEMP_REC")"
          mv "$TEMP_REC" "$FINAL_PATH"
          notify-send "Udahan!" "Tersimpan di $FINAL_PATH" -i ~/media/picture/asset/notify/2.jpg
          break
          ;;
        "..")
          CURRENT_DEST=$(dirname "$CURRENT_DEST")
          ;;
        "") # Jika tekan ESC, file tetap di /tmp (atau hapus jika mau)
          notify-send "Rekaman dibatalkan" "ya mas!" -i ~/media/picture/asset/notify/1.jpg
          rm "$TEMP_REC"
          exit 1
          ;;
        *)
          CURRENT_DEST="${CURRENT_DEST}/${CHOICE}"
          ;;
        esac
      done
    fi
    ;;
  *)
    exit 1
    ;;
  esac
fi
