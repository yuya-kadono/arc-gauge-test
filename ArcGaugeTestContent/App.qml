import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ArcGaugeTest

Window {
    width: Constants.width
    height: Constants.height

    visible: true
    title: "ArcGaugeTest"

    StackLayout {
        id: stack
        anchors.fill: parent
        currentIndex: 0

        Screen01 { id: screen01 }
        Screen02 { id: screen02 }
        Screen03 { id: screen03 }
    }

    // スクリーン切り替えドット（下中央）
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        spacing: 10
        z: 10

        Repeater {
            model: 3
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: stack.currentIndex === index ? "#4a6fa5" : "#b0b8c8"
                MouseArea {
                    anchors.fill: parent
                    onClicked: stack.currentIndex = index
                }
            }
        }
    }
}
