#!/bin/bash

source $CONFIG_DIR/utils/aerospace.sh

if [[ "$SENDER" = "change-window-workspace" ]]; then

    # ! -z means "not empty" - ie the FOCUSED_WORKSPACE was specified
    if [[  "$FOCUSED_WORKSPACE" ]]; then
      sketchybar --set workspace.$FOCUSED_WORKSPACE drawing=on \
        label="$(workspace_app_icons $FOCUSED_WORKSPACE)" 
    fi
    if [[ "$TARGET_WORKSPACE" ]]; then
      sketchybar --set workspace.$TARGET_WORKSPACE drawing=on \
        label="$(workspace_app_icons $TARGET_WORKSPACE)"
    fi
elif [ "$SENDER" = "aerospace_workspace_change" ]; then
  handle_workspace_change
fi
