####################################
########### linux variant ##########
####################################

# Ensure the background-image property exists before setting it
xfconf-query -c xfce4-terminal -p /background-image-file --create -t string -s ""
xfconf-query -c xfce4-terminal -p /background-image-style --create -t string -s ""
xfconf-query -c xfce4-terminal -p /background-image-shading --create -t string -s ""

#!/bin/bash
WALLPAPER=$(find path_to_directory_containing_images -type f | shuf -n 1)

# Apply wallpaper to XFCE4 Terminal
xfconf-query -c xfce4-terminal -p /background-image-file -s "$WALLPAPER"
xfconf-query -c xfce4-terminal -p /background-image-shading --create -t string -s 0.9
xfconf-query -c xfce4-terminal -p /background-image-style --create -t string -s TERMINAL_BACKGROUND_STYLE_STRETCHED

####################################
########## windows variant #########
####################################
