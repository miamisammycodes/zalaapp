#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: ./run_task.sh <task>"
  echo "Available tasks:"
  echo "  find_comments  - Find all comments in Dart files."
  echo "  add_metrics    - Add dart_code_metrics as a dev dependency."
  echo "  check_unused   - Run dart_code_metrics to check unused files."
  echo "  fix_imports    - Fix unused imports using dart fix."
  exit 1
fi

# Execute the command based on the argument
case $1 in
  find_comments)
    echo "Searching for comments in Dart files..."
    grep -n -r --include=\*.dart -E "//|/\*|\*/" .
    ;;
  add_metrics)
    echo "Adding dart_code_metrics as a dev dependency..."
    flutter pub add --dev dart_code_metrics
    ;;
  check_unused)
    echo "Checking for unused files using dart_code_metrics..."
    flutter pub run dart_code_metrics:metrics check-unused-files lib
    ;;
  fix_imports)
    echo "Fixing unused imports..."
    dart fix --apply --code unused_import
    ;;
  *)
    echo "Unknown task: $1"
    echo "Available tasks: find_comments, add_metrics, check_unused, fix_imports"
    exit 1
    ;;
esac
