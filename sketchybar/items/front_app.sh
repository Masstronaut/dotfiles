#!/bin/bash

# Get current front app for immediate display (blazingly fast!)
get_current_front_app() {
    lsappinfo info -only name `lsappinfo front` | cut -d'"' -f4
}

get_current_front_app_icon() {
    local app=$(get_current_front_app)
    $CONFIG_DIR/plugins/icon_map_fn_batched.sh "$app"
}

# Front app item configuration
bar_item_front_app=(
    --add item front_app left
    --set front_app
    icon.color="$ACCENT_COLOR"
    icon.font="sketchybar-app-font:Regular:16.0"
    label.color="$ACCENT_COLOR"
    label="$(get_current_front_app)"
    icon="$(get_current_front_app_icon)"
    script="$PLUGIN_DIR/front_app.sh"
    display="active"
    --subscribe front_app front_app_switched
)

# Function to render front app item
render_bar_item_front_app() {
    sketchybar "${bar_item_front_app[@]}"
}
