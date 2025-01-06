#!/bin/bash

# Expects the first positional argument to be a workspace ID
workspace_app_icons() {
  if [[ -z "$1" ]]; then
    echo "No workspace ID provided"
    return
  fi  
  local workspaceID="$1"

  local aerospace_apps=$(aerospace list-windows --workspace $workspaceID)

  if [[ -z "$aerospace_apps" ]]; then
    echo " —"
    return
  fi

  # iterate over all the workspace's windows and extract the names
  local apps=""
  while read -r line; do
    local app_name=$(echo "$line" | awk -F '|' '{gsub(/^ +| +$/, "", $2); print $2}')
    apps+="$app_name\n"
done < <(echo "$aerospace_apps") # < <() is used to prevent subshell creation in zsh
# using a subshell would cause the variable to be lost
  
  # replace occurrences of `\n` with newlines
  apps=$(printf "%b" "$apps")

  icon_strip=""
  while read -r app; do
    icon_strip+="$($CONFIG_DIR/plugins/icon_map_fn.sh "$app") "
  done <<< "${apps}"
  icon_strip=$(echo "$icon_strip" | tr -d '\n')
  echo "$icon_strip"
  return
} 


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

    # Only render spaces in the top bar if they contain windows
    # -n means "nonzero" length string - ie the space has at least 1 window 
    local drawing="off"
    if [[ -n $(aerospace list-windows --workspace $sid) ]]; then
      drawing="on"
    fi

    # Create the workspace item for the provided space ID
    sketchybar --add item workspace.$sid left \
        --set workspace.$sid \
        drawing="$drawing" \
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
        icon="$sid" \
        click_script="aerospace workspace $sid" \
        label.font="sketchybar-app-font:Regular:16.0" \
        icon.font="Hack Nerd Font Mono:Regular:16.0" \
        label.color="0xFF$MUTED" \
        label.padding_left=6 \
        label.y_offset=-1 \
        label="$(workspace_app_icons $sid)" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"

}


# Create all of the workspace items
create_aerospace_workspaces() {
  local focused_workspace=$(aerospace list-workspaces --focused)
  for sid in $(aerospace list-workspaces --all); do
    create_workspace $sid
    if [ $sid = $focused_workspace ]; then
      set_workspace_focused $sid
    fi
  done
}


# function to handle the aerospace_workspace_change event
# This function only needs to be invoked once per event instance
# The event will have set two environment variables:
# - FOCUSED_WORKSPACE: The ID of the workspace that is becoming focused
# - PREV_WORKSPACE: The ID of the workspace that was previously focused
handle_workspace_change() {
  
  set_workspace_focused "$FOCUSED_WORKSPACE"
  set_workspace_unfocused "$PREV_WORKSPACE"
}

# Expects the workspace id as the first argument
set_workspace_focused() {
  # show the focused workspace no matter what
  sketchybar --set workspace."$1" drawing=on \
                         label.color=$ACCENT_COLOR \
                         icon.background.color=$ACCENT_COLOR \
                         background.border_color=$ACCENT_COLOR
}

# Expects the workspace id as the first argument
set_workspace_unfocused() {
  # First, set it to unfocused colors (very fast)
  sketchybar --set workspace."$1" \
                         background.color="$ITEM_BG_COLOR" \
                         label.color=0xFF$MUTED \
                         icon.background.color="0xFF$SUBTLE" \
                         background.border_color="0xFF$SUBTLE"

  #Afterwards, hide it if it has no windows (slower perf)
  # -z means "empty" - ie the workspace has no windows
  if [[ -z "$(aerospace list-windows --workspace $1)" ]]; then
    sketchybar --set workspace."$1" drawing=off
  fi

}
