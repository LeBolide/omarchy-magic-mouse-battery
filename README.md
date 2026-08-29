# Magic Mouse Battery for Omarchy

A small Omarchy bar widget that displays the battery level of a connected
Apple Magic Mouse.

The widget:

- shows a mouse icon and the current charge percentage;
- refreshes automatically every 30 seconds;
- hides itself when no compatible Bluetooth mouse battery is available;
- adds `charging` to the status only while the device is charging;
- follows the active Omarchy bar theme.

## Requirements

- Omarchy with the Quickshell-based status bar
- `upower`
- A paired Apple Magic Mouse that exposes its battery through UPower

## Installation

```bash
git clone https://github.com/<your-account>/omarchy-magic-mouse-battery.git \
  ~/.config/omarchy/plugins/magic-mouse-battery
omarchy-shell shell rescanPlugins
omarchy plugin enable magic-mouse-battery --after omarchy.bluetooth
```

If the bar does not refresh immediately:

```bash
omarchy restart shell
```

## Updating

```bash
git -C ~/.config/omarchy/plugins/magic-mouse-battery pull
omarchy restart shell
```

## License

MIT
