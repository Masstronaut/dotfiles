#!/bin/bash

# Add the sketchybar cask and install it
brew tap FelixKratz/formulae
brew install sketchybar

# Install a command line JSON processor, jq
brew install jq

## Add the hack & SF nerd font and icons
brew install --cask font-hack-nerd-font
brew install --cask font-sf-pro
brew install --cask sf-symbols

# Install the sketchybar app font
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.24/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# Get the icon map function
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.24/icon_map.sh -o ~/.config/sketchybar/plugins/icon_map_fn.sh

# If app icons aren't showing up, check in the icon_map_fn file to make sure the function name didn't change
echo "__icon_map \"\$1\"" >> ~/.config/sketchybar/plugins/icon_map_fn.sh
echo "echo \"\$icon_result\"" >> ~/.config/sketchybar/plugins/icon_map_fn.sh

# make the icon map fn executable
chmod +x ~/.config/sketchybar/plugins/icon_map_fn.sh

# make the sketchybar config executable
chmod +x ~/.config/sketchybar/sketchbarrc

# Start the sketchybar service
# NOTE: This is commented out because it's launched by aerospace now. Uncomment if you want to start it manually or aren't using aerospace
# brew services start sketchybar
