#!/bin/bash

# rose-pine main theme
set_main_theme() {
  BASE="191724"
  SURFACE="1f1d2e"
  OVERLAY="26233a"
  MUTED="6e6a86"
  SUBTLE="908caa"
  TEXT="e0def4"
  LOVE="eb6f92"
  GOLD="f6c177"
  ROSE="ebbcba"
  PINE="31748f"
  FOAM="31748f"
  IRIS="c4a7e7"
  HIGHLIGHT_LOW="21202e"
  HIGHLIGHT_MED="403d52"
  HIGHLIGHT_HIGH="524f67"
}

# rose-pine dawn color theme
set_dawn_theme() {
  BASE="faf4ed"
  SURFACE="fffaf3"
  OVERLAY="f2e9e1"
  MUTED="9893a5"
  SUBTLE="797593"
  TEXT="575279"
  LOVE="b4637a"
  GOLD="ea9d34"
  ROSE="d7827e"
  PINE="286983"
  FOAM="56949f"
  IRIS="907aa9"
  HIGHLIGHT_LOW="f4ede8"
  HIGHLIGHT_MED="dfdad9"
  HIGHLIGHT_HIGH="cecacd"
}

# Attempt to read the AppleInterfaceStyle to get the system appearance setting
appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

# Check the result and return "light" or "dark"
if [ "$appearance" == "Dark" ]; then
  set_main_theme
else # rose-pine dawn theme
  set_dawn_theme
fi

export BASE SURFACE OVERLAY MUTED SUBTLE TEXT LOVE GOLD ROSE PINE FOAM IRIS HIGHLIGHT_LOW HIGHLIGHT_MED HIGHLIGHT_HIGH

