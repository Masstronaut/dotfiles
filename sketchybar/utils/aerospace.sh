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


