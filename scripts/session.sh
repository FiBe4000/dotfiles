#!/bin/bash

if [ "$1" = "home" ]; then
  # Launch Steam if not already running
  if ! pgrep -x "steam" > /dev/null; then
    echo "launching steam"
    nohup steam-runtime $ > /dev/null &
  fi

  # Launch Discord if not already running
  if ! pgrep -x "Discord" > /dev/null; then
    echo "launching discord"
    nohup discord $ > /dev/null &
  fi

  # Launch Chrome if not already running
  if ! pgrep -x "chrome" > /dev/null; then
    echo "launching chrome"
    nohup google-chrome-unstable & > /dev/null &
  fi
elif [ "$1" = "work" ]; then
  # Launch Teams if not already running
  if ! pgrep -x "teams" > /dev/null; then
    echo "launching teams"
    nohup teams & > /dev/null &
  fi

  # Launch Chrome if not already running
  if ! pgrep -x "chrome" > /dev/null; then
    echo "launching chrome"
    nohup google-chrome-unstable & > /dev/null &
  fi
fi

