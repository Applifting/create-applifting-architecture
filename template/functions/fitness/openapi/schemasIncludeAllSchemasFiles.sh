#!/bin/bash

# Find all yaml files in any schemas directory, excluding node_modules
schema_files=$(find . -path "*/schemas/*.yaml" -type f -not -path "*/node_modules/*")

# Read _schemas.yaml into a string
schemas_content=$(cat specs/api/_schemas.yaml)

# Counter for unreferenced files
unreferenced_count=0

echo "Checking for unreferenced schema files..."
echo

# Check each found schema file
while IFS= read -r file; do
    # Skip _schemas.yaml itself
    if [[ "$file" == *"_schemas.yaml" ]]; then
        continue
    fi
    
    # Get the filename and path relative to specs/api
    relative_path=$(echo "$file" | sed -n 's|.*specs/api/||p')
    
    if [ -z "$relative_path" ]; then
        continue  # Skip files not under specs/api
    fi
    
    # Check if the file path appears in _schemas.yaml
    if ! echo "$schemas_content" | grep -q "$relative_path"; then
        echo "⚠️  Unreferenced schema file: $relative_path"
        ((unreferenced_count++))
    fi
done <<< "$schema_files"

echo
if [ $unreferenced_count -eq 0 ]; then
    echo "✅ All schema files are referenced in _schemas.yaml"
    exit 0
else
    echo "❌ Found $unreferenced_count unreferenced schema file(s)"
    exit 1
fi