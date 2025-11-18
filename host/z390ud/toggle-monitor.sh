#!/usr/bin/env bash
action="$1"
shift

for mon in "$@"; do
  hyprctl dispatch dpms "$action" "$mon"
done
