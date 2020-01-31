#! /usr/bin/env python

from __future__ import print_function
from smartcard.scard import *
import smartcard.util
import subprocess

def printstate(state):
  reader, eventstate, atr = state
  print(reader + " " + smartcard.util.toHexString(atr, smartcard.util.HEX))
  if eventstate & SCARD_STATE_ATRMATCH:
    print('\tCard found')
  if eventstate & SCARD_STATE_UNAWARE:
    print('\tState unware')
  if eventstate & SCARD_STATE_IGNORE:
    print('\tIgnore reader')
  if eventstate & SCARD_STATE_UNAVAILABLE:
    print('\tReader unavailable')
  if eventstate & SCARD_STATE_EMPTY:
    print('\tReader empty')
  if eventstate & SCARD_STATE_PRESENT:
    print('\tCard present in reader')
  if eventstate & SCARD_STATE_EXCLUSIVE:
    print('\tCard allocated for exclusive use by another application')
  if eventstate & SCARD_STATE_INUSE:
    print('\tCard in used by another application but can be shared')
  if eventstate & SCARD_STATE_MUTE:
    print('\tCard is mute')
  if eventstate & SCARD_STATE_CHANGED:
    print('\tState changed')
  if eventstate & SCARD_STATE_UNKNOWN:
    print('\tState unknowned')

def is_card_just_inserted(state):
  _, eventstate, _ = state
  return (eventstate & SCARD_STATE_PRESENT) and (eventstate & SCARD_STATE_CHANGED)

def is_card_just_removed(state):
  _, eventstate, _ = state
  return (eventstate & SCARD_STATE_EMPTY) and (eventstate & SCARD_STATE_CHANGED)

def get_context():
  # let the exception to raise
  hresult, hcontext = SCardEstablishContext(SCARD_SCOPE_USER)
  if hresult != SCARD_S_SUCCESS:
    raise error(
      'Failed to establish context: ' + \
      SCardGetErrorMessage(hresult))
  print('Context established!')
  return hcontext

def get_reader(hcontext):
  # let the exception to raise
  hresult, readers = SCardListReaders(hcontext, [])
  if hresult != SCARD_S_SUCCESS:
    raise error(
      'Failed to list readers: ' + \
      SCardGetErrorMessage(hresult))
  print('PCSC Readers:', readers)

  readerstates = [(readers[0], SCARD_STATE_UNAWARE)]
  print('----- Current reader and card states are: -------')
  hresult, newstates = SCardGetStatusChange(hcontext, 0, readerstates)
  for i in newstates:
    printstate(i)
  return newstates

def disconnect(hcontext):
  # let the exception to raise
  hresult = SCardReleaseContext(hcontext)
  if hresult != SCARD_S_SUCCESS:
    raise error(
      'Failed to release context: ' + \
      SCardGetErrorMessage(hresult))
  print('Released context.')

def unlock():
  subprocess.run(['killall', 'i3lock'])

def lock():
  subprocess.run(['/home/gb/.config/i3/scripts/lock'])

def loop(hcontext, states):
  if is_card_just_removed(states[0]):
    start_empty = True
    print('Started with empty reader, not locking')
  else:
    start_empty = False
  # ToDo := Do this in another thread so Ctrl-C can be registered
  while True:
    hresult, states = SCardGetStatusChange(
                              hcontext,
                              INFINITE,
                              states)

    if start_empty:
      start_empty = False
      continue
    print('New card state')
    if is_card_just_inserted(states[0]):
      print('-> Card inserted')
      unlock()
    elif is_card_just_removed(states[0]):
      print('-> Card removed')
      lock()

def main():
  hcontext = get_context()
  readerstates = get_reader(hcontext)
  loop(hcontext, readerstates)
  disconnect(hcontext)

if __name__ == '__main__':
  main()
