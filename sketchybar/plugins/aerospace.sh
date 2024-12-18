#!/bin/bash

# Load the color variables
source $CONFIG_DIR/colors.sh
source $CONFIG_DIR/utils/aerospace.sh

echo "SENDER IS $SENDER" >> /tmp/aerospace.log


# function to handle the aerospace_workspace_change event
# The event will include two variables:
# - FOCUSED_WORKSPACE: The ID of the workspace that is becoming focused
# - PREV_WORKSPACE: The ID of the workspace that was previously focused

handle_workspace_change() {
  echo "Switching to workspace.$FOCUSED_WORKSPACE from workspace.$PREV_WORKSPACE in the $NAME handler" >> /tmp/aerospace.log
  
  # if the previous workspace has no windows, hide it
  if [[ -n "$(aerospace list-windows --workspace $PREV_WORKSPACE)" ]]; then
    sketchybar --set workspace.$PREV_WORKSPACE drawing=on
  else
    sketchybar --set workspace.$PREV_WORKSPACE drawing=off
  fi

  # show the focused workspace no matter what
  sketchybar --set workspace.$FOCUSED_WORKSPACE drawing=on 

  echo "$NAME handle workspace change completed" >> /tmp/aerospace.log
}


if [[ "$SENDER" = "change-window-workspace" ]]; then
  echo "Moving a window from workspace.$FOCUSED_WORKSPACE to workspace.$TARGET_WORKSPACE" >> /tmp/aerospace.log
  echo "Change-window-workspace event fired on item with name $NAME" >> /tmp/aerospace.log

  # only handle the event once, from the focused workspace
  if [[ "$NAME" == "workspace.$FOCUSED_WORKSPACE" ]]; then
    echo "updating workspaces $FOCUSED_WORKSPACE and $TARGET_WORKSPACE from $NAME to handle the window movement" >> /tmp/aerospace.log
    # ! -z means "not empty" - ie the FOCUSED_WORKSPACE was specified
    if [[  "$FOCUSED_WORKSPACE" ]]; then
      sketchybar --set workspace.$FOCUSED_WORKSPACE drawing=on \
        label="$(workspace_app_icons $FOCUSED_WORKSPACE)" 
    fi
    if [[ "$TARGET_WORKSPACE" ]]; then
      sketchybar --set workspace.$TARGET_WORKSPACE drawing=on \
        label="$(workspace_app_icons $TARGET_WORKSPACE)"
    fi
  fi
elif [ "$SENDER" = "aerospace_workspace_change" ]; then
  if [[ "$NAME" = "workspace.$FOCUSED_WORKSPACE" ]]; then
  handle_workspace_change
  fi
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color=$ACCENT_COLOR \
                         icon.background.color=$ACCENT_COLOR \
                         background.border_color=$ACCENT_COLOR
 else
  sketchybar --set $NAME background.color="$ITEM_BG_COLOR" \
                         label.color=0xFF$MUTED \
                         icon.background.color="0xFF$SUBTLE" \
                         background.border_color="0xFF$SUBTLE"

fi
