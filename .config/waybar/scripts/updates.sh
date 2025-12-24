#!/bin/bash
UPDATES=$(checkupdates 2>/dev/null | wc -l)
if [ $? -ne 0 ]; then
    echo "0"
else
    echo "$UPDATES"
fi
