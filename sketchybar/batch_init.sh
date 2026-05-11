#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/window_manager_utils.sh"

# Define plugin and item directories (needed for sourcing item configs)
PLUGIN_DIR="$CONFIG_DIR/plugins"
ITEM_DIR="$CONFIG_DIR/items"

# Generate arguments for all left-side items (workspaces + front_app + separator)
generate_left_side_args() {
    local all_args=()
    local space_metadata
    local focus_command_prefix=""
    local item_script_prefix=""
    
    focus_command_prefix="$(space_focus_command_prefix 2>/dev/null || true)"
    item_script_prefix="$(space_item_script_prefix 2>/dev/null || true)"
    space_metadata="$(space_metadata_add_icons "$(spaces)")"
    write_space_state_snapshot "$space_metadata"

    while IFS= read -r arg; do
        [[ -n "$arg" ]] && all_args+=("$arg")
    done < <(generate_space_item_args_from_metadata "$space_metadata" "$focus_command_prefix" "$item_script_prefix")
    
    # Add workspace separator
    all_args+=(
        --add item workspace_separator left
        --set workspace_separator
        icon="􀆊"
        icon.color="$ACCENT_COLOR"
        icon.padding_left=4
        label.drawing=off
        background.drawing=off
        script="$CONFIG_DIR/plugins/window_manager_spaces.sh"
        display="active"
    )

    while IFS= read -r arg; do
        [[ -n "$arg" ]] && all_args+=("$arg")
    done < <(space_event_init_args workspace_separator)
    
    # Add front_app using new pattern
    source "$CONFIG_DIR/items/front_app.sh"
    all_args+=("${bar_item_front_app[@]}")
    
    printf '%s\n' "${all_args[@]}"
}

# Generate arguments for all right-side items
generate_right_side_args() {
    local all_args=()
    
    # All right-side items using new pattern
    source "$CONFIG_DIR/items/calendar.sh"
    all_args+=("${bar_item_calendar[@]}")
    
    source "$CONFIG_DIR/items/volume.sh"
    all_args+=("${bar_item_volume[@]}")
    
    source "$CONFIG_DIR/items/battery.sh"
    all_args+=("${bar_item_battery[@]}")
    
    source "$CONFIG_DIR/items/cpu.sh"
    all_args+=("${bar_item_cpu[@]}")
    
    source "$CONFIG_DIR/items/memory.sh"
    all_args+=("${bar_item_memory[@]}")
    
    source "$CONFIG_DIR/items/wifi.sh"
    all_args+=("${bar_item_wifi[@]}")
    
    printf '%s\n' "${all_args[@]}"
}

# Execute left or right side based on argument
case "$1" in
    "left")
        args=()
        while IFS= read -r arg; do
            args+=("$arg")
        done <<< "$(generate_left_side_args)"
        sketchybar "${args[@]}"
        ;;
    "right")
        args=()
        while IFS= read -r arg; do
            args+=("$arg")
        done <<< "$(generate_right_side_args)"
        sketchybar "${args[@]}"
        ;;
    *)
        echo "Usage: $0 {left|right}"
        exit 1
        ;;
esac
