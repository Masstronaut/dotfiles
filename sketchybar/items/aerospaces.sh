#!/bin/bash
sketchybar --add event aerospace_workspace_change

# This custom event (triggered in ~/.config/aerospace/aerospace.toml) fires when a window is moved
# from one space to another.
# It will include two variables:
# - TARGET_WORKSPACE: The ID of the workspace the window was moved to
# - FOCUSED_WORKSPACE: The ID of the workspace that is currently focused (where the window is moving from)
sketchybar --add event change-window-workspace

# This custom event (triggered in ~/.config/aerospace/aerospace.toml) fires when
# a workspace is moved to a different monitor.
# It will include two variables:
# - TARGET_MONITOR: The system ID of the monitor the workspace was moved to (NOT aerospace ID)
# - TARGET_WORKSPACE: The ID of the workspace that is being moved
sketchybar --add event change-workspace-monitor

# Load the color variables
source $CONFIG_DIR/colors.sh

source $CONFIG_DIR/utils/aerospace.sh

# Create an item for each aerospace workspace
create_aerospace_workspaces

# Render a '>' separator between the spaces and the front app
# Since there is only one (and 36 window items), it's also
# an efficient place to handle aerospace events once per event
sketchybar --add item workspace_separator left                             \
           --set workspace_separator icon="􀆊"                              \
                                 icon.color=$ACCENT_COLOR                  \
                                 icon.padding_left=4                       \
                                 label.drawing=off                         \
                                 background.drawing=off                    \
                                 script="$PLUGIN_DIR/aerospace_windows.sh" \
                                 display="active"                          \
           --subscribe workspace_separator space_windows_change            \
           --subscribe workspace_separator front_app_switched              \
           --subscribe workspace_separator aerospace_workspace_change      \
           --subscribe workspace_separator change-window-workspace         \
           --subscribe workspace_separator change-workspace-monitor
