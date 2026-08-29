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

echo "Validating plugin..."
omarchy plugin validate "$script_dir"

rule_source="$script_dir/70-magic-mouse-battery.rules"
rule_target="/etc/udev/rules.d/70-magic-mouse-battery.rules"

if ! cmp -s "$rule_source" "$rule_target"; then
  echo "Installing narrowly scoped Magic Mouse HID access rule..."
  sudo install -m 0644 "$rule_source" "$rule_target"
  sudo udevadm control --reload-rules
  sudo udevadm trigger --subsystem-match=hidraw
fi

echo "Enabling Magic Mouse Battery in the top-right bar..."
omarchy-shell shell rescanPlugins
omarchy plugin enable "$plugin_id" --after omarchy.bluetooth
omarchy restart shell

if "$script_dir/query-battery.py" >/dev/null 2>&1; then
  echo "Installation complete. The Magic Mouse battery is readable."
else
  echo "Installation complete. Pair your Magic Mouse from the Bluetooth panel;"
  echo "then reconnect it once if the battery widget does not appear."
fi
