#!/bin/bash

for sid in $(aerospace list-workspaces --all); do
  aerospace_apps=$(aerospace list-windows --workspace $sid)
  apps=""
  if [[ ! -z "$aerospace_apps" ]]; then
    while read -r line
    do
      app_name=$(echo "$line" | awk -F '|' '{gsub(/^ +| +$/, "", $2); print $2}')
      apps+="$app_name\n"
    done < <(echo "$aerospace_apps") # < <() is used to prevent subshell creation in zsh
    # using a subshell would cause the variable to be lost
  fi

  # replace occurrences of `\n` with newlines
  apps=$(printf "%b" "$apps")

  icon_strip=""
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+="$($CONFIG_DIR/plugins/icon_map_fn.sh "$app") "
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi
  icon_strip=$(echo "$icon_strip" | tr -d '\n')
  echo "icon strip for space $sid: '$icon_strip'" >> /tmp/space.log
  # sketchybar --set "space.$sid" icon="$sid $icon_strip"
  sketchybar --set "workspace.$sid" \
    label="$icon_strip"             \
    icon="$sid"                     
done

