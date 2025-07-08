#!/bin/bash

# Get current front app for immediate display (blazingly fast!)
CURRENT_APP=$(lsappinfo info -only name `lsappinfo front` | cut -d'"' -f4)
CURRENT_ICON=$($CONFIG_DIR/plugins/icon_map_fn_batched.sh "$CURRENT_APP")

sketchybar --add item front_app left \
           --set front_app       icon.color="$ACCENT_COLOR" \
                                 icon.font="sketchybar-app-font:Regular:16.0" \
                                 label.color="$ACCENT_COLOR" \
                                 label="$CURRENT_APP" \
                                 icon="$CURRENT_ICON" \
                                 script="$PLUGIN_DIR/front_app.sh"            \
                                 display="active" \
           --subscribe front_app front_app_switched
