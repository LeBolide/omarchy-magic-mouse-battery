# Magic Mouse Battery for Omarchy

A small Omarchy bar widget that displays the battery level of a connected
Apple Magic Mouse.

![Magic Mouse Battery widget in the Omarchy bar](https://raw.githubusercontent.com/LeBolide/omarchy-magic-mouse-battery/87cd36cdb6c93aebfd87ca8ddb4cb8a17aba747c/preview.png)

The widget:

- shows a mouse icon and the current charge percentage;
- displays the Bluetooth-assigned mouse name in its status text;
- reads immediately at startup and when a new HID device connects, then every 2 minutes;
- hides itself when no compatible Bluetooth mouse battery is available;
- adds `charging` to the status only while the device is charging;
- follows the active Omarchy bar theme.

The Linux Bluetooth stack and `hid-magicmouse` kernel driver operate the mouse.
Because some kernels expose an invalid `0%` Bluetooth battery through UPower,
the plugin reads the mouse's standard HID battery report directly and uses the
kernel power-supply value as a fallback.

## Requirements

- Omarchy with the Quickshell-based status bar and `hid-magicmouse` kernel driver
- Python 3 and `udevadm` (both included with a standard Omarchy installation)
- A paired Apple Magic Mouse 2, over Bluetooth or USB
- Administrator access during setup to install one narrowly scoped udev rule

## Installation

```bash
omarchy plugin add \
  https://github.com/LeBolide/omarchy-magic-mouse-battery.git --yes
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/install.sh
```

Review the repository before installation: Omarchy plugins run unsandboxed with
your user permissions. The plugin is initially added disabled. Its installer
validates the plugin, asks `sudo` to install the included udev rule, and then
enables the widget next to Bluetooth.

The rule grants the active desktop session read-only HID-report access for the
Apple Magic Mouse 2 product IDs only. It does not grant access to other HID
devices. The widget keeps a passive `udevadm` listener for new HID devices so it
can refresh when the mouse connects; otherwise it reads the battery every two
minutes. No service, daemon, or network connection is installed.

If the mouse is not paired yet, open the Bluetooth panel in the top bar and pair
it. The pairing step remains interactive because Bluetooth trust and pairing
need explicit confirmation from the user.

If the mouse works but no battery appears, test the bundled reader:

```bash
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/query-battery.py
```

## Updating

```bash
omarchy plugin update io.github.lebolide.magic-mouse-battery
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/install.sh
```

## Removal

```bash
~/.config/omarchy/plugins/io.github.lebolide.magic-mouse-battery/uninstall.sh
```

The uninstaller removes only an installed udev rule that exactly matches the
one shipped by this plugin, reloads udev, and then removes the plugin. It refuses
to delete a modified rule.

## License

MIT
