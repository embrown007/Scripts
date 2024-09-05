#!/bin/bash

# Source directory
SOURCE_DIR="./source_folder"

# directory for jscon and csv
JSON_CSV="./json_and_CSV"

# Create the destination directory if it doesn't exist
mkdir -p "$JSON_CSV"

# Move CSV files
echo "Moving CSV files..."
csv_count=$(find "$SOURCE_DIR" -maxdepth 1 -type f -name "*.csv" | wc -l)
if [ $csv_count -gt 0 ]; then
    mv "$SOURCE_DIR"/*.csv "$JSON_CSV"
    echo "Moved $csv_count CSV file(s)"
else
    echo "No CSV files found"
fi

# Move JSON files
echo "Moving JSON files..."
json_count=$(find "$SOURCE_DIR" -maxdepth 1 -type f -name "*.json" | wc -l)
if [ $json_count -gt 0 ]; then
    mv "$SOURCE_DIR"/*.json "$JSON_CSV"
    echo "Moved $json_count JSON file(s)"
else
    echo "No JSON files found"
fi

# Check if any files were moved
total_moved=$((csv_count + json_count))
if [ $total_moved -gt 0 ]; then
    echo "Successfully moved $total_moved file(s) to $DEST_DIR"
    echo "Files in destination directory:"
    ls -1 "$JSON_CSV"
else
    echo "No CSV or JSON files were found to move"
fi
