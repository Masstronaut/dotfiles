#!/bin/bash

set -euo pipefail

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

require_command komorebic
require_command jq

state_json="$(komorebic state)"

jq -n --argjson state "$state_json" '
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
  | sort_by(sort_key(.name), (.name | ascii_upcase))
'
