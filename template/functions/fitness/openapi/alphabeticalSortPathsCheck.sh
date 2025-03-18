#!/bin/bash

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install it first."
    exit 1
fi

# Check if file exists
if [ ! -f "specs/api/openapi.yaml" ]; then
    echo "Error: openapi.yaml file not found"
    exit 1
fi

# Function to check if an array is sorted
check_sorted() {
    local input=$1
    local sorted=$(echo "$input" | sort)
    
    if [ "$input" != "$sorted" ]; then
        echo "Error: Paths are not sorted alphabetically"
        echo "Current order:"
        echo "$input"
        echo -e "\nExpected order:"
        echo "$sorted"
        return 1
    fi
    return 0
}

# Get paths keys
paths_keys=$(yq '.paths | keys | .[]' specs/api/openapi.yaml)

# Check paths order
if ! check_sorted "$paths_keys"; then
    exit 1
fi

echo "All paths are properly sorted!"
exit 0