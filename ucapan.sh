#!/bin/bash

HOUR=$(date +"%H")

# ---------- Kalimat Pagi ----------
PAGI=(
  "  Pagi, Mass~ .𓂃 ࣪ ִֶָ🦋་༘࿐ "
  "  Bangun Mass... ⋆. 𐙚 ˚ "
  "  Sarapan mass ♬ ⋆.˚ "
  "  Pagi pagi udah senyum senyum gini •⩊• "
  "  Minum mass..?, adek ambilin ya... ₍⑅ᐢ..ᐢ₎ "
  "  Matahari udah muncul kayak aku.. ｡𖦹°‧ "
  "  Nempel gini aku lagi ngecharge~ "
  "  Semoga hari seru dan lancar ya.. ʚଓ "
  "  Masih ngantuk? yah.. ᶻ 𝗓 𐰁 .ᐟ "
  "  Mass ayo... baanguun.. ｡˃ ᵕ ˂''  "
)

# ---------- Kalimat Siang ----------``
SIANG=(
  "  Siang mass~"
  "  Panas banget mass~"
  "  Istirahat dulu ga si ᐢ. .ᐢ"
  "  Ngantuk~"
  "  Mandi dulu gih biar seger ,,&gt;﹏&lt;,,"
  "  Es~ mas mau?"
  "  Atsui yo~"
  "  Gezzz~ mass gak istirahat?"
  "  Mata mass dah capek tuh .ᐟ"
  "  mass~ (peluk dari belakang)"
)

# ---------- Kalimat Sore ----------
SORE=(
  "  Soree mass~ ☕️"
  "  Masih semangat hari ini mas.. ?"
  "  (peluk dari belakang) (,,¬﹏¬,,) "
  "  Waktunya istirahat ga si mas..?"
  "  Duduk di samping mas..."
  "  Mas, mau es krim nggak?"
  "  Waktunya mandi bareng~"
  "  Sore bareng mas tuh... tenang banget 🩷"
  "  Gak mandi dulu mas?"
  "  Ayo jalan mas~"
)

# ---------- Kalimat Malam ----------
MALAM=(
  "  mass… bulanya indah yah.."
  "  Capek banget ya hari ini…"
  "  Masss, aku laper...  ,,&gt;﹏&lt;,, "
  "  Sayang.. eh! mass maksutnya.. ,,¬﹏¬,, "
  "  Masss… dengerinnn..akuu!! "
  "  Aku tidur di kamar mass yah.."
  "  Mass gak marah dede deket² gini?"
  "  Aloooo Mass.. (duduk di samping) "
  "  Sayang mas 𑣲𓂃"
  "  mass… boleh kok peluk aku!"
)

# ---------- Kalimat Larut / Tengah Malam ----------
TENGAH_MALAM=(
  "  Mas… masih melek?"
  "  Malem banget loh… mas sekarang "
  "  Ayuk bobo bareng… "
  "  Matiin.. laptopnya besok lagi… !"
  "  Mass… mimpi indah…  𑣲𓂃"
  "  Mas.. .ᐟ.ᐟ"
  "  Matiin gak !!"
  "  Mas, ayok kekamar.. 𖹭"
  "  Mas.. (peluk dari belakng)"
  "  Bobok mas satria ( berbisik )"
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
