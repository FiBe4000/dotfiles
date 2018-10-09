#!/bin/bash

icon_path="$HOME/.xmonad/icons"
battery_path="/sys/class/power_supply/BAT0"
percentage=`cat $battery_path/capacity`
status=`cat $battery_path/status`
icon_100="<icon=$icon_path/bat_100.xbm/>"
icon_85="<icon=$icon_path/bat_85.xbm/>"
icon_65="<icon=$icon_path/bat_65.xbm/>"
icon_50="<icon=$icon_path/bat_50.xbm/>"
icon_35="<icon=$icon_path/bat_35.xbm/>"
icon_20="<icon=$icon_path/bat_20.xbm/>"
icon_05="<icon=$icon_path/bat_05.xbm/>"
icon_ch="<icon=$icon_path/bat_ch.xbm/>"
green="#2aa198"
red="#dc322f"

if [ "$percentage" -gt 100 ]; then percentage="100"
fi

if [ "$status" = "Discharging" ]; then
  if   [ "$percentage" -gt "85" ]; then echo "$icon_100 $percentage%"
  elif [ "$percentage" -gt "65" ]; then echo "$icon_85 $percentage%"
  elif [ "$percentage" -gt "50" ]; then echo "$icon_65 $percentage%"
  elif [ "$percentage" -gt "35" ]; then echo "$icon_50 $percentage%"
  elif [ "$percentage" -gt "20" ]; then echo "$icon_35 $percentage%"
  elif [ "$percentage" -gt "05" ]; then echo "$icon_20 $percentage%"
  else echo "<fc=$red>$icon_05 $percentage</fc>%"
  fi
elif [ "$status" = "Charging" ] || [ "$status" = "Full" ] || [ "$status" = "Unknown" ]; then
  if [ "$percentage" -lt "100" ]; then echo "<fc=$green>$icon_ch $percentage</fc>%"
  else echo "$icon_ch $percentage%"
  fi
fi
