#!/bin/bash

# Change the question marks to your profile id. The thunderbird plugin Unread-counts need to be installed for this to work.
str=$(echo $(head -c 4 ~/.thunderbird/??????.default/unread-counts))
str2=$(echo $str | grep -o -E '[0-9]+' | head -1) # | sed -e 's/^0\+//')
icon="<icon=$HOME/.xmonad/icons/mail.xbm/>"

if [[ $str == "Coun" ]]; then
    echo "<fc=#993737>$icon</fc>"
elif [[ "$str2" -lt 1 ]]; then
    echo $icon
elif [[ "$str2" -ge 1 && "$str2" -le 5 ]]; then
    echo "<fc=#23648e>$icon"  "$str2</fc>"
elif [[ "$str2" -ge 5 ]]; then
    echo "<fc=#993737>$icon"  "$str2</fc>"
else
    echo "Error"
fi
