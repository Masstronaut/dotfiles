#!/bin/bash

_aerospace_window_rows() {
  aerospace list-windows --monitor all --format "%{workspace}|%{app-name}|%{monitor-appkit-nsscreen-screens-id}"
}

_aerospace_spaces_from_rows() {
  local window_rows="$1"
  local focused_space="${2:-}"

  jq -Rn \
    --arg focused "$focused_space" '
      def sort_key($name):
        ("123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" | explode | map([.] | implode)) as $order
        | (($name // "") | ascii_upcase) as $upper
        | ($order | index($upper)) // 999;

      [
        inputs
        | select(length > 0)
        | split("|")
        | select(length >= 3)
        | {name: .[0], window: .[1], display: .[2]}
        | select(.name != "")
      ] as $rows
      | (
          $rows
          | group_by(.name)
          | map({
              name: .[0].name,
              windows: map(.window) | map(select(. != "")),
              display: ([.[].display | select(. != "")][0] // null)
            })
          | map(select((.windows | length) > 0))
        ) as $spaces
      | (
          if $focused != "" and (($spaces | map(.name) | index($focused)) == null) then
            $spaces + [{name: $focused, windows: [], display: null}]
          else
            $spaces
          end
        )
      | sort_by(sort_key(.name), (.name | ascii_upcase))
    ' <<<"$window_rows"
}

spaces() {
  if ! command -v aerospace >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    echo "[]"
    return 1
  fi

  local focused_space window_rows
  focused_space="$(focused_space_name 2>/dev/null || true)"
  window_rows="$(_aerospace_window_rows 2>/dev/null || true)"

  _aerospace_spaces_from_rows "$window_rows" "$focused_space"
}

focused_space_name() {
  if ! command -v aerospace >/dev/null 2>&1; then
    return 1
  fi

  aerospace list-workspaces --focused 2>/dev/null
}

space_by_name() {
  local space_name="$1"

  if [[ -z "$space_name" ]]; then
    echo "null"
    return 1
  fi

  if ! command -v aerospace >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    echo "null"
    return 1
  fi

  local focused_space window_rows
  focused_space="$(focused_space_name 2>/dev/null || true)"
  window_rows="$(_aerospace_window_rows 2>/dev/null || true)"

  jq -c \
    --arg name "$space_name" '
      [.[]? | select(.name == $name)][0] // null
    ' <<<"$(_aerospace_spaces_from_rows "$window_rows" "$focused_space")"
}

space_focus_command_prefix() {
  echo "aerospace workspace"
}

space_item_script_prefix() {
  echo "$CONFIG_DIR/plugins/aerospace.sh"
}

space_item_init_args() {
  local item_name="$1"

  if [[ -z "$item_name" ]]; then
    return 0
  fi

  printf '%s\n' \
    --subscribe "$item_name" display_removed
}

space_event_init_args() {
  local item_name="$1"

  printf '%s\n' \
    --add event aerospace_workspace_change \
    --add event change-window-workspace \
    --add event change-workspace-monitor \
    --subscribe "$item_name" aerospace_workspace_change \
    --subscribe "$item_name" change-window-workspace \
    --subscribe "$item_name" change-workspace-monitor
}

space_event_handler() {
  local sender="$1"

  case "$sender" in
    aerospace_workspace_change)
      refresh_space_focus_from_state
      ;;
    change-window-workspace|change-workspace-monitor)
      refresh_window_manager_spaces
      ;;
  esac
}
