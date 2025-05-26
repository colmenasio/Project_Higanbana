#!/bin/bash

# Usage: ./generate_interface.sh Name '["method1", "method2"]'

# Check if exactly 2 arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <Name> <Methods>"
  echo "Example: $0 MyInterface '[\"foo\", \"bar\"]'"
  exit 1
fi

# Directory where the .gd file will be created
TARGET_DIR="./scripts/interfaces"
[ -d $TARGET_DIR ] || {	echo "$TARGER_DIR directory not found"; exit 1; }

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Input arguments
INPUT_NAME="$1"
METHODS="$2"

# Function to convert string to snake_case
to_snake_case() {
  echo "$1" | sed -r 's/([A-Z])/_\L\1/g' | sed -r 's/^_//'
}

# Function to convert string to CamelCase
to_camel_case() {
  echo "$1" | sed -r 's/(^|_)([a-z])/\U\2/g'
}

# Generate snake_case and CamelCase versions
SNAKE_NAME=$(to_snake_case "$INPUT_NAME")
CAMEL_NAME=$(to_camel_case "$INPUT_NAME")

# Output file path
FILE_PATH="${TARGET_DIR}/${SNAKE_NAME}.gd"
[ -f $FILE_PATH ] && {	echo "$FILE_PATH already exists"; exit 1; }


# Create the file with the desired contents
cat <<EOF > "$FILE_PATH"
class_name $CAMEL_NAME

const _methods = $METHODS

# Returns true if the object implements this interface
static func impl(object) -> bool:
	return $CAMEL_NAME._methods.all(object.has_method)
EOF

echo "File created: $FILE_PATH"
