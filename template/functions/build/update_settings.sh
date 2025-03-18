#!/bin/bash

# Check if token is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <gitlab_token>"
    exit 1
fi

TOKEN="$1"
SETTINGS_FILE="settings.xml"

# Check if settings.xml exists
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Error: $SETTINGS_FILE does not exist"
    exit 1
fi

# Escape special characters in token for sed
ESCAPED_TOKEN=$(printf '%s\n' "$TOKEN" | sed 's/[&/\]/\\&/g')

# Use sed to replace the token
sed -i'' -e "s/REPLACE_WITH_TOKEN/$ESCAPED_TOKEN/g" "$SETTINGS_FILE"

echo "Successfully updated token in $SETTINGS_FILE" 