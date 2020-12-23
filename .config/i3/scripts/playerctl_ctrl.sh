#!/bin/bash

if [[ "$(playerctl -l | wc -l)" -eq 1 ]]; then
  playerctl $@
  exit 0
fi

nof_players=$(playerctl -l | tr '\n' ' ')
player_lock="/tmp/player.lock"
selected_player=0
last_player=0
player_extras=""

for player in ${nof_players[@]}; do
  state=$(playerctl -p $player status)
  if [[ "$state" == "Playing" ]]; then
    selected_player=$player
    break
  fi
done

if [[ -f $player_lock ]]; then
  last_player=$(cat $player_lock)
fi

if [[ "${selected_player}" == "0" && "${last_player}" != "0" ]]; then
  selected_player=$last_player
fi

if [[ "${selected_player}" != "0" ]]; then
  player_extras="-p $selected_player"
fi

# echo "Selected player $selected_player"
playerctl $player_extras $@
echo "$selected_player" > /tmp/player.lock

