#!/usr/bin/env bash

set -euo pipefail

plugin_id="io.github.lebolide.magic-mouse-battery"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
rule_source="$script_dir/70-magic-mouse-battery.rules"
rule_target="/etc/udev/rules.d/70-magic-mouse-battery.rules"

if [[ -e "$rule_target" ]]; then
  if ! cmp -s "$rule_source" "$rule_target"; then
    echo "Error: refusing to remove $rule_target because it differs from this plugin's rule." >&2
    exit 1
  fi

  echo "Removing the Magic Mouse HID access rule..."
  sudo rm -- "$rule_target"
  sudo udevadm control --reload-rules
  sudo udevadm trigger --subsystem-match=hidraw
fi

echo "Removing the Magic Mouse Battery plugin..."
omarchy plugin remove "$plugin_id" --yes
