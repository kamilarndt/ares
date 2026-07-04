#!/bin/bash
# ARES Command Center — live activity log
# Pokazuje output agentów ARES w czasie rzeczywistym.

ARES_DIR="$HOME/autonomous-agent"
LOG_DIR="$HOME/.hermes/logs"

while true; do
  clear
  echo "═══════════════════════════════════════════════════════════════════════════"
  echo "  📡  A R E S   A C T I V I T Y   L O G     $(date '+%H:%M:%S')"
  echo "═══════════════════════════════════════════════════════════════════════════"
  echo ""

  # Szukaj logów
  FOUND=false

  # Omnigent logs
  if ls "$ARES_DIR/.omnigent/logs/"* 2>/dev/null; then
    tail -20 "$ARES_DIR/.omnigent/logs/"* 2>/dev/null | tail -30
    FOUND=true
  fi

  # Hermes logs
  if ls "$LOG_DIR"/*.log 2>/dev/null; then
    ls -t "$LOG_DIR"/*.log 2>/dev/null | head -3 | while read f; do
      echo "─── $(basename $f) ───"
      tail -10 "$f" 2>/dev/null
    done
    FOUND=true
  fi

  # Session history
  if command -v session_search &>/dev/null; then
    echo "  [agent activity will appear here when ARES runs]"
  fi

  if [ "$FOUND" = false ]; then
    echo "  ⏳  Czekam na aktywność ARES..."
    echo ""
    echo "  Aby uruchomić ARES, przejdź do okna shell (Ctrl+b 2) i wpisz:"
    echo "    cd ~/autonomous-agent"
    echo "    omnigent run config.yaml --prompt \"Scout: znajdź opportunity\""
    echo ""
    echo "  Automatycznie zobaczysz tu logi agentów."
  fi

  echo ""
  echo "  ↻ Odświeżanie co 10s..."
  sleep 10
done
