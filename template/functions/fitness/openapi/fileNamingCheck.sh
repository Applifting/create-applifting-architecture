#!/bin/bash

# Check if api-specs directory exists
if [ ! -d "api-specs" ]; then
    echo "Error: api-specs directory not found"
    exit 1
fi

# Initialize error flag as a global variable
invalid_files_found=0

# Function to convert filename to snake_case suggestion
suggest_filename() {
    local filename=$1
    # Convert to lowercase, replace spaces/hyphens with underscores
    # and ensure there's exactly one underscore between words
    echo "$filename" | tr '[:upper:]' '[:lower:]' | tr ' -' '_' | tr -s '_'
}

# Find all files in api-specs directory and subdirectories
while IFS= read -r file; do
    filename=$(basename "$file")
    
    # Skip hidden files
    if [[ $filename == .* ]]; then
        continue
    fi
    
    # Check if filename contains uppercase letters or invalid characters
    if [[ "$filename" =~ [A-Z] ]] || [[ "$filename" =~ [^a-z0-9_\.] ]] || [[ "$filename" != $(suggest_filename "$filename") ]]; then
        echo "Invalid filename found: $file"
        suggestion=$(suggest_filename "$filename")
        echo "Suggestion: $suggestion"
        invalid_files_found=1
    fi
done < <(find api-specs -type f)

# Check the error flag
if [ $invalid_files_found -eq 0 ]; then
    echo "All filenames are valid (lowercase with underscores)"
    exit 0
else
    echo -e "\nPlease rename the files according to the suggestions"
    exit 1
fi