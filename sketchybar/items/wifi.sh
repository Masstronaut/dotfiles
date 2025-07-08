#!/bin/bash

# WiFi item configuration (using native Control Center alias)
bar_item_wifi=(
    --add alias "Control Center,WiFi" right
)

# Function to render WiFi item
render_bar_item_wifi() {
    sketchybar "${bar_item_wifi[@]}"
}
