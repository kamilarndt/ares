#!/usr/bin/env python3
"""
ARES tmux Layout Engine — czyta layout.yaml i tworzy sesję tmux.
Zero zależności poza PyYAML (standard w Hermes).

Usage:
  python3 layout.py              # create/attach
  python3 layout.py --kill       # kill session
"""

import os, sys, subprocess, tempfile, textwrap, yaml

LAYOUT_PATH = os.path.join(os.path.dirname(__file__), "layout.yaml")
SCRIPTS_DIR = os.path.join(os.path.dirname(__file__), "scripts")

def tmux(*args, **kwargs):
    """Run tmux command, return CompletedProcess."""
    return subprocess.run(["tmux", *args], capture_output=True, text=True, **kwargs)

def session_exists(name):
    r = tmux("has-session", "-t", name)
    return r.returncode == 0

def kill_session(name):
    tmux("kill-session", "-t", name)

def create_session(layout):
    sess = layout["session"]
    name = sess["name"]

    # Kill existing
    kill_session(name)

    windows = sess.get("windows", [])
    if not windows:
        print("❌ No windows defined in layout")
        sys.exit(1)

    # Create first window
    w0 = windows[0]
    w0_name = w0["name"]
    w0_root = os.path.expanduser(w0.get("root", "~"))

    cmd = ["new-session", "-d", "-s", name, "-n", w0_name, "-c", w0_root]
    tmux(*cmd)

    # Add panes to first window
    add_panes(f"{name}:0", w0.get("panes", []), w0_root)

    # Create remaining windows
    for i, w in enumerate(windows[1:], start=1):
        w_name = w["name"]
        w_root = os.path.expanduser(w.get("root", "~"))
        tmux("new-window", "-t", name, "-n", w_name, "-c", w_root)
        add_panes(f"{name}:{i}", w.get("panes", []), w_root)

    # Status bar
    sb = layout.get("status_bar", {})
    if sb:
        if sb.get("left"):
            tmux("set-option", "-t", name, "-g", "status-left", sb["left"])
        if sb.get("right"):
            tmux("set-option", "-t", name, "-g", "status-right", sb["right"])
        if sb.get("interval"):
            tmux("set-option", "-t", name, "-g", "status-interval", str(sb["interval"]))
        tmux("set-option", "-t", name, "-g", "window-status-current-style", "bg=blue,fg=white")
        tmux("set-option", "-t", name, "-g", "window-status-format", " #I:#W ")
        tmux("set-option", "-t", name, "-g", "window-status-current-format", " #I:#W ")

    # Focus first pane
    tmux("select-window", "-t", f"{name}:0")
    tmux("select-pane", "-t", f"{name}:0.0")

    return name

def add_panes(target, panes, root):
    """Add panes to an existing window. First pane is already created."""
    for i, pane in enumerate(panes):
        if i == 0:
            commands = pane.get("commands", [])
            for cmd in commands:
                r = tmux("send-keys", "-t", f"{target}.0", cmd, "Enter")
                if r.returncode != 0:
                    print(f"⚠️ send-keys pane 0: {r.stderr}")
            continue

        split_dir = pane.get("split", "horizontal")
        flag = "-v" if split_dir == "vertical" else "-h"

        size = pane.get("size")
        size_args = ["-p", str(size)] if size else []

        r = tmux("split-window", flag, *size_args, "-t", target, "-c", root)
        if r.returncode != 0:
            print(f"⚠️ split-window pane {i}: {r.stderr}")
            continue

        commands = pane.get("commands", [])
        for cmd in commands:
            r2 = tmux("send-keys", "-t", f"{target}.{i}", cmd, "Enter")
            if r2.returncode != 0:
                print(f"⚠️ send-keys pane {i}: {r2.stderr}")

def main():
    if not os.path.exists(LAYOUT_PATH):
        print(f"❌ layout.yaml not found at {LAYOUT_PATH}")
        sys.exit(1)

    with open(LAYOUT_PATH) as f:
        layout = yaml.safe_load(f)

    name = layout["session"]["name"]

    if "--kill" in sys.argv:
        kill_session(name)
        print(f"✅ Session '{name}' killed.")
        return

    # Create session
    create_session(layout)

    # Attach or print instructions
    in_tmux = "TMUX" in os.environ
    if not in_tmux:
        os.execlp("tmux", "tmux", "attach-session", "-t", name)
    else:
        print(f"✅ ARES Command Center — {len(layout['session'].get('windows', []))} windows")
        for i, w in enumerate(layout["session"]["windows"]):
            panes = len(w.get("panes", [1]))
            print(f"  {i} {w['name']:12s} — {panes} pane{'s' if panes > 1 else ''}")
        print(f"\n  attach: tmux attach -t {name}")
        print(f"  kill:   python3 layout.py --kill")

if __name__ == "__main__":
    main()
