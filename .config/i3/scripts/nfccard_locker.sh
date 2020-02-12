#!/bin/bash

NFC_UID="UID(NFCID1):50e9ac27"
SHOULD_LOCK=false
FIRST_CONTACT=true
LOCK_SCRIPT="$HOME/.config/i3/scripts/lock"

function card_present(){
  res=$(nfc-list 2>/dev/null | tr -d ' ' | grep "$NFC_UID" | wc -l)
  [[ "$res" -eq 1 ]]
}

while true; do
  if card_present; then
    # echo "Read card"
    if $SHOULD_LOCK; then
      echo "Unlocking"
      # card just inserted, unlock
      killall i3lock 2>/dev/null
    fi
    SHOULD_LOCK=false
    FIRST_CONTACT=false
  else
    # echo "No card"
    if ! $FIRST_CONTACT && ! $SHOULD_LOCK; then
      echo "Locking"
      # card not present, but was before, lock
      SHOULD_LOCK=true
      ${LOCK_SCRIPT} 2>/dev/null &
    fi
  fi
done
