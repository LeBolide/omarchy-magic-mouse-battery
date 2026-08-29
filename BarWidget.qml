import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

WidgetButton {
  id: root
  property string moduleName: "magic-mouse-battery"
  property var settings: ({})

  property int percentage: -1
  readonly property string deviceName: "Magic Mouse"
  property string chargeState: "unknown"
  readonly property string statusText: deviceName + ": " + percentage + "%" + (chargeState === "charging" ? " (charging)" : "")

  function refresh() {
    if (!batteryProcess.running) batteryProcess.running = true
  }

  function updateFromOutput(output) {
    var lines = String(output).trim().split("\n")
    if (lines.length < 2 || lines[0] === "") {
      percentage = -1
      return
    }

    percentage = parseInt(lines[0], 10)
    chargeState = lines[1]
    if (isNaN(percentage)) percentage = -1
  }

  bar: null
  text: vertical ? "󰍽" : "󰍽  " + percentage + "%"
  fontSize: Style.font.caption
  tooltipText: statusText
  visible: percentage >= 0
  onPressed: {
    refresh()
    if (bar)
      bar.run("omarchy-notification-send " + bar.shellQuote(statusText))
  }

  Process {
    id: batteryProcess
    command: ["bash", "-c", "device=$(upower -e | grep 'battery_hid_.*_battery' | head -n1); [ -n \"$device\" ] || exit 1; info=$(upower -i \"$device\"); percent=$(printf '%s\\n' \"$info\" | sed -n 's/^[[:space:]]*percentage:[[:space:]]*\\([0-9]*\\)%.*/\\1/p' | head -n1); state=$(printf '%s\\n' \"$info\" | sed -n 's/^[[:space:]]*state:[[:space:]]*//p' | head -n1); [ -n \"$percent\" ] || exit 1; printf '%s\\n%s\\n' \"$percent\" \"${state:-unknown}\"" ]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateFromOutput(text)
    }
    onExited: function(exitCode) {
      if (exitCode !== 0) root.percentage = -1
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

}
