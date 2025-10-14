#!/bin/bash

# Volume item configuration
bar_item_volume=(
    --add item volume right
    --set volume
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
    script="$PLUGIN_DIR/volume.sh"
    --subscribe volume volume_change
)

# Function to render volume item
render_bar_item_volume() {
    sketchybar "${bar_item_volume[@]}"
}
