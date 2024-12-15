#!/bin/bash

# Load the color variables
source $CONFIG_DIR/colors.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color=$ACCENT_COLOR \
                         icon.background.color=$ACCENT_COLOR \
                         background.border_color=$ACCENT_COLOR
 else
  sketchybar --set $NAME background.color="$ITEM_BG_COLOR" \
                         label.color=0xFF$MUTED \
                         icon.background.color="0xFF$SUBTLE" \
                         background.border_color="0xFF$SUBTLE"

fi

