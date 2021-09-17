#!/usr/bin/bash

# Get status of focus mode
focus_mode=`cat /tmp/bspwmfocusmode.dat`

# Get status of focus mode
game_mode=`cat /tmp/game_mode.dat`

# Check if laptop
laptop=`cat /tmp/laptop.dat`

# Find connected monitors
monitors=( $(xrandr --query | grep " connected" | cut -d" " -f1) )

# Find primary monitor
primary_monitor=$(xrandr --query | grep " primary" | cut -d" " -f1)

# Find disabled monitors
disabled_monitors=( $(xrandr --query | grep " connected (" | cut -d" " -f1) )

# Find secondary monitors
secondary_monitors=( "${monitors[@]/$primary_monitor}" )

# Remove disabled monitors
for target in "${disabled_monitors[@]}"; do
  for i in "${!secondary_monitors[@]}"; do
    if [[ ${secondary_monitors[i]} = $target ]]; then
      unset 'secondary_monitors[i]'
    fi
  done
done

# Fix array indices
for i in "${!secondary_monitors[@]}"; do
  temp_array+=( "${secondary_monitors[i]}" )
done
secondary_monitors=("${temp_array[@]}")
unset temp

echo " Number of monitors detected: ${#secondary_monitors[@]}"

# Terminate already running bar instances
killall -q polybar

# wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [ "$game_mode" = true ]; then
  echo "GAME MODE"
    MONITOR=$primary_monitor polybar game &
else
  if [ "$focus_mode" = false ]; then
    # Launch main bars
    echo " Launching main bars"
    MONITOR=$primary_monitor polybar power &

    if [ ${#secondary_monitors[@]} -gt 1 ]; then
      MONITOR=$primary_monitor polybar workspaces2 &
      MONITOR=$primary_monitor polybar spotify2 &
    else
      MONITOR=$primary_monitor polybar workspaces &
      MONITOR=$primary_monitor polybar spotify &
    fi

    MONITOR=$primary_monitor polybar date &
    MONITOR=$primary_monitor polybar tray &

    if [ "$laptop" = true ]; then
      MONITOR=$primary_monitor polybar sensorsbat &
    else
      MONITOR=$primary_monitor polybar sensors &
    fi

    # If second monitor is connected, launch second bar
    if [ ${secondary_monitors[0]} ]; then
      echo " Launching second bar"
      MONITOR=${secondary_monitors[0]} polybar second &

      # If third monitor is connected, launch third bar
      if [ ${secondary_monitors[1]} ]; then
        echo " Launching third bar"
        MONITOR=${secondary_monitors[1]} polybar second &
      fi
    fi
  else
    polybar focused_main &
    polybar focused_second &
  fi
fi
