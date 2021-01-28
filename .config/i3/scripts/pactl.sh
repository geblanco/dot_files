#!/bin/bash

get_active_sink() {
  # best effort to distinguish between input/output: sort and tail
  echo $(pactl list |\
    grep -i 'State: RUNNING' -A 1 |\
    grep 'Name: ' |\
    awk '{print $NF}' |\
    sort |\
    tail -n 1
  )
}

if [[ "$#" -lt 2 ]]; then
  echo "Usage pactl.sh <action (volume|mute)> <value (+-N%|toggle)"
  exit 0
else
  action="$1"
  args="$2"
fi

pactl set-sink-$action "$(get_active_sink)" $args
