# Automated Project Bootstrapping & Process Management
VIDEO URL =

## Overview
This project provides a shell script to automate the setup of a Student Attendance Tracker workspace. The script ensures reproducibility, efficiency, and reliability by creating the required directory structure, configuring settings, and handling interruptions gracefully.

## Directory Structure
When you run the script, it creates a directory named `attendance_tracker_{input}` (where `{input}` is a string you provide). Inside, you'll find:

```
attendance_tracker_{input}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
├── reports/
│   └── reports.log
└── image.png (optional, if present in the source directory)
```

## How to Run
1. Make sure you have `python3` installed.
2. Place your source files (`attendance_checker.py`, `assets.csv`, `config.json`, `reports.log`, and optionally `image.png`) in the same directory as `attendance_tracker.sh`.
3. Run the script:
   ```sh
   chmod +x attendance_tracker.sh
   ./attendance_tracker.sh your_input
   ```
   Replace `your_input` with any string to name your tracker directory.

## Features
- **Dynamic Configuration:**
  - The script prompts you to update attendance thresholds (Warning and Failure) and validates that your input is numeric before updating `config.json` using `sed`.
- **Health Check:**
  - Checks if `python3` is installed and prints the version.
- **Signal Trap & Cleanup:**
  - If you press Ctrl+C during execution, the script will archive the incomplete directory as `attendance_tracker_{input}_archive.tar.gz` and remove the incomplete directory to keep your workspace clean.
- **Error Handling:**
  - The script exits on errors and will not overwrite existing files without warning.

## Archive Feature
- If interrupted (SIGINT/Ctrl+C), the script will:
  1. Archive the current state of the project directory.
  2. Delete the incomplete directory.
  3. Print a message indicating the archive location.

## Notes
- All file and folder names must match exactly as shown above for the script and Python logic to work.
- For full marks, ensure your GitHub repo is named `deploy_agent_GithubUsername` and provide a video walkthrough as required by your rubric.

## Example
```
$ ./attendance_tracker.sh test_run
[OK] python3 is installed: Python 3.9.6
Directory structure created in attendance_tracker_test_run.
Do you want to update attendance thresholds? (y/N): y
Enter new Warning threshold (default 75): 70
Enter new Failure threshold (default 50): 40
Thresholds updated in config.json.
Setup complete.
```

If you have any questions or issues, please refer to the script comments or contact the project maintainer.
