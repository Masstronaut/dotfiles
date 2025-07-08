#!/bin/bash

source $CONFIG_DIR/utils/aerospace.sh

if [[ "$SENDER" = "change-window-workspace" ]]; then

    # Batch workspace updates for better performance but use existing function for correctness
    local updates=""
    
    # Build updates for focused workspace
    if [[ "$FOCUSED_WORKSPACE" ]]; then
      updates+="--set workspace.$FOCUSED_WORKSPACE drawing=on label=\"$(workspace_app_icons $FOCUSED_WORKSPACE)\" "
    fi
    
    # Build updates for target workspace  
    if [[ "$TARGET_WORKSPACE" ]]; then
      updates+="--set workspace.$TARGET_WORKSPACE drawing=on label=\"$(workspace_app_icons $TARGET_WORKSPACE)\" "
    fi
    
    # Execute batched command
    if [[ -n "$updates" ]]; then
      eval "sketchybar $updates"
    fi
elif [ "$SENDER" = "aerospace_workspace_change" ]; then
  handle_workspace_change
elif [[ "$SENDER" = "change-workspace-monitor" ]]; then
  sketchybar --set workspace.$TARGET_WORKSPACE display=$TARGET_MONITOR
fi
