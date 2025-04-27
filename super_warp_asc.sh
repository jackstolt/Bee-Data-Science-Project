#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <file_prefix> <start_year> <end_year>"
  echo "  Example: $0 PRIME_tmean_stable_4kmM3 2002 2024"
  exit 1
fi

file_prefix="$1"
start_year="$2"
end_year="$3"

# Loop through the years
for ((year = start_year; year <= end_year; year++)); do
  # Loop through the months (1 to 12)
  for ((month = 1; month <= 12; month++)); do
    # Construct the month string with leading zero if necessary
    month_str=$(printf "%02d" $month)
    file="${file_prefix}_${year}${month_str}_bil"  # Construct the filename
    echo "Processing ${file}.asc"

    # Check if the file exists before attempting to process it
    if [ ! -f "${file}.asc" ]; then
      echo "Error: ${file}.asc not found. Skipping."
      continue # Skip to the next iteration of the loop
    fi

    # Perform the gdalwarp operation
    gdalwarp -overwrite -te -125.020833333333 24.062499999979 \
        $(echo "-125.020833333333 + (1405 * 0.041666666667)" | bc -l) \
        $(echo "24.062499999979 + (621 * 0.041666666667)" | bc -l) \
        -tr 0.041666666667 0.041666666667 -r near -of AAIGrid "${file}.asc" "${file}_corrected.asc"

    # Check if gdalwarp was successful
    if [ $? -eq 0 ]; then
      echo "gdalwarp successful. Moving files."
      # Move the corrected files
      mv "${file}_corrected.asc" "${file}.asc"
      mv "${file}_corrected.prj" "${file}.prj"
    else
      echo "gdalwarp failed for ${file}.asc. Skipping move."
    fi
  done # Month loop
done # Year loop

echo "Processing complete."
