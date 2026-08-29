# Magic Mouse Battery for Omarchy

A small Omarchy bar widget that displays the battery level of a connected
Apple Magic Mouse.

The widget:

- shows a mouse icon and the current charge percentage;
- displays the Bluetooth-assigned mouse name in its status text;
- refreshes automatically every 10 seconds during the current testing phase;
- hides itself when no compatible Bluetooth mouse battery is available;
- adds `charging` to the status only while the device is charging;
- follows the active Omarchy bar theme.

The Linux Bluetooth stack and `hid-magicmouse` kernel driver operate the mouse.
Because some kernels expose an invalid `0%` Bluetooth battery through UPower,
the plugin reads the mouse's standard HID battery report directly and uses the
kernel power-supply value as a fallback.

## Requirements

- Omarchy with the Quickshell-based status bar
- Python 3
- A paired Apple Magic Mouse 2

## Installation

```bash
git clone https://github.com/LeBolide/omarchy-magic-mouse-battery.git \
  ~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/install.sh
```

The installer adds a narrowly scoped udev rule for Apple Magic Mouse 2 HID
battery reads, validates the plugin, enables it next to Bluetooth, and refreshes
the Omarchy shell. If the mouse is not paired yet, open the Bluetooth panel in
the top bar and pair it.

The pairing step remains interactive because Bluetooth trust and pairing need
explicit confirmation from the user.

If the mouse works but no battery appears, test the bundled reader:

```bash
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/query-battery.py
```

## Updating

```bash
git -C ~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery pull
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/install.sh
```

## Removal

```bash
omarchy plugin remove io.github.lebolide.magic-mouse-battery --yes
sudo rm /etc/udev/rules.d/70-magic-mouse-battery.rules
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=hidraw
```

## License

MIT
