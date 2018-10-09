#!/bin/bash

awk '{if(l1){print ($2-l1)/1024"kB/s",($10-l2)/1024"kB/s"} else{l1=$2; l2=$10;}}' <(grep wlp2s0 /proc/net/dev) <(sleep 1; grep wlp2s0 /proc/net/dev)

wlp2s0d=''
eth=''
