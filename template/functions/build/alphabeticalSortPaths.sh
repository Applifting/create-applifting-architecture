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

# Sort the paths and save in place
yq -i '.paths |= with_entries(select(. != null)) | .paths *= with_entries(sort_by(.key))' "specs/api/openapi.yaml"

echo "Paths have been sorted alphabetically!"