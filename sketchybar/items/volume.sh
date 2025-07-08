#!/bin/bash

# Volume item configuration
bar_item_volume=(
    --add item volume right
    --set volume
    script="$PLUGIN_DIR/volume.sh"
    --subscribe volume volume_change
)

# Function to render volume item
render_bar_item_volume() {
    sketchybar "${bar_item_volume[@]}"
} \
