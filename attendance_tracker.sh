#!/bin/zsh
# attendance_tracker.sh
# Usage: ./attendance_tracker.sh <input>

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <input>"
  exit 1
fi

TRACKER_DIR="attendance_tracker_$1"
HELPERS_DIR="$TRACKER_DIR/Helpers"
REPORTS_DIR="$TRACKER_DIR/reports"
ARCHIVE_NAME="attendance_tracker_${1}_archive.tar.gz"

# Trap for SIGINT
cleanup_and_archive() {
  echo "\nCaught interrupt. Archiving and cleaning up..."
  tar -czf "$ARCHIVE_NAME" "$TRACKER_DIR"
  rm -rf "$TRACKER_DIR"
  echo "Archived as $ARCHIVE_NAME and cleaned up."
  exit 130
}
trap cleanup_and_archive SIGINT

# Health check for python3
if command -v python3 >/dev/null 2>&1; then
  echo "[OK] python3 is installed: $(python3 --version)"
else
  echo "[WARNING] python3 is NOT installed."
fi

# Create directory structure
mkdir -p "$HELPERS_DIR" "$REPORTS_DIR"

# Copy required files (assumes they are in the current directory)
cp attendance_checker.py "$TRACKER_DIR/attendance_checker.py"
cp assets.csv "$HELPERS_DIR/assets.csv"
cp config.json "$HELPERS_DIR/config.json"
cp reports.log "$REPORTS_DIR/reports.log"
if [ -f image.png ]; then
  cp image.png "$TRACKER_DIR/image.png"
fi

echo "Directory structure created in $TRACKER_DIR."

# Prompt for config update
read "?Do you want to update attendance thresholds? (y/N): " update
if [[ "$update" =~ ^[Yy]$ ]]; then
  read "?Enter new Warning threshold (default 75): " warn
  read "?Enter new Failure threshold (default 50): " fail
  warn=${warn:-75}
  fail=${fail:-50}
  # Validate numeric input
  if ! [[ "$warn" =~ ^[0-9]+$ ]] || ! [[ "$fail" =~ ^[0-9]+$ ]]; then
    echo "Error: Both thresholds must be numeric. Aborting config update."
    echo "Thresholds unchanged."
  else
    sed -i '' -E "s/(\"Warning\":)[ ]*[0-9]+/\1 $warn/" "$HELPERS_DIR/config.json"
    sed -i '' -E "s/(\"Failure\":)[ ]*[0-9]+/\1 $fail/" "$HELPERS_DIR/config.json"
    echo "Thresholds updated in config.json."
  fi
else
  echo "Thresholds unchanged."
fi

echo "Setup complete."
