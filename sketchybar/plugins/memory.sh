#!/bin/bash

# Calculate the current memory usage in GB and print it to one decimal place
pagesize=$(pagesize)
USED_MEMORY=$(vm_stat | awk -v ps=$pagesize '/Pages active/ {printf "%.1f\n", $3 * ps /1024/1024/1024}')

# Calculate the total memory in GB
TOTAL_MEMORY=$(sysctl hw.memsize | awk '{print $2/1024/1024/1024}')

# The scale value tells bc how many decimal places to use for the calculation
MEMORY_UTILIZATION_PERCENT=$(echo "scale=4; ($USED_MEMORY / $TOTAL_MEMORY) * 100" | bc)

# format the number as a floating point (%.) with 0 decimal places and a % at the end (%%)
FORMATTED_MEMORY=$(printf "%.0f%%" $MEMORY_UTILIZATION_PERCENT)


# Color the label based on memory usage
source $CONFIG_DIR/colors.sh

if [ $(echo "$MEMORY_UTILIZATION_PERCENT > 90" | bc) -eq 1 ]; then
  COLOR="0xFF${LOVE}"
elif [ $(echo "$MEMORY_UTILIZATION_PERCENT > 80" | bc) -eq 1 ]; then
  COLOR="0xFF${GOLD}"
else
  COLOR="0xFF${PINE}"
fi



sketchybar --set "$NAME" label="$FORMATTED_MEMORY" label.color="$COLOR" icon.color="$COLOR"
