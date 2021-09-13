#!/bin/bash
#all_monitors=$(xrandr -q | awk '/connected/ {print $1}')
#default_screen=$(xrandr | awk '/ connected/ {print $1;exit;}')
#extra_monitors=$(xrandr -q | awk '/connected/ {print $1}' | grep -v $default_screen)

##First, configure stuff with xrandr
#[[ $(who) != "" ]] && USER=$(who | grep :0\) | cut -f 1 -d ' ') || \
#USER=$(echo /home/* | cut -f 3 -d '/')

#export DISPLAY=:0.0
#export XAUTHORITY=/home/$USER/.Xauthority

#for monitor in $extra_monitors; do
#	prev_mon=$(xrandr | awk '/connected/ {print $1}' | grep -B1 "^$monitor" | grep -vE "^$monitor|^--$")
#	xrandr --output $monitor \
#		--auto \
#		--right-of $prev_mon
#done

##Then, create workspaces on all monitors
  I=1
  M=$(bspc query -M | wc -l)
  if [[ "$M" == 1 ]]; then
    bspc monitor -d Web Terminals Code Mail Chat Music VM Etc1 Etc2 Etc3
  elif [[ "$M" == 2 ]]; then
     bspc monitor $(bspc query -M | awk NR==1) -n left
     bspc monitor $(bspc query -M | awk NR==2) -n main
     bspc monitor main -d Web Terminals Code Mail Chat
     bspc monitor left -d Music VM Etc1 Etc2 Etc3
  elif [[ "$M" == 3 ]]; then
     bspc monitor $(bspc query -M | awk NR==1) -n left
     bspc monitor $(bspc query -M | awk NR==2) -n main
     bspc monitor $(bspc query -M | awk NR==3) -n right
     bspc monitor left -d Chat Music VM Etc1 
     bspc monitor main -d Web Terminals Code Mail
     bspc monitor right -d Etc2 Etc3 Etc4 Etc5
  elif [[ "$M" == 4 ]]; then
     bspc monitor $(bspc query -M | awk NR==1) -d Web Terminals Code
     bspc monitor $(bspc query -M | awk NR==2) -d Mail Chat Music
     bspc monitor $(bspc query -M | awk NR==3) -d VM Etc1
     bspc monitor $(bspc query -M | awk NR==4) -d Etc2 Etc3
  elif [[ "$M" == 5 ]]; then
     bspc monitor $(bspc query -M | awk NR==1) -d Web Terminals
     bspc monitor $(bspc query -M | awk NR==2) -d Code Mail
     bspc monitor $(bspc query -M | awk NR==3) -d Chat Music
     bspc monitor $(bspc query -M | awk NR==4) -d VM Etc1
     bspc monitor $(bspc query -M | awk NR==5) -d Etc2 Etc3
  else
    for monitor in $(bspc query -M); do
    bspc monitor $monitor \
        -n "$I" \
        -d $I/{a,b,c}
     let I++
     done
  fi

