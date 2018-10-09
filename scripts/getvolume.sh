#!/bin/sh

icon_full_vol="<icon=$HOME/.dotfiles/icons/spkr_01.xbm/>"
icon_mid_vol="<icon=$HOME/.dotfiles/icons/spkr_50.xbm/>"
icon_midlow_vol="<icon=$HOME/.dotfiles/icons/spkr_25.xbm/>"
icon_low_vol="<icon=$HOME/.dotfiles/icons/spkr_00.xbm/>"
icon_mute_vol="<icon=$HOME/.dotfiles/icons/spkr_mute.xbm/>"
high=75
mid=50
low=25

vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "MUTE" } else { print $2 }}' | head -n 1)

if   [ "$vol" = "MUTE"    ]; then echo $icon_mute_vol
elif [ "$vol" -ge "$high" ]; then echo $icon_full_vol" "$vol"%"
elif [ "$vol" -ge "$mid"  ]; then echo $icon_mid_vol" "$vol"%"
elif [ "$vol" -ge "$low"  ]; then echo $icon_midlow_vol" "$vol"%"
else echo $icon_low_vol" "$vol"%"
fi

exit 0
