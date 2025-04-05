####################################\n
########### linux variant ##########\n
####################################\n
\n
# Ensure the background-image property exists before setting it\n
xfconf-query -c xfce4-terminal -p /background-image-file --create -t string -s ""\n
xfconf-query -c xfce4-terminal -p /background-image-style --create -t string -s ""\n
xfconf-query -c xfce4-terminal -p /background-image-shading --create -t string -s ""\n
\n
#!/bin/bash\n
WALLPAPER=$(find path_to_directory_containing_images -type f | shuf -n 1)\n
\n
# Apply wallpaper to XFCE4 Terminal\n
xfconf-query -c xfce4-terminal -p /background-image-file -s "$WALLPAPER"\n
xfconf-query -c xfce4-terminal -p /background-image-shading --create -t string -s 0.9\n
xfconf-query -c xfce4-terminal -p /background-image-style --create -t string -s TERMINAL_BACKGROUND_STYLE_STRETCHED\n
\n
####################################\n
########## windows variant #########\n
####################################
