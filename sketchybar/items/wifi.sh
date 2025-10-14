#!/bin/bash

# WiFi item configuration
bar_item_wifi=(
    --add item wifi right
    --set wifi
    update_freq=10
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
    script="$PLUGIN_DIR/wifi.sh"
    click_script="$PLUGIN_DIR/wifi.sh"
    --subscribe wifi wifi_change
)

# Function to render WiFi item
render_bar_item_wifi() {
    sketchybar "${bar_item_wifi[@]}"
}
