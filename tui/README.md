# ARES Command Center — Windows Terminal Profile

## Instalacja

### 1. Działanie w WSL
Sesja tmux została już utworzona. Możesz do niej dołączyć z terminala WSL:
```bash
tmux attach -t ares-cmd
```
lub
```bash
ares-cmd
```

### 2. Windows Terminal Profile (GUI)

Dodaj poniższy profil do `settings.json` Windows Terminal:
(otwórz Windows Terminal → Ctrl+Shift+, (przecinek) → znajdź `"profiles": {"list": [...]}` → wklej)

```json
{
    "name": "ARES Command Center",
    "commandline": "wsl.exe -d Ubuntu-D tmux new-session -A -s ares-cmd",
    "icon": "🐺",
    "startingDirectory": "\\\\wsl$\\Ubuntu-D\\root\\autonomous-agent",
    "tabTitle": "ARES CMD",
    "colorScheme": "Campbell",
    "font": {
        "face": "Cascadia Mono",
        "size": 11
    },
    "padding": "8, 8, 8, 8",
    "cursorShape": "filledBox",
    "useAcrylic": true,
    "acrylicOpacity": 0.85,
    "closeOnExit": "graceful",
    "suppressApplicationTitle": true
}
```

> **Uwaga:** Jeśli Twoja dystrybucja WSL ma inną nazwę niż `Ubuntu-D`, zmień `wsl.exe -d Ubuntu-D` na odpowiednią:
> ```bash
> wsl -l -v   # Lista dystrybucji WSL
> ```

### 3. Skrót na pulpicie Windows

Stwórz plik `ARES Cmd.url` na pulpicie:
```
[InternetShortcut]
URL=wt.exe -p "ARES Command Center"
```

## Układ okien (wide screen)

```
┌────────── Window 0: DASHBOARD ──────────────────┐
│  ┌────────────┬────────────┬──────────────────┐ │
│  │   HEALTH   │    COST    │     BUDGET        │ │
│  │  OmniRoute │  $0.00/d   │  [████░░░░]      │ │
│  │  System    │  Provider  │  $3 ask / $5 cap │ │
│  │  Tools     │  7d trend  │  Tier progress   │ │
│  ├────────────┴────────────┴──────────────────┤ │
│  │           AGENT ACTIVITY FEED               │ │
│  │  (live logs + periodic health checks)       │ │
│  └─────────────────────────────────────────────┘ │
├────────── Window 1: AGENTS ─────────────────────┤
│  ✅ scout (pi)     ✅ implementer (opencode)     │
│  ✅ bidder (pi)    ✅ reviewer (pi)              │
│  ✅ deliverer(pi)  ✅ financier (pi)             │
│  ✅ sdr(hermes)    ✅ aeo (opencode)             │
│  ✅ trader(pi)     ✅ council (pi)               │
│  ✅ insight(hermes)✅ war-room (pi)              │
├────────── Window 2: CONTROL ────────────────────┤
│  Git status (left)  │  Quick commands (right)   │
├────────── Window 3: MODEL-TUI ──────────────────┤
│  Live model feed, token usage, budget           │
├────────── Window 4: ARES-RUN ───────────────────┤
│  Launch and monitor ARES agents                 │
├────────── Window 5: SHELL ──────────────────────┤
│  Ad-hoc terminal                                 │
└─────────────────────────────────────────────────┘
```

## Nawigacja tmux

| Skrót | Funkcja |
|-------|---------|
| `Ctrl+b 0-5` | Przełącz okno |
| `Ctrl+b n/p` | Następne/poprzednie okno |
| `Ctrl+b d` | Odłącz (sesja działa w tle) |
| `Ctrl+b [` | Scroll (q-wyjście) |
| `Ctrl+b %` | Split pionowy |
| `Ctrl+b "` | Split poziomy |
| `Ctrl+b →/←` | Nawigacja między panelami |

## Komendy

```bash
ares-cmd          # Utwórz lub dołącz do sesji
ares-cmd kill     # Zatrzymaj sesję
tmux attach -t ares-cmd   # Dołączenie z innego terminala
```
