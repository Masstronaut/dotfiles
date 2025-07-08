#!/bin/bash

# Battery item configuration
bar_item_battery=(
    --add item battery right
    --set battery
    update_freq=120
    script="$PLUGIN_DIR/battery.sh"
    --subscribe battery system_woke power_source_change
)

# Function to render battery item
render_bar_item_battery() {
    sketchybar "${bar_item_battery[@]}"
}
