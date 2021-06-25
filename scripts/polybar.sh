#!/usr/bin/bash

# Get status of focus mode
focus_mode=`cat /tmp/bspwmfocusmode.dat`

# Terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [ "$focus_mode" = false ]; then
  polybar power &
  polybar workspaces &
  polybar spotify &
  polybar date &
  polybar sensors &
  polybar tray &
  polybar second &
else
  polybar focused_main &
  polybar focused_second &
fi

