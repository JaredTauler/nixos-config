#!/usr/bin/env bash

hyprctl -j events -u | while IFS= read -r line; do
  case "$line" in
    *\"event\":\"openwindow\"* )
      hyprctl dispatch fullscreen 0
      ;;
  esac
done
