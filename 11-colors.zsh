declare -A c_fetch_image

declare -A colors_light colors_dark

c_fetch_image[dark]="$HOME/karemen.png"
c_fetch_image[light]="$HOME/cup.png"
c_fetch_argextra=(--colors 172 7 7 174 7 7)

c_kitty_opacity="0.6"

colors_dark[goyo_bg]="#404552"
colors_dark[ssh_bg]="#040454"
colors_light[goyo_bg]="#e1e1e1"
colors_light[ssh_bg]="#B9CAFF"

# vim: ft=zsh
