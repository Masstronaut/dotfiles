#!/bin/bash

# Battery item configuration
bar_item_battery=(
    --add item battery right
    --set battery
    update_freq=120
    icon.background.drawing=on
    icon.background.corner_radius=5
    icon.background.height=20
    icon.background.color="$SUCCESS_COLOR"
    icon.padding_left=4
    icon.padding_right=6
    icon.color="0xff$MUTED"
    background.height=22
    background.corner_radius=5
    background.border_width=1
    background.border_color="$SUCCESS_COLOR"
    script="$PLUGIN_DIR/battery.sh"
    --subscribe battery system_woke power_source_change
)

# Function to render battery item
render_bar_item_battery() {
    sketchybar "${bar_item_battery[@]}"
}
