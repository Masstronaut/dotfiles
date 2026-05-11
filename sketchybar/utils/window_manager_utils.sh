#!/bin/bash

# The shape of space data should be as follows:
# [{"name": "1", "windows": ["Safari", "Mail"]}, ...]

# The helpers in this section should map whatever output from the window manager into this shape. That way each window manager only requires a single adapter to initialize the workspace state for the top bar.

# Set the default window manager if it's not set via the environment.
if [[ -z "${WINDOW_MANAGER:-}" ]]; then
  WINDOW_MANAGER="komorebi"
fi

WINDOW_MANAGER_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Window manager adapters should expose this minimal API:
# - spaces: emit a JSON array of space objects in the shared shape [{name, windows}, ...]
# - focused_space_name: emit the currently focused space name
# - space_by_name <name>: emit one space object in the shared shape, or null if not found
# - space_focus_command_prefix: emit the shell command prefix used to focus a named space
# Optional adapter hooks:
# - space_item_script_prefix: emit a script prefix for per-space items, or empty
# - space_item_init_args <item_name> <space_name>: emit newline-separated sketchybar args for per-item subscriptions/hooks
# - space_event_init_args <item_name>: emit newline-separated sketchybar args for WM-specific events/subscriptions
# - space_event_handler <sender>: handle a WM-specific event by calling shared refresh helpers
source_window_manager_adapter() {
  local adapter_path="$WINDOW_MANAGER_UTILS_DIR/${WINDOW_MANAGER}WM.sh"

  if [[ -f "$adapter_path" ]]; then
    source "$adapter_path"
    return
  fi

  echo "missing window manager adapter: $adapter_path" >&2

  spaces() { echo "[]"; }
  focused_space_name() { return 1; }
  space_by_name() { echo "null"; }
  space_focus_command_prefix() { echo ""; }
  space_item_script_prefix() { echo ""; }
  space_item_init_args() { return 0; }
  space_event_init_args() { return 0; }
  space_event_handler() { return 0; }
}

source_window_manager_adapter

# Load colors when CONFIG_DIR is available so the workspace theme arrays can be shared.
if [[ -n "${CONFIG_DIR:-}" && -f "$CONFIG_DIR/colors.sh" ]]; then
  source "$CONFIG_DIR/colors.sh"
fi

if ! declare -p workspace_base_style >/dev/null 2>&1 && [[ -n "${ITEM_BG_COLOR:-}" ]]; then
  workspace_base_style=(
    background.color="$ITEM_BG_COLOR"
    background.corner_radius=5
    background.height=22
    background.border_width=1
    icon.background.drawing=on
    icon.background.corner_radius=5
    icon.background.height=20
    icon.padding_left=4
    icon.padding_right=6
    icon.color="$ICON_TEXT_COLOR"
    label.font="sketchybar-app-font:Regular:16.0"
    label.padding_left=6
    label.y_offset=-1
  )
fi

if ! declare -p workspace_active_style >/dev/null 2>&1 && [[ -n "${ACCENT_COLOR:-}" ]]; then
  workspace_active_style=(
    label.color="$ACCENT_COLOR"
    icon.background.color="$ACCENT_COLOR"
    background.border_color="$ACCENT_COLOR"
  )
fi

if ! declare -p workspace_inactive_style >/dev/null 2>&1 && [[ -n "${INACTIVE_COLOR:-}" ]]; then
  workspace_inactive_style=(
    label.color="$INACTIVE_COLOR"
    icon.background.color="$INACTIVE_COLOR"
    background.border_color="$INACTIVE_COLOR"
  )
fi

