#!/bin/bash

if [ "$SENDER" = "space_windows_change" ]; then
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    # Convert apps to array for batched processing
    app_array=()
    while read -r app; do
      [[ -n "$app" ]] && app_array+=("$app")
    done <<< "${apps}"
    
    if [[ ${#app_array[@]} -gt 0 ]]; then
      icon_strip="$($CONFIG_DIR/plugins/icon_map_fn_batched.sh "${app_array[@]}")"
    fi
  else
    icon_strip=" —"
  fi
  sketchybar --set space.$space label="$icon_strip"
fi
