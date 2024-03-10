#!/bin/bash

dnd=`cat /tmp/dnd.dat`

if [ $dnd == "false" ]; then
  if playerctl -p $(tail -1 /tmp/player-last) metadata | grep -q 'spotify'; then
    icon=" "
    printformat='{{artist}} - {{title}}'
    stringlength='75'
  elif playerctl -p $(tail -1 /tmp/player-last) metadata | grep -q 'YouTube Music'; then
    icon=" Music "
    printformat='{{title}}'
    stringlength='70'
  elif playerctl -p $(tail -1 /tmp/player-last) metadata | grep -q 'YouTube'; then
    icon=" "
    printformat='{{title}}'
    stringlength='75'
  elif playerctl -p $(tail -1 /tmp/player-last) metadata | grep -q 'chromium'; then
    icon=" "
    printformat='{{artist}} - {{title}}'
    stringlength='75'
  elif playerctl -p $(tail -1 /tmp/player-last) metadata | grep -q 'firefox'; then
    icon=" "
    printformat='{{artist}} - {{title}}'
    stringlength='75'
  else
    icon=" "
    printformat='{{artist}} - {{title}}'
    stringlength='75'
  fi
  echo "${icon}" $(playerctl -p $(tail -1 /tmp/player-last) metadata -f "${printformat}" 2>/dev/null | sed -E "s/(.{$stringlength}).+/\1.../")
else
  echo "                                  "
fi
