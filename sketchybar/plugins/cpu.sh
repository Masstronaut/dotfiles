#!/bin/bash

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"



source $CONFIG_DIR/colors.sh

if [ $(echo "$CPU_PERCENT > 90" | bc) -eq 1 ]; then
  COLOR="0xFF${LOVE}"
elif [ $(echo "$CPU_PERCENT > 70" | bc) -eq 1 ]; then
  COLOR="0xFF${GOLD}"
else
  COLOR="0xFF${PINE}"
fi


sketchybar --set $NAME label="$CPU_PERCENT%" label.color="$COLOR" icon.color="$COLOR"
