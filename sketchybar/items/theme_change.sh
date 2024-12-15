#!/bin/bash

# This needs to be an item to subscribe to an event

sketchybar --add item theme_change_handler right \
           --set theme_change_handler drawing=off \
           --set theme_change_handler script="$PLUGIN_DIR/theme_change.sh" \
           --subscribe theme_change_handler theme_change 
