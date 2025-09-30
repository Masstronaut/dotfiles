#!/bin/bash

# Source the rose-pine theme
source ~/.config/themes/rose-pine.sh

# Debug output
echo "Setting PINE to: #$PINE" >> /tmp/tmux-colors.log

# Set tmux options with # prefix for colors
tmux set-option -g @base "#$BASE"
tmux set-option -g @surface "#$SURFACE"
tmux set-option -g @overlay "#$OVERLAY"
tmux set-option -g @muted "#$MUTED"
tmux set-option -g @subtle "#$SUBTLE"
tmux set-option -g @text "#$TEXT"
tmux set-option -g @love "#$LOVE"
tmux set-option -g @gold "#$GOLD"
tmux set-option -g @rose "#$ROSE"
tmux set-option -g @pine "#$PINE"
tmux set-option -g @foam "#$FOAM"
tmux set-option -g @iris "#$IRIS"
tmux set-option -g @highlight_low "#$HIGHLIGHT_LOW"
tmux set-option -g @highlight_high "#$HIGHLIGHT_HIGH"
tmux set-option -g @highlight_med "#$HIGHLIGHT_MED"