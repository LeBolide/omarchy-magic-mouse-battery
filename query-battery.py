#!/usr/bin/env python3

import fcntl
import pathlib
import sys


HIDIOCGINPUT_3 = 0xC003480A
SUPPORTED_IDS = {
    "0005:0000004C:00000269",  # Bluetooth Magic Mouse 2
    "0003:000005AC:00000269",  # USB Magic Mouse 2
}


def properties(path):
    values = {}
    try:
        for line in path.read_text().splitlines():
            key, separator, value = line.partition("=")
            if separator:
                values[key] = value
    except OSError:
        pass
    return values


def direct_read():
    for hidraw in sorted(pathlib.Path("/sys/class/hidraw").glob("hidraw*")):
        device = hidraw / "device"
        info = properties(device / "uevent")
        if info.get("HID_ID") not in SUPPORTED_IDS:
            continue

        report = bytearray((0x90, 0, 0))
        try:
            with open("/dev/" + hidraw.name, "rb", buffering=0) as stream:
                fcntl.ioctl(stream, HIDIOCGINPUT_3, report, True)
        except OSError:
            continue

        percentage = int(report[2])
        if 0 < percentage <= 100:
            return info.get("HID_NAME", "Magic Mouse"), percentage
    return None


def sysfs_fallback():
    for supply in sorted(pathlib.Path("/sys/class/power_supply").glob("hid-*-battery-*")):
        info = properties(supply / "uevent")
        name = info.get("POWER_SUPPLY_MODEL_NAME", "")
        if "magic mouse" not in name.lower():
            continue
        try:
            percentage = int(info.get("POWER_SUPPLY_CAPACITY", "0"))
        except ValueError:
            continue
        if 0 < percentage <= 100:
            return name, percentage
    return None


def charge_state():
    for supply in sorted(pathlib.Path("/sys/class/power_supply").glob("hid-*-battery-*")):
        info = properties(supply / "uevent")
        if "magic mouse" in info.get("POWER_SUPPLY_MODEL_NAME", "").lower():
            return info.get("POWER_SUPPLY_STATUS", "unknown").lower()
    return "unknown"


reading = direct_read() or sysfs_fallback()
if reading is None:
    sys.exit(1)

print(reading[0])
print(reading[1])
print(charge_state())
