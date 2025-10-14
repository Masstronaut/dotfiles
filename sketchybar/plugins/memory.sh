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
MEMORY_PERCENT=$(printf "%.0f" $MEMORY_UTILIZATION_PERCENT)


# Color the label based on memory usage
source $CONFIG_DIR/colors.sh

if [ $(echo "$MEMORY_UTILIZATION_PERCENT > 90" | bc) -eq 1 ]; then
  COLOR="$ERROR_COLOR"
  ICON_COLOR="0xffffffff"
elif [ $(echo "$MEMORY_UTILIZATION_PERCENT > 80" | bc) -eq 1 ]; then
  COLOR="$WARNING_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
else
  COLOR="$SUCCESS_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
fi



MEMORY_DECIMAL=$(echo "$MEMORY_PERCENT / 100" | bc -l)

sketchybar --set "$NAME" label="" icon.color="$ICON_COLOR" icon.background.color="$COLOR" background.border_color="$COLOR" \
           --push $NAME "$MEMORY_DECIMAL" \
           --set $NAME graph.color="$COLOR" graph.fill_color="$COLOR"
