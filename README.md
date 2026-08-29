# Magic Mouse Battery for Omarchy

A small Omarchy bar widget that displays the battery level of a connected
Apple Magic Mouse.

The widget:

- shows a mouse icon and the current charge percentage;
- displays the Bluetooth-assigned mouse name in its status text;
- refreshes automatically every 30 seconds;
- hides itself when no compatible Bluetooth mouse battery is available;
- adds `charging` to the status only while the device is charging;
- follows the active Omarchy bar theme.

The Linux Bluetooth stack and `hid-magicmouse` kernel driver operate the mouse.
UPower is used only to read its battery level; the installer adds UPower when
it is not already present.

## Requirements

- Omarchy with the Quickshell-based status bar
- `upower`
- A paired Apple Magic Mouse that exposes its battery through UPower

## Installation

```bash
git clone https://github.com/LeBolide/omarchy-magic-mouse-battery.git \
  ~/.config/omarchy/plugins/magic-mouse-battery
~/.config/omarchy/plugins/magic-mouse-battery/install.sh
```

The installer checks or installs UPower, validates the plugin, enables it next
to Bluetooth, and refreshes the Omarchy shell. If the mouse is not paired yet,
open the Bluetooth panel in the top bar and pair it; the widget will appear
automatically once UPower reports its battery.

The pairing step remains interactive because Bluetooth trust and pairing need
explicit confirmation from the user.

If the mouse works but no battery appears, check whether UPower sees it:

```bash
upower -e | grep battery_hid
```

## Updating

```bash
git -C ~/.config/omarchy/plugins/magic-mouse-battery pull
~/.config/omarchy/plugins/magic-mouse-battery/install.sh
```

## License

MIT
