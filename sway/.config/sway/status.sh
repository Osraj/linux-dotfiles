#!/bin/bash

while true; do
    # Battery info (assumes BAT0)
    if [ -d /sys/class/power_supply/BAT0 ]; then

        BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
        STATUS=$(cat /sys/class/power_supply/BAT0/status)
        BAT_DISPLAY="BAT: $BATTERY% ($STATUS)"
        if [BATTERY -gt 15]; then
            notified_15=0
            notified_5=0
        elif [[ BATTERY -lt 15 ]] && [[ notified_15 -eq 0 ]]; then
            notify-send "Battery" "Battery reached 15%"
            notified_5=0
            notified_15=1
        elif [[ BATTERY -lt 5 ]] && [[ notified_5 -eq 0 ]]; then
            notify-send "Battery" "Battery reached 5%"
            notified_5=1
            notified_15=1
        fi
    else
        BAT_DISPLAY="BAT: N/A"
    fi

    # Date/time
    TIME=$(date +'%F  %X')

    # Print status line
    echo "$BAT_DISPLAY | $TIME"

    sleep 1
done
