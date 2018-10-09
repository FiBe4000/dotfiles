#!/bin/sh

icon_full_vol="<icon=$HOME/.xmonad/icons/spkr_01.xbm/>"
icon_mid_vol="<icon=$HOME/.xmonad/icons/spkr_50.xbm/>"
icon_midlow_vol="<icon=$HOME/.xmonad/icons/spkr_25.xbm/>"
icon_low_vol="<icon=$HOME/.xmonad/icons/spkr_00.xbm/>"
icon_mute_vol="<icon=$HOME/.xmonad/icons/spkr_mute.xbm/>"
high=75
mid=50
low=25

vol=($(pulseaudio-ctl full-status))

if   [ "${vol[1]}" = "yes"    ]; then echo $icon_mute_vol
elif [ "${vol[0]}" -ge "$high" ]; then echo $icon_full_vol" "${vol[0]}"%"
elif [ "${vol[0]}" -ge "$mid"  ]; then echo $icon_mid_vol" "${vol[0]}"%"
elif [ "${vol[0]}" -ge "$low"  ]; then echo $icon_midlow_vol" "${vol[0]}"%"
else echo $icon_low_vol" "${vol[0]}"%"
fi

exit 0