# consumes a json formatted space data array and adds an "icons" field with the output of the icon mapper function for each workspace. 
space_metadata_add_icons() {
  local space_metadata="${1:-[]}"
  local icon_mapper="${CONFIG_DIR:-$HOME/.config/sketchybar}/plugins/icon_map_fn_batched.sh"

  if ! command -v jq >/dev/null 2>&1 || [[ ! -x "$icon_mapper" ]]; then
    echo "$space_metadata"
    return 1
  fi

  local result='[]'

  while IFS= read -r workspace; do
    local windows=()
    while IFS= read -r window_name; do
      [[ -n "$window_name" ]] && windows+=("$window_name")
    done < <(jq -r '.windows[]?' <<<"$workspace")

    local icons=""
    if [[ ${#windows[@]} -gt 0 ]]; then
      icons="$("$icon_mapper" "${windows[@]}")"
      icons="${icons%"${icons##*[![:space:]]}"}"
    fi

    result="$(
      jq -c \
        --argjson workspace "$workspace" \
        --arg icons "$icons" \
        '. + [($workspace + {icons: $icons})]' <<<"$result"
    )"
  done < <(jq -c '.[]' <<<"$space_metadata")

  jq '.' <<<"$result"
}

space_state_file() {
  local state_dir="${CONFIG_DIR:-$HOME/.config/sketchybar}/state"
  printf '%s/spaces.json\n' "$state_dir"
}

read_space_state() {
  local state_file
  state_file="$(space_state_file)"

  if ! command -v jq >/dev/null 2>&1 || [[ ! -f "$state_file" ]]; then
    echo '{"focused":null,"spaces":[]}'
    return
  fi

  jq -c '
    if type == "array" then
      {focused: null, spaces: .}
    else
      {
        focused: (.focused // null),
        spaces: (.spaces // [])
      }
    end
  ' "$state_file"
}

read_space_metadata_state() {
  read_space_state | jq '.spaces'
}

write_space_state_snapshot() {
  local space_metadata="${1:-[]}"
  local focused_space="${2:-}"
  local state_dir="${CONFIG_DIR:-$HOME/.config/sketchybar}/state"
  local state_file="$state_dir/spaces.json"

  if ! command -v jq >/dev/null 2>&1; then
    return 1
  fi

  if [[ -z "$focused_space" ]]; then
    focused_space="$(focused_space_name 2>/dev/null || true)"
  fi

  mkdir -p "$state_dir"
  jq -n \
    --arg focused "$focused_space" \
    --argjson spaces "$space_metadata" '
      {
        focused: (if $focused == "" then null else $focused end),
        spaces: $spaces
      }
    ' > "$state_file"
}

write_space_metadata_state() {
  local space_metadata="${1:-[]}"
  write_space_state_snapshot "$space_metadata"
}

generate_space_item_args_from_metadata() {
  local space_metadata="${1:-[]}"
  local click_command_prefix="${2:-}"
  local item_script_prefix="${3:-}"

  if ! command -v jq >/dev/null 2>&1; then
    return 1
  fi

  jq -r '
    def sort_key($name):
      ("123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" | explode | map([.] | implode)) as $order
      | (($name // "") | ascii_upcase) as $upper
      | ($order | index($upper)) // 999;

    sort_by(sort_key(.name), (.name | ascii_upcase))
    | .[]
    | [.name, (.icons // ""), ((.display // "") | tostring)]
    | @tsv
  ' <<<"$space_metadata" | while IFS=$'\t' read -r space_name space_icons space_display; do
    [[ -n "$space_name" ]] || continue

    printf '%s\n' \
      --add item "workspace.$space_name" left \
      --set "workspace.$space_name" \
      drawing=on \
      "${workspace_base_style[@]}" \
      "${workspace_inactive_style[@]}" \
      icon="$space_name" \
      label="$space_icons"

    if [[ -n "$space_display" ]]; then
      printf '%s\n' "display=$space_display"
    fi

    if [[ -n "$click_command_prefix" ]]; then
      printf '%s\n' "click_script=$click_command_prefix $space_name"
    fi

    if [[ -n "$item_script_prefix" ]]; then
      printf '%s\n' "script=$item_script_prefix $space_name"
    fi

    while IFS= read -r init_arg; do
      [[ -n "$init_arg" ]] && printf '%s\n' "$init_arg"
    done < <(space_item_init_args "workspace.$space_name" "$space_name")
  done
}

create_space_items_from_metadata() {
  local space_metadata="${1:-[]}"
  local click_command_prefix="${2:-}"
  local item_script_prefix="${3:-}"
  local all_args=()

  while IFS= read -r arg; do
    [[ -n "$arg" ]] && all_args+=("$arg")
  done < <(generate_space_item_args_from_metadata "$space_metadata" "$click_command_prefix" "$item_script_prefix")

  if [[ ${#all_args[@]} -gt 0 ]]; then
    sketchybar "${all_args[@]}"
  fi

  write_space_state_snapshot "$space_metadata"
}

create_window_manager_workspaces() {
  local space_metadata="${1:-}"
  local focus_command_prefix=""
  local item_script_prefix=""

  # Fast path: pass precomputed metadata with icons to avoid extra subprocesses.
  if [[ -z "$space_metadata" ]]; then
    space_metadata="$(space_metadata_add_icons "$(spaces)")"
  fi

  focus_command_prefix="$(space_focus_command_prefix 2>/dev/null || true)"
  item_script_prefix="$(space_item_script_prefix 2>/dev/null || true)"
  create_space_items_from_metadata "$space_metadata" "$focus_command_prefix" "$item_script_prefix"
  refresh_space_focus_from_state
}

space_item_exists() {
  local space_name="$1"

  if [[ -z "$space_name" ]]; then
    return 1
  fi

  sketchybar --query "workspace.$space_name" >/dev/null 2>&1
}

ensure_space_item_exists() {
  local space_name="$1"
  local current_state single_space_metadata all_args=()
  local anchor_item="workspace_separator"
  local focus_command_prefix=""
  local item_script_prefix=""

  if [[ -z "$space_name" ]] || space_item_exists "$space_name"; then
    return
  fi

  current_state="$(read_space_state)"
  single_space_metadata="$(
    jq -c \
      --arg name "$space_name" '
        [.spaces[]? | select(.name == $name)][0]?
      ' <<<"$current_state"
  )"

  if [[ -z "$single_space_metadata" || "$single_space_metadata" == "null" ]]; then
    single_space_metadata="$(space_by_name "$space_name")"

    if [[ -n "$single_space_metadata" && "$single_space_metadata" != "null" ]]; then
      single_space_metadata="$(
        jq -c '.[0]?' <<<"$(space_metadata_add_icons "[$single_space_metadata]")"
      )"
    fi
  fi

  if [[ -z "$single_space_metadata" || "$single_space_metadata" == "null" ]]; then
    single_space_metadata="$(jq -cn --arg name "$space_name" '{name: $name, windows: [], icons: ""}')"
  fi

  while IFS= read -r arg; do
    [[ -n "$arg" ]] && all_args+=("$arg")
  done < <(
    focus_command_prefix="$(space_focus_command_prefix 2>/dev/null || true)"
    item_script_prefix="$(space_item_script_prefix 2>/dev/null || true)"
    generate_space_item_args_from_metadata "[$single_space_metadata]" "$focus_command_prefix" "$item_script_prefix"
  )

  anchor_item="$(
    jq -r \
      --arg name "$space_name" '
        (
          [.spaces[]?.name | select(. > $name)]
          | sort
          | .[0]
        ) // "workspace_separator"
        | if . == "workspace_separator" then . else "workspace." + . end
      ' <<<"$current_state"
  )"
  all_args+=(--move "workspace.$space_name" before "$anchor_item")

  if [[ ${#all_args[@]} -gt 0 ]]; then
    sketchybar "${all_args[@]}"
  fi
}

set_space_focused() {
  local space_name="$1"

  if [[ -z "$space_name" ]]; then
    return
  fi

  ensure_space_item_exists "$space_name"

  sketchybar --set "workspace.$space_name" \
    drawing=on \
    "${workspace_active_style[@]}" >/dev/null 2>&1 || true
}

set_space_unfocused() {
  local space_name="$1"

  if [[ -z "$space_name" ]]; then
    return
  fi

  sketchybar --set "workspace.$space_name" \
    "${workspace_inactive_style[@]}" >/dev/null 2>&1 || true
}

refresh_space_focus_from_state() {
  local current_state old_focused new_focused spaces focused_space_metadata
  current_state="$(read_space_state)"
  old_focused="$(jq -r '.focused // empty' <<<"$current_state")"
  spaces="$(jq -c '.spaces // []' <<<"$current_state")"
  new_focused="$(focused_space_name 2>/dev/null || true)"

  if [[ -n "$new_focused" ]]; then
    focused_space_metadata="$(
      jq -c \
        --arg name "$new_focused" '
          [.[]? | select(.name == $name)][0]?
        ' <<<"$spaces"
    )"

    if [[ -z "$focused_space_metadata" || "$focused_space_metadata" == "null" ]]; then
      focused_space_metadata="$(space_by_name "$new_focused")"

      if [[ -n "$focused_space_metadata" && "$focused_space_metadata" != "null" ]]; then
        focused_space_metadata="$(
          jq -c '.[0]?' <<<"$(space_metadata_add_icons "[$focused_space_metadata]")"
        )"
      fi

      if [[ -n "$focused_space_metadata" && "$focused_space_metadata" != "null" ]]; then
        spaces="$(
          jq -c \
            --argjson space "$focused_space_metadata" '
              . + [$space]
            ' <<<"$spaces"
        )"
      fi
    fi
  fi

  if [[ -n "$old_focused" && "$old_focused" != "$new_focused" ]]; then
    set_space_unfocused "$old_focused"
  fi

  if [[ -n "$new_focused" ]]; then
    set_space_focused "$new_focused"
  fi

  write_space_state_snapshot "$spaces" "$new_focused"
}

reconcile_space_items_from_metadata() {
  local space_metadata="${1:-[]}"
  local click_command_prefix="${2:-}"
  local item_script_prefix="${3:-}"
  local current_state old_spaces focused_space all_args=()
  local anchor_item="workspace_separator"

  current_state="$(read_space_state)"
  old_spaces="$(jq -c '.spaces // []' <<<"$current_state")"
  focused_space="$(focused_space_name 2>/dev/null || true)"

  while IFS= read -r removed_space; do
    [[ -n "$removed_space" ]] || continue
    all_args+=(--remove "workspace.$removed_space")
  done < <(
    jq -r -n \
      --argjson old "$old_spaces" \
      --argjson new "$space_metadata" '
        (($old | map(.name)) - ($new | map(.name)))
        | .[]?
      '
  )

  while IFS=$'\t' read -r space_name space_icons space_display existed_before changed_before; do
    [[ -n "$space_name" ]] || continue

    if [[ "$existed_before" == "0" ]]; then
      all_args+=(
        --add item "workspace.$space_name" left
        --set "workspace.$space_name"
        drawing=on
        "${workspace_base_style[@]}"
        "${workspace_inactive_style[@]}"
        icon="$space_name"
        label="$space_icons"
      )

      if [[ -n "$space_display" ]]; then
        all_args+=("display=$space_display")
      fi

      if [[ -n "$click_command_prefix" ]]; then
        all_args+=("click_script=$click_command_prefix $space_name")
      fi

      if [[ -n "$item_script_prefix" ]]; then
        all_args+=("script=$item_script_prefix $space_name")
      fi

      while IFS= read -r init_arg; do
        [[ -n "$init_arg" ]] && all_args+=("$init_arg")
      done < <(space_item_init_args "workspace.$space_name" "$space_name")
    elif [[ "$changed_before" == "1" ]]; then
      all_args+=(
        --set "workspace.$space_name"
        drawing=on
        "${workspace_inactive_style[@]}"
        label="$space_icons"
      )

      if [[ -n "$space_display" ]]; then
        all_args+=("display=$space_display")
      fi
    fi

    all_args+=(--move "workspace.$space_name" before "$anchor_item")
    anchor_item="workspace.$space_name"
  done < <(
    jq -r -n \
      --argjson old "$old_spaces" \
      --argjson new "$space_metadata" '
        def sort_key($name):
          ("123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" | explode | map([.] | implode)) as $order
          | (($name // "") | ascii_upcase) as $upper
          | ($order | index($upper)) // 999;

        def old_space($name):
          ([ $old[]? | select(.name == $name) ][0]);

        ($new | sort_by(sort_key(.name), (.name | ascii_upcase)) | reverse)[]?
        | . as $space
        | (old_space($space.name)) as $old_space
        | [
            $space.name,
            ($space.icons // ""),
            (($space.display // "") | tostring),
            (if $old_space == null then "0" else "1" end),
            (
              if $old_space == null then
                "0"
              elif (($old_space.icons // "") != ($space.icons // "")) then
                "1"
              elif ((($old_space.display // "") | tostring) != (($space.display // "") | tostring)) then
                "1"
              else
                "0"
              end
            )
          ]
        | @tsv
      '
  )

  if [[ ${#all_args[@]} -gt 0 ]]; then
    sketchybar "${all_args[@]}"
  fi

  if [[ -n "$focused_space" ]]; then
    set_space_focused "$focused_space"
  fi

  write_space_state_snapshot "$space_metadata" "$focused_space"
}

refresh_window_manager_spaces() {
  local space_metadata
  local focus_command_prefix=""
  local item_script_prefix=""
  space_metadata="$(space_metadata_add_icons "$(spaces)")"
  focus_command_prefix="$(space_focus_command_prefix 2>/dev/null || true)"
  item_script_prefix="$(space_item_script_prefix 2>/dev/null || true)"
  reconcile_space_items_from_metadata "$space_metadata" "$focus_command_prefix" "$item_script_prefix"
}
