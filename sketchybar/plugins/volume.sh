#!/bin/bash

source $CONFIG_DIR/colors.sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [7][5-9]|[8-9][0-9]|100) ICON="􀊩"
    ;;
    [5-6][0-9]|[7][0-4]) ICON="􀊧"
    ;;
    [2][5-9]|[3-4][0-9]) ICON="􀊥"
    ;;
    [1-9]|[1][0-9]|[2][0-4]) ICON="􀊡"
    ;;
    *) ICON="􀊣"
  esac

  if [ "$VOLUME" = "0" ]; then
    COLOR="$ERROR_COLOR"
    ICON_COLOR="0xffffffff"
  else
    COLOR="$INACTIVE_COLOR"
    ICON_COLOR="$ICON_TEXT_COLOR"
  fi

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" icon.color="$ICON_COLOR" icon.background.color="$COLOR" background.border_color="$COLOR"
fi
