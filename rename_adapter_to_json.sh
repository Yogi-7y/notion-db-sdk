#!/bin/bash

# Find all files ending with _json_adapter.dart recursively from the current directory
find . -name "*_json_adapter.dart" | while read file; do
    # Generate the new filename
    newname=$(echo "$file" | sed 's/_json_adapter\.dart$/_model.dart/')
    
    # Rename the file
    mv "$file" "$newname"
    
    echo "Renamed: $file to $newname"
done

echo "File renaming complete."