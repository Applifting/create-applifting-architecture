#!/bin/bash

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install it first."
    exit 1
fi

# Check if file exists
if [ ! -f "specs/api/_schemas.yaml" ]; then
    echo "Error: _schemas.yaml file not found"
    exit 1
fi

# Create a sorted temporary file to compare against
temp_file=$(mktemp)
yq 'sort_keys(..)' "specs/api/_schemas.yaml" > "$temp_file"

# Compare the original file with the sorted version
if diff "specs/api/_schemas.yaml" "$temp_file" >/dev/null; then
    echo "✅ Schema file is properly sorted alphabetically"
    rm "$temp_file"
    exit 0
else
    echo "❌ Schema file is NOT sorted alphabetically"
    rm "$temp_file"
    exit 1
fi