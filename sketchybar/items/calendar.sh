#!/bin/bash

# Calendar item configuration
bar_item_calendar=(
    --add item calendar right
    --set calendar
    icon="􀉉"
    icon.background.drawing=on
    icon.background.corner_radius=5
    icon.background.height=20
    icon.background.color="$INACTIVE_COLOR"
    icon.padding_left=4
    icon.padding_right=6
    icon.color="$ICON_TEXT_COLOR"
    background.height=22
    background.corner_radius=5
    background.border_width=1
    background.border_color="$INACTIVE_COLOR"
    update_freq=30
    script="$PLUGIN_DIR/calendar.sh"
)

# Function to render calendar item
render_bar_item_calendar() {
    sketchybar "${bar_item_calendar[@]}"
}
