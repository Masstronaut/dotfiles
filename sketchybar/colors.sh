#!/bin/bash

source ~/.config/themes/rose-pine.sh

export BAR_COLOR="0x40$BASE"     # base
export ITEM_BG_COLOR="0x40$SURFACE" # surface
export ACCENT_COLOR="0xff$GOLD"  # gold
export TEXT_COLOR="0xff$TEXT"    # text
export ITEM_LABEL_COLOR="0xff$IRIS"

# Semantic color variables for theming
export INACTIVE_COLOR="0xFF$SUBTLE"  # borders and inactive backgrounds
export MUTED_COLOR="0xFF$MUTED"      # inactive labels and secondary text
export SUCCESS_COLOR="0xFF$PINE"     # good status (low usage)
export WARNING_COLOR="0xFF$GOLD"     # medium status
export ERROR_COLOR="0xFF$LOVE"       # critical status
