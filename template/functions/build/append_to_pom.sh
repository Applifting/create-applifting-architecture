#!/bin/bash

# Check if source file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <source_xml_file>"
    exit 1
fi

SOURCE_FILE="$1"
TARGET_FILE="../dist/kotlin/pom.xml"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file $SOURCE_FILE does not exist"
    exit 1
fi

# Create temporary file
temp_file=$(mktemp)

# Process the files using awk
awk '
    # Read the source file into memory
    BEGIN {
        while ((getline line < ARGV[1]) > 0) {
            source_content = source_content line "\n"
        }
        ARGV[1] = ""  # Reset so awk does not try to process source file as input
    }
    
    # Process the target pom.xml
    {
        if (/<\/project>/) {
            print source_content
        }
        print
    }
' "$SOURCE_FILE" "$TARGET_FILE" > "$temp_file"

# Move temporary file to target
mv "$temp_file" "$TARGET_FILE"

echo "Successfully appended content from $SOURCE_FILE to $TARGET_FILE" 