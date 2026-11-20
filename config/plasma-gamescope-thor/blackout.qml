import QtQuick
import QtQuick.Window

Window {
    visible: true
    visibility: Window.FullScreen
    color: "#000000"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    title: qsTr("bottom-screen-blackout-thor")
    
    MouseArea {
        anchors.fill: parent
        onDoubleClicked: Qt.quit()
    }
}
