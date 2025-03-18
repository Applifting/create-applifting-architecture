#!/bin/bash

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install it first."
    echo "You can install it using:"
    echo "  wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Required fields for each operation
REQUIRED_FIELDS=("tags" "summary" "description" "operationId" "responses")

# Global counters
total_files=0
failed_files=0

# Function to validate a single YAML file
validate_yaml() {
    local file="$1"
    local has_errors=0
    local file_reported=0

    # Check if file exists and is readable
    if [ ! -r "$file" ]; then
        echo -e "${RED}Error: Cannot read file $file${NC}"
        ((failed_files++))
        return 1
    fi

    # Check if the file is a valid YAML
    if ! yq eval '.' "$file" > /dev/null 2>&1; then
        echo -e "${RED}Error: Invalid YAML file: $file${NC}"
        ((failed_files++))
        return 1
    fi

    # Check for each HTTP method
    for method in "get" "post" "put" "delete"; do
        # Skip if method doesn't exist
        if ! yq eval ".$method" "$file" > /dev/null 2>&1 || yq eval ".$method" "$file" | grep -q "^null$"; then
            continue
        fi
        
        # Check required fields for the method
        for field in "${REQUIRED_FIELDS[@]}"; do
            if ! yq eval ".$method.$field" "$file" > /dev/null 2>&1 || yq eval ".$method.$field" "$file" | grep -q "^null$"; then
                if [ $file_reported -eq 0 ]; then
                    echo -e "\n${RED}File: $file${NC}"
                    file_reported=1
                fi
                echo -e "${RED}  - Missing required field '$field' in $method operation${NC}"
                has_errors=1
            fi
        done
    done

    if [ $has_errors -eq 1 ]; then
        ((failed_files++))
        return 1
    fi

    return 0
}

# Main script
# Find all paths directories and process YAML files in them
while read -r file; do
    ((total_files++))
    validate_yaml "$file"
done < <(find . -type d -name "paths" -exec find {} -type f \( -name "*.yaml" -o -name "*.yml" \) \;)

# Print summary
echo -e "\nValidation Summary:"
if [ $failed_files -eq 0 ]; then
    echo -e "${GREEN}✓ All $total_files files passed validation${NC}"
    exit 0
else
    echo -e "${RED}✗ Found issues in $failed_files out of $total_files files${NC}"
    exit 1
fi