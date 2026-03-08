#!/bin/bash

WALLPAPER_DIR=${HOME}/hatsune_miku/

if [ -d "$WALLPAPER_DIR" ]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \) | shuf -n 1)
fi

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    WALLPAPER="/usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png"
fi

# # Kill existing swaybg if needed
pkill feh

# Run swaybg in the background
feh --bg-fill "$WALLPAPER" &
