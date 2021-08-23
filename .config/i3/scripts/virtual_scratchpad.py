#!/usr/bin/env python

import i3
import json
import argparse

from pathlib import Path
from singleton import Singleton

scratchpad_file = "/tmp/virtual_scratchpad"
lock_file = "/tmp/virtual_scratchpad.lock"


def parse_flags():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--show", "-s", action="store_true",
        help="Show virtual scratchpad"
    )
    parser.add_argument(
        "--toggle", "-t", action="store_true",
        help="Toggle focused window to virtual scratchpad"
    )
    parser.add_argument(
        "--floating", "-f", action="store_true",
        help="Make added windows floating"
    )
    args = parser.parse_args()
    if (args.show and args.toggle) or (not args.show and not args.toggle):
        raise ValueError(
            "Must either choose to show the "
            "scratchpad or toggle window to scratchpad!"
        )

    return args


def parse_scratchpad():
    global scratchpad_file
    scratchpad = {"windows": []}
    if Path(scratchpad_file).exists():
        scratchpad = json.load(open(scratchpad_file, "r"))
        scratchlist = []
        for win_id in scratchpad["windows"]:
            # validation, if not found, window does not exist anymore
            win = get_id_from_filtered(filter(id=win_id))
            if win is not None:
                scratchlist.append(win)
        scratchpad["windows"] = scratchlist
    return scratchpad


def save_scratchpad(scratchpad):
    global scratchpad_file
    with open(scratchpad_file, "w") as fout:
        fout.write(json.dumps(scratchpad) + "\n")


def unshift(arr):
    arr.reverse()
    val = arr.pop()
    arr.reverse()
    return val


def filter(tree=None, function=None, **conditions):
    if tree is None:
        tree = i3.get_tree()
    elif isinstance(tree, list):
        tree = {"list": tree}

    matches = []
    if function:
        try:
            if function(tree):
                return [tree]
        except (KeyError, IndexError):
            pass
    else:

        for key, value in conditions.items():
            if key in tree and tree[key] == value:
                matches.append(tree)

    for nodes in ["nodes", "floating_nodes", "list"]:
        if nodes in tree:
            for node in tree[nodes]:
                matches += filter(node, function, **conditions)
    return matches


def get_id_from_filtered(filtered):
    id = None
    if len(filtered):
        id = filtered[0]["id"]
    return id


def get_focused_window_id(throw=True):
    win_id = get_id_from_filtered(filter(focused=True))
    if win_id is None or not isinstance(win_id, (int, str)):
        raise RuntimeError(f"Unable to fetch focused window ID: {win_id}")
    return win_id


def get_focused_workspace(prop=None):
    if prop is None:
        prop = "id"
    workspaces = i3.get_workspaces()
    focused = [w for w in workspaces if w["focused"]]
    if len(focused) == 0:
        raise ValueError(
            "Unable to fetch current workspace" +
            json.dumps(i3.get_workspaces(), indent=2)
        )
    focused = focused[0]
    return focused[prop]


def toggle_window_to_scratchpad(win_id, floating):
    scratchpad = parse_scratchpad()
    scratchlist = scratchpad["windows"]
    if win_id in scratchlist:
        added = False
        scratchlist.remove(win_id)
    else:
        added = True
        scratchlist.append(win_id)
    if floating:
        i3.command(f'[con_id="{win_id}"] floating toggle')
    scratchpad["windows"] = scratchlist
    save_scratchpad(scratchpad)
    return added


def hide_window(win_id):
    i3.command(f'[con_id="{win_id}"] move to workspace 11')


def show_window(win_id):
    focused_id = get_focused_workspace(prop="num")
    i3.command(f'[con_id="{win_id}"] move to workspace {focused_id}')
    i3.command(f'[con_id="{win_id}"] focus')


# adds/removes the focused window to scratchpad
def toggle_to_scratchpad(floating):
    win_id = get_focused_window_id()
    if toggle_window_to_scratchpad(win_id, floating):
        hide_window(win_id)


def show_scratchpad():
    scratchpad = parse_scratchpad()
    scratchlist = scratchpad["windows"]
    if len(scratchlist):
        visible_id = scratchpad.get("visible", None)
        if visible_id is None:
            next_win_id = unshift(scratchlist)
            for win in scratchlist:
                hide_window(win)
            show_window(next_win_id)
            scratchlist.append(next_win_id)
            scratchpad["visible"] = next_win_id
            save_scratchpad(scratchpad)
        else:
            hide_window(visible_id)
            scratchlist.remove(visible_id)
            scratchlist.append(visible_id)
            del scratchpad["visible"]

        scratchpad["windows"] = scratchlist
        save_scratchpad(scratchpad)


def main(toggle=False, show=False, floating=False):
    global lock_file
    singleton = Singleton(lock_path=lock_file, port=1415)
    if not singleton.start():
        singleton.stop(wakeup_singleton=False, close_app=True)

    if toggle:
        toggle_to_scratchpad(floating)
    elif show:
        show_scratchpad()

    singleton.stop(close_app=True)


if __name__ == '__main__':
    main(**vars(parse_flags()))
