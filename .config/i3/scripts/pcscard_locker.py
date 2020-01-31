#! /usr/bin/env python

from __future__ import print_function
from time import sleep

from smartcard.CardMonitoring import CardMonitor, CardObserver
from smartcard.util import toHexString
from subprocess import run

import sys, signal

CARD_ID = '3B 6F 00 00 80 66 B0 07 01 01 07 07 53 02 31 10 82 90 00'
LOCK_SCRIPT = '/home/gb/.config/i3/scripts/lock'

def signal_handler(signal, frame):
  print('Exit')
  sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

def unlock():
  print('unlocking')
  run(['killall', 'i3lock'])

def lock():
  print('locking')
  run([LOCK_SCRIPT])

# a simple card observer that prints inserted/removed cards
class PrintObserver(CardObserver):
  def check_card_id(self, card):
    return toHexString(card.atr) == CARD_ID

  def update(self, observable, actions):
    (addedcards, removedcards) = actions
    should_lock = len(addedcards) == 1 and len(removedcards) == 0
    if len(addedcards) == 1:
      should_lock = False
      card = addedcards[0]
    elif len(removedcards) == 1:
      should_lock = True
      card = removedcards[0]
    else:
      return
    if self.check_card_id(card):
      if should_lock:
        lock()
      else:
        unlock()

def main():
  print('Insert or remove a smartcard in the system.')
  print('')
  cardmonitor = CardMonitor()
  cardobserver = PrintObserver()
  cardmonitor.addObserver(cardobserver)

  while True:
    sleep(1)

  cardmonitor.deleteObserver(cardobserver)

if __name__ == '__main__':
  main()