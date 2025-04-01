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

# Get the system monitor ID of the specified workspace. 
# Expects the workspace ID as the first argument
# Returns the monitor ID of the workspace
# returns nothing (empty string) if the workspace has no windows.
get_workspace_monitor_id() {
  local workspace_id="$1"
  # aerospace command that returns all windows in the workspace, formatted as only the system monitor ID
  # each workspace is 1 character long, so truncate the output to only the first character
  local aerospace_result=$(aerospace list-windows --workspace $workspace_id --format "%{monitor-appkit-nsscreen-screens-id}")
  local monitor_id=${aerospace_result:0:1}
  echo $monitor_id
}

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
    local drawing="off"
    # this will return the monitor ID of the workspace, or an empty string if the workspace has no windows
    local monitor_id=$(get_workspace_monitor_id $sid)
    # -n means "nonzero" length string - ie the space has at least 1 window 
    if [[ -n $monitor_id ]]; then
      drawing="on"
    fi

    # Create the workspace item for the provided space ID
    sketchybar --add item workspace.$sid left \
        --set workspace.$sid \
        drawing="$drawing" \
        display="$monitor_id" \
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
sort_alphanumeric() {
  # Read input from positional argument
  local input=($(echo "$1" | tr ' ' '\n'))

  # Process input: remove duplicates and sort
  printf "%s\n" "${input[@]}" | sort -u
}
list_active_workspaces() {
  local window_workspaces=$(aerospace list-windows --monitor all --format %{workspace})
  window_workspaces="$window_workspaces"$'\n'"$(aerospace list-workspaces --focused)"
  sort_alphanumeric "$window_workspaces" 
}

# Create all of the workspace items
create_aerospace_workspaces() {
  local focused_workspace=$(aerospace list-workspaces --focused)
  local active_workspaces=$( list_active_workspaces )

  # lazy initialization of workspaces helps sketchybar startup times.
  # Only create a workspace item once the workspace is focused or has a window in it
  for sid in $active_workspaces; do
    # log the execution time of the function in a log file
    # { echo -n "creating workspace $sid. Timing: "; time create_workspace $sid; } 2>&1 | tee -a /tmp/sketchybar.log
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

# Use this to detect if an item needs to be created
sketchybar_item_exists() {
  local item_name="$1"
  
  # Check if the item exists in SketchyBar's list of items
  if sketchybar --query "$item_name" &>/dev/null; then
    return 0  # Item exists
  else
    return 1  # Item does not exist
  fi
}

# Generates a sketchybar --reorder command to correctly sort workspace items
# This should be used whenever a new workspace item is created after initialization
# to ensure that the workspace items are sorted in the correct order
order_workspace_items() {
  # Read input from positional argument
  local input=($(echo "$1" | tr ' ' '\n'))

  # Process input: remove duplicates and sort
  local sorted=($(printf "%s\n" "${input[@]}" | sort -u))

  # Expand into sketchybar --reorder format
  printf "sketchybar --reorder"
  for item in "${sorted[@]}"; do
    printf " \"workspace.%s\"" "$item"
  done
  printf " workspace_separator front_app \n"
}


# Expects the workspace id as the first argument
set_workspace_focused() {
  if ! sketchybar_item_exists "workspace.$1"; then
    create_workspace $1
    local active_workspaces=$( list_active_workspaces )
    local reorder_workspace_items_command=$(order_workspace_items "$active_workspaces" )
    eval "$reorder_workspace_items_command"
  fi
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

