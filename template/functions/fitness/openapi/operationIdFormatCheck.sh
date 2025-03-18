#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for errors
error_count=0

# Function to convert filename to camelCase
to_camel_case() {
    local name=$1
    # Remove file extension
    name=$(echo "$name" | sed 's/\.yaml$//' | sed 's/\.yml$//')
    # Convert to lowercase first
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    # Process each part separated by underscore
    local result=""
    local first=true
    for part in $(echo "$name" | tr '_' ' '); do
        if [ "$first" = true ]; then
            result="$part"
            first=false
        else
            # Capitalize first letter of the part
            part=$(echo "$part" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
            result="${result}${part}"
        fi
    done
    echo "$result"
}

# Function to check if a YAML file has operationId for HTTP methods
check_yaml_file() {
    local file=$1
    local has_error=0
    
    # Get the base filename without path and extension
    local filename=$(basename "$file")
    local camel_name=$(to_camel_case "$filename")
    
    # For files containing _id, remove all instances of Id from camelCase name
    if echo "$filename" | grep -q "_id"; then
        camel_name=$(echo "$camel_name" | sed 's/Id//g')
    fi
    
    # Check each HTTP method
    for method in get post put delete; do
        # Set allowed suffixes based on method
        local allowed_suffixes=""
        case "$method" in
            "get")    
                # Check if response is array type
                if grep -A 20 "^[[:space:]]*get:" "$file" | grep -q "type:[[:space:]]*array"; then
                    allowed_suffixes="List"
                else
                    allowed_suffixes="Get List"
                fi
                ;;
            "post")   allowed_suffixes="Post Create Update" ;;
            "put")    allowed_suffixes="Put Update" ;;
            "delete") allowed_suffixes="Delete" ;;
        esac
        
        # Find the method section and look for operationId
        while IFS= read -r line_number; do
            # Extract the section
            section=$(tail -n +$line_number "$file" | awk '/^[[:space:]]*(get:|post:|put:|delete:)/{if(NR>1)exit}1')
            
            # Check if section contains operationId
            if ! echo "$section" | grep -q "operationId:"; then
                # Print filename only on first error
                if [ $has_error -eq 0 ]; then
                    echo -e "\n${YELLOW}Checking file: $file${NC}"
                fi
                echo -e "${RED}Error: Missing operationId in ${method} section at line $line_number${NC}"
                has_error=1
                ((error_count++))
            else
                # Extract operationId value
                operationId=$(echo "$section" | grep "operationId:" | sed 's/.*operationId:[[:space:]]*\(.*\)/\1/')
                
                # Check if operationId matches any of the allowed suffixes
                local valid_format=false
                for suffix in $allowed_suffixes; do
                    local expected_id="${camel_name}${suffix}"
                    if [ "$operationId" = "$expected_id" ]; then
                        valid_format=true
                        break
                    fi
                done
                
                if [ "$valid_format" = false ]; then
                    # Print filename only on first error
                    if [ $has_error -eq 0 ]; then
                        echo -e "\n${YELLOW}Checking file: $file${NC}"
                    fi
                    echo -e "${RED}Error: Invalid operationId format '$operationId' in ${method} section at line $line_number${NC}"
                    echo -e "${RED}Expected format: ${camel_name}[${allowed_suffixes}]${NC}"
                    has_error=1
                    ((error_count++))
                fi
            fi
        done < <(grep -n "^[[:space:]]*${method}:" "$file" | cut -d: -f1)
    done
    
    return $has_error
}

# Store error count in a temporary file
temp_file=$(mktemp)
echo "0" > "$temp_file"

# Find all yaml/yml files in paths directories
while IFS= read -r file; do
    check_yaml_file "$file"
    if [ $? -eq 1 ]; then
        curr_count=$(cat "$temp_file")
        echo $((curr_count + 1)) > "$temp_file"
    fi
done < <(find . -type f \( -name "*.yaml" -o -name "*.yml" \) -path "*/paths/*")

# Get final error count
error_count=$(cat "$temp_file")
rm "$temp_file"

# Exit with error if any issues were found
if [ $error_count -gt 0 ]; then
    echo -e "\n${RED}Found $error_count file(s) with errors${NC}"
    exit 1
else
    echo -e "\n${GREEN}All files passed validation${NC}"
    exit 0
fi