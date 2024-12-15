#!/bin/bash

# Identify the wifi interface device
WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $NF}')

# Get the wifi name
WIFI_NAME=$(NEtworksetup -getairportnetwork $WIFI_INTERFACE | awk -F ": " '{print $2}')

# Wifi state can be "On" or "Off"
CURRENT_STATE=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')

source ~/.config/sketchybar/colors.sh
update_wifi() {
  if [[ $CURRENT_STATE = "Off" ]]; then
    ICON="􀙈" # sf symbols wifi.slash icon
    LABEL=""
    # 0 is interpreted by sketchybar as "use the default"
    ICON_COLOR=$TEXT_COLOR
  else
    ICON="􀙇" # sf symbols wifi icon
    if [[ -n $WIFI_NAME ]]; then
      LABEL="$WIFI_NAME"
      ICON_COLOR=$TEXT_COLOR
    else
      LABEL=""
      # Fade the icon a bit if wifi is on but not connected 
      ICON_COLOR=0xA0$TEXT
    fi
  fi

  sketchybar --set $NAME icon="$ICON" label="$LABEL" icon.color=$ICON_COLOR
}

toggle_wifi() {
  if [ "$CURRENT_STATE" = "On" ]; then
      networksetup -setairportpower $WIFI_INTERFACE off
  else
      networksetup -setairportpower $WIFI_INTERFACE on
  fi
}

case "$SENDER" in
    "routine"|"wifi_change") update_wifi ;;
    "mouse.clicked") 
        toggle_wifi ;;
esac


