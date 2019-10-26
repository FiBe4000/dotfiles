#! /bin/sh
#in sxhkdrc call it with
#alt + {1-9,0}
#     summonworkspace.sh {1-9,0}
dsktps=(Web Terminals Code Mail Chat Music VM Etc1 Etc2 Etc3)
dsktp=${dsktps[$@-1]}

monitor=$(bspc query --monitors --desktop $dsktp); \
if [ $(bspc query --monitors --monitor focused) != $monitor ]; then \
  bspc desktop $dsktp --swap $(bspc query -M -m focused):focused; \
else
  bspc desktop $dsktp --focus; \
fi

