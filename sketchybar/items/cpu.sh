#!/bin/bash

# CPU graph item with icon and label
bar_item_cpu=(
    --add graph cpu right 60
    --set cpu
    padding_left=5
    padding_right=5
    update_freq=1
    icon="􀧓"
    icon.background.drawing=on
    icon.background.corner_radius=5
    icon.background.height=20
    icon.background.color="$SUCCESS_COLOR"
    icon.padding_left=4
    icon.padding_right=6
    icon.color="0xff$MUTED"
    graph.color="$SUCCESS_COLOR"
    graph.fill_color="$SUCCESS_COLOR"
    background.height=22
    background.corner_radius=5
    background.border_width=1
    background.border_color="$SUCCESS_COLOR"
    script="$PLUGIN_DIR/cpu.sh"
)

# Function to render CPU item
render_bar_item_cpu() {
    sketchybar "${bar_item_cpu[@]}"
}
