#!/usr/bin/env sh

# Terminate if called by ppid 1, avoids duplicated polybars
if [[ $PPID -ne 1 ]]; then
  exit
fi

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

screens=$(xrandr -q | grep " connected" | cut -d ' ' -f1 | sort -u)

today=$(date +%Y-%m-%d)

echo "Cleaning log"
if [[ "$(ls -t | awk '{ if (length($NF) > 4) print }' | wc -l)" -gt 6 ]]; then
  for file in $(ls -t | awk '{ if (length($NF) > 4) print }' | tail -n 6); do
    rm "$file"
  done
fi

# Launch bar1 and bar2
for screen in $screens; do
  MONITOR=$screen polybar main -c ~/.config/polybar/working -l info 1>&2 2>~/.config/polybar/log/$today-app.log &
done

echo "Bars launched..."
