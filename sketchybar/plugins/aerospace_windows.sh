#!/bin/bash

source $CONFIG_DIR/utils/aerospace.sh

for sid in $(aerospace list-workspaces --all); do
  # sketchybar --set "space.$sid" icon="$sid $icon_strip"
  sketchybar --set "workspace.$sid" \
    label="$(workspace_app_icons $sid)" \
    icon="$sid"                     
done

