#!/bin/bash
hyprctl dispatch exec "[float; size 700 700; center] chromium --app='https://translate.google.co.id/?hl=id&sl=en&tl=id&op=translate' --user-data-dir=/tmp/chromium-floating --hide-scrollbars"
