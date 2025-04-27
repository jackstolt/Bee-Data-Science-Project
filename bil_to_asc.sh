#!/bin/bash

if [ "$#" -ne 2 ]; then
  # Display usage information to standard error
  echo "Usage: $0 <argument1> <argument2>" >&2
  echo "  <argument1>: Input directory containing the .bil files" >&2
  echo "  <argument2>: Output directory to place the .asc files" >&2
  exit 1
fi

input_dir="$1"
output_dir="$2"
nodata_value="-9999"
output_format="AAIGrid"

mkdir -p "$output_dir"

# --- Loop through all .bil files in the input directory ---
find "$input_dir" -maxdepth 1 -type f -name "*.bil" -print0 | while IFS= read -r -d $'\0' bil_file; do
  # Extract the filename without the extension to use as the base for the output .asc file
  base_name=$(basename "$bil_file" .bil)
  output_asc_file="$output_dir/${base_name}.asc"

  # Run gdal_translate to convert the .bil file to .asc
  gdal_translate -of "$output_format" -a_nodata "$nodata_value" "$bil_file" "$output_asc_file"

  if [ $? -eq 0 ]; then
    echo "Successfully converted: $bil_file to $output_asc_file"
  else
    echo "Error converting: $bil_file"
  fi
done

echo "Conversion process finished."
