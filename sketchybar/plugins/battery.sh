#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="􀛨"
  ;;
  [6-8][0-9]) ICON="􀺸"
  ;;
  [3-5][0-9]) ICON="􀺶"
  ;;
  [1-2][0-9]) ICON="􀛩"
  ;;
  *) ICON="􀛪" 
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"
fi


# Color the item based on available battery
source $CONFIG_DIR/colors.sh

if [ $(echo "$PERCENTAGE > 50" | bc) -eq 1 ]; then
  COLOR="$SUCCESS_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
elif [ $(echo "$PERCENTAGE > 20" | bc) -eq 1 ]; then
  COLOR="$WARNING_COLOR"
  ICON_COLOR="$ICON_TEXT_COLOR"
else
  COLOR="$ERROR_COLOR"
  ICON_COLOR="0xffffffff"
fi


# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$ICON_COLOR" icon.background.color="$COLOR" background.border_color="$COLOR" label.color="$COLOR"
