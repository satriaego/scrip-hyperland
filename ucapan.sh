#!/bin/bash

HOUR=$(date +"%H")

# ---------- Kalimat Pagi ----------
PAGI=(
  "  Pagi, Mass~ . "
  "  Bangun Mass... ⋆˚ "
  "  Sarapan mass ♬ ⋆.˚ "
  "  Pagi pagi •⩊• "
  "  Minum mass..?"
  "  Matahari udah muncul.."
  "  aku lagi ngecharge~ "
  "  seru dan lancar ya.."
  "  Masih ngantuk? yah.."
  "  Mass ayo.. baanguun.."
)

# ---------- Kalimat Siang ----------``
SIANG=(
  "  Siang mass~"
  "  Panas banget mass~"
  "  Istirahat dulusi "
  "  Ngantuk~"
  "  Mandi dulu,,&gt;﹏&lt;,,"
  "  Es~ mas mau?"
  "  Atsui yo~"
  "  mass gak istirahat?"
  "  Mata mass dah capek.."
  "  mass~"
)

# ---------- Kalimat Sore ----------
SORE=(
  "  Soree mass~ ☕️"
  "  Masih semangat mas.. ?"
  "  (peluk dari belakang) "
  "  istirahat ga si mas..?"
  "  Duduk di samping mas..."
  "  Mas, mau es krim nggak?"
  "  Waktunya mandi bareng~"
  "  tenang banget 🩷"
  "  Gak mandi dulu mas?"
  "  Ayo jalan mas~"
)

# ---------- Kalimat Malam ----------
MALAM=(
  "  mass… bulanya indah yah.."
  "  Capek banget ya hari ini…"
  "  Masss, aku laper...   "
  "  Sayang..  "
  "  Masss… dengerinnn..akuu!! "
  "  Aku tidur di kamar mass yah.."
  "  Mass gak marah ?"
  "  Aloooo Mass..  "
  "  Sayang mas "
  "  boleh kok peluk aku!"
)

# ---------- Kalimat Larut / Tengah Malam ----------
TENGAH_MALAM=(
  "  Mas… masih melek?"
  "  Malem banget loh…  "
  "  Ayuk bobo bareng… "
  "  Matiin..!"
  "  mimpi indah…  𑣲𓂃"
  "  Mas.. .ᐟ.ᐟ"
  "  Matiin gak !!"
  "  ayok kekamar.. 𖹭"
  "  Mas.. ("
  "  Bobok mas satria "
)

if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 11 ]; then
  ARRAY=("${PAGI[@]}")
elif [ "$HOUR" -ge 11 ] && [ "$HOUR" -lt 15 ]; then
  ARRAY=("${SIANG[@]}")
elif [ "$HOUR" -ge 15 ] && [ "$HOUR" -lt 18 ]; then
  ARRAY=("${SORE[@]}")
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 23 ]; then
  ARRAY=("${MALAM[@]}")
else
  ARRAY=("${TENGAH_MALAM[@]}")
fi

RANDOM_INDEX=$((RANDOM % ${#ARRAY[@]}))

echo "${ARRAY[$RANDOM_INDEX]}"
