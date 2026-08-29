#!/usr/bin/env bash

set -euo pipefail

plugin_id="io.github.lebolide.magic-mouse-battery"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for command_name in omarchy omarchy-shell; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Error: $command_name is required. This plugin is designed for Omarchy." >&2
    exit 1
  fi
done

if ! command -v upower >/dev/null 2>&1; then
  echo "Installing UPower for battery reporting..."
  omarchy pkg add upower
fi

echo "Validating plugin..."
omarchy plugin validate "$script_dir"

echo "Enabling Magic Mouse Battery in the top-right bar..."
omarchy-shell shell rescanPlugins
omarchy plugin enable "$plugin_id" --after omarchy.bluetooth
omarchy restart shell

if upower -e 2>/dev/null | grep -q 'battery_hid_.*_battery'; then
  echo "Installation complete. A Bluetooth HID battery is available to UPower."
else
  echo "Installation complete. Pair your Magic Mouse from the Bluetooth panel;"
  echo "the battery widget will appear when UPower detects it."
fi
