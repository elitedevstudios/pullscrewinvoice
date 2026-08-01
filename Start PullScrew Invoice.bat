@echo off
REM Double-click this to run PullScrew Invoice with live-file saving enabled.
REM
REM A page opened straight from disk (file://) has no origin, and browsers
REM refuse those pages direct access to write a file. Serving the same file
REM over localhost gives it a real origin, which unlocks
REM Settings -> Live copy on disk, where every change writes straight to a .json.
REM
REM The port is fixed on purpose. Browser storage is keyed to the origin, and
REM the origin includes the port - change it and the app looks empty.

set PORT=8777
cd /d "%~dp0"

if not exist PullScrewInvoice.html (
  echo Can't find PullScrewInvoice.html next to this launcher.
  echo Keep both files in the same folder.
  pause
  exit /b 1
)

where python >nul 2>&1
if %errorlevel%==0 goto serve

where py >nul 2>&1
if %errorlevel%==0 goto servepy

echo No Python found, so the live-file version can't start.
echo Opening the app normally instead - everything works except
echo "Live copy on disk". Use Settings -^> Export backup to keep copies.
echo.
start "" PullScrewInvoice.html
pause
exit /b 0

:serve
echo PullScrew Invoice
echo =================
echo Running at http://localhost:%PORT%/PullScrewInvoice.html
echo.
echo Leave this window open while you work. Close it to stop.
echo.
start "" "http://localhost:%PORT%/PullScrewInvoice.html"
python -m http.server %PORT% --bind 127.0.0.1
exit /b 0

:servepy
echo PullScrew Invoice
echo =================
echo Running at http://localhost:%PORT%/PullScrewInvoice.html
echo.
echo Leave this window open while you work. Close it to stop.
echo.
start "" "http://localhost:%PORT%/PullScrewInvoice.html"
py -m http.server %PORT% --bind 127.0.0.1
exit /b 0
