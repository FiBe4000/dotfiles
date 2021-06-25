#!/bin/bash

dnd=`cat /tmp/dnd.dat`

if [ $dnd == "false" ]; then
  echo -n " "; spotifyctl -q status --format '%artist% - %title%' --max-length 80 --trunc '...'
else
  echo "                                  "
fi

