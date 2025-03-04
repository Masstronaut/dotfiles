#!/bin/bash
# Colors are auto-updated via the ~/.config/themes script
# Simply reloading sketchybar should be sufficient.
# Make sure the reload only runs on a theme change event
if [ "$SENDER" = "theme_change" ]; then
  sketchybar --reload
fi
