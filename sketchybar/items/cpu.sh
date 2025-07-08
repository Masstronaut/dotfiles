#!/bin/bash

# CPU item configuration
bar_item_cpu=(
    --add item cpu right
    --set cpu
    update_freq=5
    icon="􀧓"
    script="$PLUGIN_DIR/cpu.sh"
)

# Function to render CPU item
render_bar_item_cpu() {
    sketchybar "${bar_item_cpu[@]}"
}
