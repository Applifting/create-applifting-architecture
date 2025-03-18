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

# Sort the YAML file using yq and save it in place
yq -i 'sort_keys(..)' "specs/api/_schemas.yaml"

echo "Schema file has been sorted alphabetically"