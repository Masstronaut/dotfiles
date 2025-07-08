#!/bin/bash

# Media item configuration
bar_item_media=(
    --add item media center
    --set media
    label.color="$ACCENT_COLOR"
    label.max_chars=50
    icon.padding_left=0
    scroll_texts=off
    icon="􀑪"
    icon.color="$ACCENT_COLOR"
    background.drawing=off
    script="$PLUGIN_DIR/media.sh"
    --subscribe media media_change
)

# Function to render media item
render_bar_item_media() {
    sketchybar "${bar_item_media[@]}"
}
