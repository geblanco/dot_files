#!/bin/bash
pac=$(pacman -Qu 2> /dev/null | grep -v '\[.*\]' | wc -l)
aur=$(cower -u | wc -l)
check=0
pac_text="?"

if [[ $? -ne 0 ]]; then
  pac=0
else
  pac_text=$pac
fi

check=$((pac + aur))
if [[ "$check" != "0" ]]
then
  echo "$pac_text %{F#5b5b5b}%{F-} $aur"
fi
