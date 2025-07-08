#!/bin/bash

# Memory item configuration
bar_item_memory=(
    --add item memory right
    --set memory
    update_freq=5
    icon="􀫦"
    script="$PLUGIN_DIR/memory.sh"
)

# Function to render memory item
render_bar_item_memory() {
    sketchybar "${bar_item_memory[@]}"
}
