#!/bin/bash

# Calendar item configuration
bar_item_calendar=(
    --add item calendar right
    --set calendar
    icon="􀉉"
    update_freq=30
    script="$PLUGIN_DIR/calendar.sh"
)

# Function to render calendar item
render_bar_item_calendar() {
    sketchybar "${bar_item_calendar[@]}"
}
