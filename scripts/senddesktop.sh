#! /bin/sh

dsktps=(Web Terminals Code Mail Chat Music VM Etc1 Etc2 Etc3 Etc4 Etc5)
dsktp=${dsktps[$@-1]}

bspc node -d $dsktp
