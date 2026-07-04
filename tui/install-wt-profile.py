#!/usr/bin/env python3
"""Add ARES Command Center profile to Windows Terminal settings.json"""
import json, os

SETTINGS = "/mnt/c/Users/user/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"

ARES_PROFILE = {
    "name": "ARES Command Center",
    "commandline": "wsl.exe -d Ubuntu-D tmux new-session -A -s ares-cmd",
    "icon": "🐺",
    "tabTitle": "ARES CMD",
    "startingDirectory": "\\\\wsl$\\Ubuntu-D\\root\\autonomous-agent",
    "colorScheme": "Campbell",
    "font": {"face": "Cascadia Mono", "size": 11},
    "padding": "8, 8, 8, 8",
    "cursorShape": "filledBox",
    "useAcrylic": True,
    "acrylicOpacity": 0.85,
    "closeOnExit": "graceful",
    "suppressApplicationTitle": True
}

with open(SETTINGS) as f:
    config = json.load(f)

profiles = config["profiles"]["list"]

# Check if already exists
exists = any(p.get("name") == "ARES Command Center" for p in profiles)
if exists:
    print("✅ Profile already exists")
else:
    profiles.append(ARES_PROFILE)
    # Write back with proper Windows line endings
    with open(SETTINGS, "w", newline='\r\n') as f:
        json.dump(config, f, indent=4)
    print("✅ Profile added to Windows Terminal")

# Verify
with open(SETTINGS) as f:
    cfg = json.load(f)
names = [p.get("name") for p in cfg["profiles"]["list"]]
assert "ARES Command Center" in names
print(f"   Total profiles: {len(names)}")
