#!/bin/bash

# Jalankan Chrome dalam app mode
google-chrome-stable --app=https://www.google.com &

# Tunggu dan cek maksimal 5 detik
for i in {1..10}; do
   sleep 0.1   
    # Cari window berdasarkan class yang spesifik
    CHROME_WINDOW=$(hyprctl clients -j | jq -r '.[] | select(.class == "chrome-www.google.com__-Default") | .address')
    
    if [ -n "$CHROME_WINDOW" ]; then
        hyprctl dispatch togglefloating address:$CHROME_WINDOW
        hyprctl dispatch resizeactive exact 700 550
        hyprctl dispatch centerwindow address:$CHROME_WINDOW
        echo "Chrome app berhasil diatur ke floating"
        exit 0
    fi
done

echo "Gagal menemukan window Chrome app dalam waktu 5 detik"
exit 1
