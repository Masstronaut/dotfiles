#!/bin/bash

# Load the color variables
source $CONFIG_DIR/colors.sh
source $CONFIG_DIR/utils/aerospace.sh

# Depends on a fork of sketchybar that sends this event.
# Does nothing otherwise
if [[ $SENDER = "display_removed" ]]; then
  workspace_id="$1"
  disconnected_display_id="$INFO"
  sketchybar --set workspace.$workspace_id display="$((disconnected_display_id - 1))"
fi

