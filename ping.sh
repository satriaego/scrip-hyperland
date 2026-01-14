
#!/bin/bash

TARGET="8.8.8.8"

PING_RESULT=$(/bin/ping -c 1 -w 2 "$TARGET" 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')

if [ -n "$PING_RESULT" ]; then
    echo "$PING_RESULT ms "
fi

