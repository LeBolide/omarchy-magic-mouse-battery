import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

WidgetButton {
  id: root
  property string moduleName: "io.github.lebolide.magic-mouse-battery"
  property var settings: ({})

  property int percentage: -1
  property string deviceName: "Magic Mouse"
  property string chargeState: "unknown"
  readonly property string queryScript: String(Qt.resolvedUrl("query-battery.py")).replace("file://", "")
  readonly property string statusText: deviceName + ": " + percentage + "%" + (chargeState === "charging" ? " (charging)" : "")

  function refresh() {
    if (!batteryProcess.running) batteryProcess.running = true
  }

  function updateFromOutput(output) {
    var lines = String(output).trim().split("\n")
    if (lines.length < 3 || lines[0] === "") {
      percentage = -1
      return
    }

    deviceName = lines[0]
    percentage = parseInt(lines[1], 10)
    chargeState = lines[2]
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
    command: ["python3", root.queryScript]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateFromOutput(text)
    }
    onExited: function(exitCode) {
      if (exitCode !== 0) root.percentage = -1
    }
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

}
