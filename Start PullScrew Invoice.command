#!/bin/bash
# Double-click this to run PullScrew Invoice with live-file saving enabled.
#
# Why this exists: a page opened straight from disk (file://) has no origin,
# and browsers refuse those pages direct access to write a file. Serving the
# same file over localhost gives it a real origin, which unlocks
# Settings -> Live copy on disk, where every change writes straight to a .json.
#
# The port is fixed on purpose. Browser storage is keyed to the origin, and
# the origin includes the port — change it and the app looks empty.

PORT=8777
cd "$(dirname "$0")" || exit 1

if [ ! -f PullScrewInvoice.html ]; then
  echo "Can't find PullScrewInvoice.html next to this launcher."
  echo "Keep both files in the same folder."
  read -r -p "Press return to close."
  exit 1
fi

# Already running from an earlier launch? Just open a tab.
if curl -s -o /dev/null --max-time 2 "http://localhost:$PORT/PullScrewInvoice.html"; then
  echo "Already running on port $PORT — opening a tab."
  open "http://localhost:$PORT/PullScrewInvoice.html"
  exit 0
fi

if command -v python3 >/dev/null 2>&1; then
  SERVER=(python3 -m http.server "$PORT" --bind 127.0.0.1)
elif command -v python >/dev/null 2>&1; then
  SERVER=(python -m SimpleHTTPServer "$PORT")
else
  echo "No python found, so the live-file version can't start."
  echo "Opening the app normally instead — everything works except"
  echo "'Live copy on disk'. Use Settings -> Export backup to keep copies."
  echo
  open PullScrewInvoice.html
  read -r -p "Press return to close."
  exit 0
fi

echo "PullScrew Invoice"
echo "================="
echo "Running at http://localhost:$PORT/PullScrewInvoice.html"
echo
echo "Leave this window open while you work."
echo "Close it (or press Ctrl-C) to stop."
echo

"${SERVER[@]}" >/dev/null 2>&1 &
SRV=$!
trap 'kill $SRV 2>/dev/null' EXIT INT TERM

sleep 1
open "http://localhost:$PORT/PullScrewInvoice.html"
wait $SRV
