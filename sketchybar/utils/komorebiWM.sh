#!/bin/bash

_komorebi_space_metadata_from_state() {
  local state_json="$1"
  local space_name="${2:-}"

  jq -n \
    --argjson state "$state_json" \
    --arg name "$space_name" '
      def sort_key($name):
        ("123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" | explode | map([.] | implode)) as $order
        | (($name // "") | ascii_upcase) as $upper
        | ($order | index($upper)) // 999;

      def window_name:
        .details.exe
        // .details.title
        // .exe
        // .title
        // "Unknown";

      def container_windows:
        [.containers.elements[]?.windows.elements[]? | window_name];

      def floating_windows:
        [.floating_windows.elements[]? | window_name];

      def monocle_windows:
        if .monocle_container == null
        then []
        else [.monocle_container.windows.elements[]? | window_name]
        end;

      def maximized_windows:
        if .maximized_window == null
        then []
        else [.maximized_window | window_name]
        end;

      [
        $state.monitors.elements[]?.workspaces.elements[]?
        | {
            name: .name,
            windows: (container_windows + floating_windows + monocle_windows + maximized_windows)
          }
        | select(.windows | length > 0)
      ]
      | if $name == "" then
          sort_by(sort_key(.name), (.name | ascii_upcase))
        else
          ([.[] | select(.name == $name)][0] // null)
        end
    '
}

spaces() {
  if ! command -v komorebic >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    echo "[]"
    return 1
  fi

  local state_json
  if ! state_json="$(komorebic state 2>/dev/null)"; then
    echo "[]"
    return 1
  fi

  _komorebi_space_metadata_from_state "$state_json"
}

focused_space_name() {
  if ! command -v komorebic >/dev/null 2>&1; then
    return 1
  fi

  komorebic query focused-workspace-name 2>/dev/null
}

space_by_name() {
  local space_name="$1"

  if [[ -z "$space_name" ]]; then
    echo "null"
    return 1
  fi

  if ! command -v komorebic >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    echo "null"
    return 1
  fi

  local state_json
  if ! state_json="$(komorebic state 2>/dev/null)"; then
    echo "null"
    return 1
  fi

  _komorebi_space_metadata_from_state "$state_json" "$space_name"
}

space_focus_command_prefix() {
  echo "komorebic focus-named-workspace"
}
