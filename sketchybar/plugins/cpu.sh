#!/bin/bash

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"



source $CONFIG_DIR/colors.sh

if [ $(echo "$CPU_PERCENT > 90" | bc) -eq 1 ]; then
  COLOR="$ERROR_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
elif [ $(echo "$CPU_PERCENT > 70" | bc) -eq 1 ]; then
  COLOR="$WARNING_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
else
  COLOR="$SUCCESS_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
fi


CPU_DECIMAL=$(echo "$CPU_PERCENT / 100" | bc -l)

sketchybar --set $NAME label="" icon.color="$ICON_COLOR" icon.background.color="$COLOR" background.border_color="$COLOR" \
           --push $NAME "$CPU_DECIMAL" \
           --set $NAME graph.color="$COLOR" graph.fill_color="$COLOR"
