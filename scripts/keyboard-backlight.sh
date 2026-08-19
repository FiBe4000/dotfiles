#!/bin/bash

if [ "${1}" == "pre" ]; then
echo ""

elif [ "${1}" == "post" ]; then
brightnessctl -q -d tpacpi::kbd_backlight set 100%
fi
