# ARES Command Center — Centrum Dowodzenia

## Co to jest

4-okienny tmux do monitorowania i sterowania systemem ARES.

## Uruchomienie

```bash
ares-cmd           # Włącz
ares-cmd kill      # Wyłącz
tmux attach -t ares-cmd  # Dołącz z innego terminala
```

## Windows Terminal Profile

Dodaj do `settings.json` (Ctrl+Shift+, w Windows Terminal):

```json
{
    "name": "ARES Command Center",
    "commandline": "wsl.exe -d Ubuntu-D bash -c /root/autonomous-agent/tui/ares-cmd.sh",
    "icon": "🐺",
    "tabTitle": "ARES CMD",
    "font": {"face": "Cascadia Mono", "size": 11},
    "useAcrylic": true,
    "acrylicOpacity": 0.85,
    "closeOnExit": "graceful"
}
```

## Układ

```
┌── 0: status ─────────────────────────────────────────┐
│                                                       │
│  ┌──── SYSTEM ────┐   ┌──── AGENTS (12/12) ───────┐ │
│  │ ✅ OmniRoute    │   │ scout ✅ 0.2s bidder ✅ 0.3│ │
│  │ CPU 82% · RAM   │   │ ... 12 agentów            │ │
│  │ Repo: main      │   │                           │ │
│  ├──── BUDGET ─────┤   ├──── TOOLS ────────────────┤ │
│  │ $0/$5 [░░] 0%   │   │ opencode ✅ pi ✅ hermes ✅│ │
│  └─────────────────┘   └───────────────────────────┘ │
│                                                       │
│  Windows: 0=status  1=logs  2=shell  3=model-tui     │
└───────────────────────────────────────────────────────┘

┌── 1: logs ──────────────────────────────────────────┐
│  Live output agentów ARES w czasie rzeczywistym      │
└──────────────────────────────────────────────────────┘

┌── 2: shell ─────────────────────────────────────────┐
│  Terminal do uruchamiania ARES:                      │
│  omnigent run config.yaml --prompt "Scout: ..."      │
│  git status, docker, systemctl                       │
└──────────────────────────────────────────────────────┘

┌── 3: model-tui ─────────────────────────────────────┐
│  Monitoring modeli i kosztów (jeśli zainstalowane)   │
└──────────────────────────────────────────────────────┘
```

## Nawigacja

| Ctrl+b + ... | Funkcja |
|--------------|---------|
| `0` | Status (widok główny) |
| `1` | Logi agentów |
| `2` | Shell (uruchamiaj ARES) |
| `3` | model-tui |
| `d` | Odłącz (sesja w tle) |
| `[` | Scroll (q — wyjście) |
