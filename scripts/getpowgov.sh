#!/bin/bash

psaveicon="<icon=$HOME/.dotfiles/icons/psave.xbm/>"
perficon="<icon=$HOME/.dotfiles/icons/performance.xbm/>"
powgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`

if [ $powgov == powersave ]; then
    echo "<fc=#2aa198>$psaveicon</fc>"
else
    echo "<fc=#dc322f>$perficon</fc>"
fi
