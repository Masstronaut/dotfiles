#!/bin/bash

WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')
WIFI_NAME=$(networksetup -listpreferredwirelessnetworks "$WIFI_INTERFACE" | sed -n '2s/^\t//p')
CURRENT_STATE=$(networksetup -getairportpower $WIFI_INTERFACE | awk '{print $4}')

source $CONFIG_DIR/colors.sh

update_wifi() {
  if [[ $CURRENT_STATE = "Off" ]]; then
    ICON="􀙈"
    LABEL="Disabled"
    COLOR=$ERROR_COLOR
    ICON_COLOR="0xffffffff"
  else
    if [[ -n $WIFI_NAME ]]; then
      ICON="􀙇"
      LABEL="$WIFI_NAME"
      COLOR=$SUCCESS_COLOR
      ICON_COLOR="$ICON_TEXT_COLOR"
    else
      ICON="􀙥"
      LABEL="Disconnected"
      COLOR=$WARNING_COLOR
      ICON_COLOR="$ICON_TEXT_COLOR"
    fi
  fi

  sketchybar --set $NAME icon="$ICON" label="$LABEL" icon.color="$ICON_COLOR" icon.background.color="$COLOR" background.border_color="$COLOR" label.color="$COLOR"
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


