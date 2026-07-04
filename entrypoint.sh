#!/bin/bash
# MoneyForge Omnigent Sandbox — entrypoint
set -e

echo "=== MoneyForge ARES — Omnigent Sandbox ==="
echo "Starting Omnigent server..."

# If CMD is passed, run it instead
if [ $# -gt 0 ]; then
    exec "$@"
fi

# Start Omnigent server
cd /home/omnigent
omnigent server start --host 0.0.0.0 --port 6767 &

# Keep container alive
tail -f /dev/null
