#!/bin/bash
sketchybar --add event aerospace_workspace_change

# Load the color variables
source $CONFIG_DIR/colors.sh

# create a workspace item.
# Expects the workspace id as the first argument
create_workspace() {
    local sid=$1
    # if $1 was empty, log an error in /tmp/sketchybar.log
    if [ -z "$sid" ]; then
        echo "Error: create_workspace() expects a workspace id as the first argument" >> /tmp/sketchybar.log
        return
    fi

    # Create the workspace item for the provided space ID
    sketchybar --add item workspace.$sid left \
        --subscribe workspace.$sid aerospace_workspace_change \
        --subscibe workspace.$sid space_windows_change \
        --set workspace.$sid \
        background.color="$ITEM_BG_COLOR" \
        background.corner_radius=5 \
        background.height=22 \
        background.border_color="0xFF$SUBTLE" \
        background.border_width=1 \
        icon.background.drawing=on \
        icon.background.corner_radius=5 \
        icon.background.color="0xFF$SUBTLE" \
        icon.background.height=20 \
        icon.padding_left=4 \
        icon.padding_right=6 \
        icon.color="$BAR_COLOR" \
        click_script="aerospace workspace $sid" \
        label.font="sketchybar-app-font:Regular:16.0" \
        icon.font="Hack Nerd Font Mono:Regular:16.0" \
        label.color="0xFF$MUTED" \
        label.padding_left=6 \
        label.y_offset=-1 \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
}


for sid in $(aerospace list-workspaces --all); do
  # Only render spaces in the top bar if they contain windows
  # ! -z means "not empty" - ie there is at least 1 window
  if [[ ! -z $(aerospace list-windows --workspace $sid) ]]; then
    create_workspace $sid
  elif [[ "$sid" == $(aerospace list-workspaces --focused) ]]; then
    create_workspace $sid
  fi
done

# Render a '>' separator between the spaces and the front app
sketchybar --add item workspace_separator left                             \
           --set workspace_separator icon="􀆊"                              \
                                 icon.color=$ACCENT_COLOR              \
                                 icon.padding_left=4                   \
                                 label.drawing=off                     \
                                 background.drawing=off                \
                                 script="$PLUGIN_DIR/aerospace_windows.sh" \
           --subscribe space_separator space_windows_change            \
           --subscribe space_separator front_app_switched   \
           --subscribe space_separator aerospace_workspace_change
