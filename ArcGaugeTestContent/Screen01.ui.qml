/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Studio.Components
import ArcGaugeTest

Rectangle {
    id: root
    width: Constants.width
    height: Constants.height

    color: Constants.backgroundColor

    // ─── コントロールパネル（左） ─────────────────────────────────────────
    Rectangle {
        id: panel
        width: 210
        height: root.height
        anchors.left: root.left
        color: "#e8e8e8"
        border.color: "#bbb"
        border.width: 1
        z: 1

        ScrollView {
            id: sv
            anchors.fill: parent
            anchors.margins: 6
            contentWidth: availableWidth

            ColumnLayout {
                width: sv.availableWidth
                spacing: 0

                // ── レベル1ヘッダー（コンポーネント単位） ───────────────
                component SectionHeader: Rectangle {
                    property alias title: label.text
                    property bool expanded: true
                    signal toggled(bool open)
                    Layout.fillWidth: true
                    height: 28
                    color: "#7a8fac"
                    radius: 3
                    Text {
                        id: label
                        anchors.verticalCenter: parent.verticalCenter
                        x: 8
                        font.bold: true
                        font.pixelSize: 13
                        color: "white"
                    }
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: parent.expanded ? "▼" : "▶"
                        font.pixelSize: 10
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parent.expanded = !parent.expanded
                            parent.toggled(parent.expanded)
                        }
                    }
                }

                // ── レベル2ヘッダー（カテゴリ単位） ──────────────────────
                component SubHeader: Rectangle {
                    property alias title: label.text
                    property bool expanded: true
                    signal toggled(bool open)
                    Layout.fillWidth: true
                    height: 22
                    color: "#b0b8c8"
                    radius: 2
                    Text {
                        id: label
                        anchors.verticalCenter: parent.verticalCenter
                        x: 14
                        font.bold: true
                        font.pixelSize: 11
                    }
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        anchors.verticalCenter: parent.verticalCenter
                        text: parent.expanded ? "▼" : "▶"
                        font.pixelSize: 9
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parent.expanded = !parent.expanded
                            parent.toggled(parent.expanded)
                        }
                    }
                }

                // ═══════════════════════════════════════════════════════
                // コンポーネント: baseArc
                // ═══════════════════════════════════════════════════════
                SectionHeader {
                    id: hdrBaseArc
                    title: "baseArc"
                    onToggled: (open) => bodyBaseArc.visible = open
                }
                ColumnLayout {
                    id: bodyBaseArc
                    Layout.fillWidth: true
                    spacing: 0

                    // ── カテゴリ: 角度 ──────────────────────────────────
                    SubHeader {
                        id: hdrAngle
                        title: "角度"
                        onToggled: (open) => bodyAngle.visible = open
                    }
                    ColumnLayout {
                        id: bodyAngle
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        spacing: 2
                        Text { text: "begin: " + baseArc.begin.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 360; value: 0; stepSize: 1
                            onMoved: baseArc.begin = value
                        }
                        Text { text: "end: " + baseArc.end.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 360; value: 180; stepSize: 1
                            onMoved: baseArc.end = value
                        }
                        Item { Layout.preferredHeight: 4 }
                    }

                    // ── カテゴリ: 線スタイル ────────────────────────────
                    SubHeader {
                        id: hdrStroke
                        title: "線スタイル"
                        onToggled: (open) => bodyStroke.visible = open
                    }
                    ColumnLayout {
                        id: bodyStroke
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        spacing: 2
                        Text { text: "strokeWidth: " + baseArc.strokeWidth.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 0; to: 100; value: 50; stepSize: 1
                            onMoved: baseArc.strokeWidth = value
                        }
                        Text { text: "strokeColor" }
                        ComboBox {
                            Layout.fillWidth: true
                            model: ["gray", "steelblue", "red", "green", "blue", "black", "white", "transparent"]
                            currentIndex: 0
                            onActivated: baseArc.strokeColor = currentText
                        }
                        Text { text: "strokeStyle" }
                        ComboBox {
                            Layout.fillWidth: true
                            model: ["SolidLine", "DashLine"]
                            currentIndex: 0
                            onActivated: baseArc.strokeStyle = (currentIndex === 0 ? 1 : 2)
                        }
                        Text { text: "capStyle" }
                        ComboBox {
                            Layout.fillWidth: true
                            model: ["FlatCap", "SquareCap", "RoundCap"]
                            currentIndex: 0
                            onActivated: {
                                var v = [0, 16, 32]
                                baseArc.capStyle = v[currentIndex]
                            }
                        }
                        Item { Layout.preferredHeight: 4 }
                    }

                    // ── カテゴリ: 塗り ──────────────────────────────────
                    SubHeader {
                        id: hdrFill
                        title: "塗り"
                        onToggled: (open) => bodyFill.visible = open
                    }
                    ColumnLayout {
                        id: bodyFill
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        spacing: 2
                        Text { text: "fillColor" }
                        ComboBox {
                            Layout.fillWidth: true
                            model: ["transparent", "lightgray", "lightblue", "lightyellow", "white"]
                            currentIndex: 0
                            onActivated: baseArc.fillColor = currentText
                        }
                        Item { Layout.preferredHeight: 4 }
                    }

                    // ── カテゴリ: アウトライン弧 ────────────────────────
                    SubHeader {
                        id: hdrOutline
                        title: "アウトライン弧"
                        onToggled: (open) => bodyOutline.visible = open
                    }
                    ColumnLayout {
                        id: bodyOutline
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        spacing: 2
                        CheckBox {
                            text: "outlineArc"
                            checked: false
                            onToggled: baseArc.outlineArc = checked
                        }
                        Text { text: "arcWidth: " + baseArc.arcWidth.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 1; to: 200; value: 10; stepSize: 1
                            onMoved: baseArc.arcWidth = value
                        }
                        CheckBox {
                            text: "round (両端)"
                            checked: false
                            onToggled: baseArc.round = checked
                        }
                        CheckBox {
                            text: "roundBegin"
                            checked: false
                            onToggled: baseArc.roundBegin = checked
                        }
                        CheckBox {
                            text: "roundEnd"
                            checked: false
                            onToggled: baseArc.roundEnd = checked
                        }
                        Item { Layout.preferredHeight: 4 }
                    }

                    // ── カテゴリ: サイズ・配置 ──────────────────────────
                    SubHeader {
                        id: hdrArcSize
                        title: "サイズ・配置"
                        onToggled: (open) => bodyArcSize.visible = open
                    }
                    ColumnLayout {
                        id: bodyArcSize
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        spacing: 2
                        Text { text: "弧の直径: " + baseArc.height.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 100; to: 800; value: 480; stepSize: 1
                            onMoved: baseArc.height = value
                        }
                        Text { text: "rightMargin: " + baseArc.anchors.rightMargin.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: -200; to: 0; value: -50; stepSize: 1
                            onMoved: baseArc.anchors.rightMargin = value
                        }
                        CheckBox {
                            text: "antialiasing"
                            checked: false
                            onToggled: baseArc.antialiasing = checked
                        }
                        Item { Layout.preferredHeight: 4 }
                    }
                }

                // ═══════════════════════════════════════════════════════
                // コンポーネント: rect
                // ═══════════════════════════════════════════════════════
                SectionHeader {
                    id: hdrRect
                    title: "rect"
                    onToggled: (open) => bodyRect.visible = open
                }
                ColumnLayout {
                    id: bodyRect
                    Layout.fillWidth: true
                    spacing: 0

                    SubHeader {
                        id: hdrRectSize
                        title: "サイズ・クリップ"
                        onToggled: (open) => bodyRectSize.visible = open
                    }
                    ColumnLayout {
                        id: bodyRectSize
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        spacing: 2
                        Text { text: "width: " + rect.width.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 10; to: 400; value: 100; stepSize: 1
                            onMoved: rect.width = value
                        }
                        Text { text: "height: " + rect.height.toFixed(0) }
                        Slider {
                            Layout.fillWidth: true
                            from: 10; to: 600; value: 240; stepSize: 1
                            onMoved: rect.height = value
                        }
                        CheckBox {
                            text: "clip"
                            checked: false
                            onToggled: rect.clip = checked
                        }
                        Item { Layout.preferredHeight: 4 }
                    }
                }

                Item { Layout.preferredHeight: 10 }
            }
        }
    }

    // ─── ゲージエリア（右） ───────────────────────────────────────────────
    Item {
        id: gaugeArea
        anchors.left: panel.right
        anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom

        Rectangle {
            id: rect
            width: 100
            height: 240
            anchors.centerIn: parent
            clip: false
            color: "#88ffff00"

            ArcItem {
                id: baseArc
                width:  height
                height: 480
                begin: 0
                end: 180
                strokeColor: "gray"
                strokeWidth: 50
                fillColor:   "transparent"

                anchors.right: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: -50
            }
        }

        Rectangle {
            id: cover
            anchors.fill: rect
            color: "#88ffff00"
        }

        Button {
            text: "Print params"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 8
            onClicked: {
                console.log("=== Current Parameters ===")
                console.log("baseArc.begin      :", baseArc.begin)
                console.log("baseArc.end        :", baseArc.end)
                console.log("baseArc.strokeWidth:", baseArc.strokeWidth)
                console.log("baseArc.strokeColor:", baseArc.strokeColor)
                console.log("baseArc.strokeStyle:", baseArc.strokeStyle)
                console.log("baseArc.capStyle   :", baseArc.capStyle)
                console.log("baseArc.fillColor  :", baseArc.fillColor)
                console.log("baseArc.outlineArc :", baseArc.outlineArc)
                console.log("baseArc.arcWidth   :", baseArc.arcWidth)
                console.log("baseArc.round      :", baseArc.round)
                console.log("baseArc.roundBegin :", baseArc.roundBegin)
                console.log("baseArc.roundEnd   :", baseArc.roundEnd)
                console.log("baseArc.height     :", baseArc.height)
                console.log("baseArc.anchors.rightMargin:", baseArc.anchors.rightMargin)
                console.log("baseArc.antialiasing:", baseArc.antialiasing)
                console.log("rect.width         :", rect.width)
                console.log("rect.height        :", rect.height)
                console.log("rect.clip          :", rect.clip)
                console.log("=========================")
            }
        }
    }
}
