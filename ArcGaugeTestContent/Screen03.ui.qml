/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import ArcGaugeTest

Rectangle {
    id: root
    width: Constants.width
    height: Constants.height

    color: Constants.backgroundColor

    property int currentValue: 75    // ゲージ表示値 0 ～ 100%
    property int highValue: 80         // 上限マーカー用スライダー値
    property int lowValue: 20          // 下限マーカー用スライダー値
    property real clipWidth:  100       // baseClipArea の幅
    property real clipHeight: 250       // baseClipArea の高さ
    property real arcBegin: 60          // ArcItem begin（arcEnd = 180-arcBegin で対称）
    readonly property real arcEnd: 180 - arcBegin  // ArcItem end（beginと対称）
    property real arcStrokeWidth: 50   // ArcItem strokeWidth

    // 導出ジオメトリ (sortedBegin = min(begin,end) として計算)
    readonly property real _theta: Math.min(arcBegin, arcEnd) * Math.PI / 180
    readonly property real _innerR: (clipHeight / 2) / Math.cos(_theta)
    readonly property real _arcH: 2 * (_innerR + arcStrokeWidth)
    // leftEnd = (clipWidth - sw - innerR*(1-sin(theta))) / 2 >= 0 より
    readonly property real _minClipWidth: Math.ceil(arcStrokeWidth + _innerR * (1 - Math.sin(_theta)))
    // スライダー調整でclipWidthが不足する場合は自動拡張
    readonly property real _effectiveClipWidth: Math.max(clipWidth, _minClipWidth)
    // rightMargin: 弧の水平スパン中心が _effectiveClipWidth/2 になる条件から導出
    readonly property real _arcRightMargin: (_effectiveClipWidth - arcStrokeWidth) / 2 + _innerR * (Math.sin(_theta) - 1) / 2
    // 内円中心の baseClipArea 内 x 座標
    readonly property real _innerCircleCx: _effectiveClipWidth - _arcRightMargin - _arcH / 2
    // highArrow の y に対応する内円との dy (baseClipArea 垂直中心からのオフセット)
    readonly property real _highArrowDy: clipHeight * (0.5 - highValue / 100)
    // lowArrow の y に対応する外円との dy (baseClipArea 垂直中心からのオフセット)
    readonly property real _outerR: _innerR + arcStrokeWidth
    readonly property real _lowArrowDy: clipHeight * (0.5 - lowValue / 100)

    // ゲージ 0%/100% の y座標 (baseClipArea 座標系、上が小さい)
    // 内円中心は baseClipArea 垂直中心 (clipHeight/2) にあるので:
    //   y = clipHeight/2 - innerR * cos(angle_rad)
    readonly property real _y0:   clipHeight / 2 - _innerR * Math.cos(arcBegin * Math.PI / 180)
    readonly property real _y100: clipHeight / 2 - _innerR * Math.cos(arcEnd   * Math.PI / 180)

    // PathAngleArc 角度変換ヘルパー
    // ArcItem: 0°=上(12時), CW
    // PathAngleArc: 0°=右(3時), CW
    // → PathAngleArc startAngle = ArcItem.begin - 90
    readonly property real _arcStartAngle: arcBegin - 90
    readonly property real _arcSweepAngle: arcEnd - arcBegin

    Column {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 16
        spacing: 8

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "currentValue: " + root.currentValue
                color: "#333333"
            }

            Slider {
                from: 0
                to: 100
                value: root.currentValue
                stepSize: 1
                onValueChanged: root.currentValue = value
            }
        }

        CheckBox {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "clip"
            checked: false
            onCheckedChanged: baseClipArea.clip = checked
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "width: " + root.clipWidth.toFixed(0)
                color: "#333333"
            }
            Slider {
                from: 50; to: 400
                value: root.clipWidth
                stepSize: 1
                onValueChanged: root.clipWidth = value
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "height: " + root.clipHeight.toFixed(0)
                color: "#333333"
            }
            Slider {
                from: 50; to: 400
                value: root.clipHeight
                stepSize: 1
                onValueChanged: root.clipHeight = value
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "begin/end: " + root.arcBegin.toFixed(0) + "/" + root.arcEnd.toFixed(0)
                color: "#333333"
            }
            Slider {
                from: 45; to: 75
                value: root.arcBegin
                stepSize: 1
                onValueChanged: root.arcBegin = value
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "strokeWidth: " + root.arcStrokeWidth.toFixed(0)
                color: "#333333"
            }
            Slider {
                from: 2; to: 150
                value: root.arcStrokeWidth
                stepSize: 1
                onValueChanged: root.arcStrokeWidth = value
            }
        }
    }

    Item {
        id: baseClipArea
        anchors.centerIn: parent
        width: root._effectiveClipWidth
        height: root.clipHeight

        // ---- borderShape (Screen02 の borderArc に相当) ----
        // Shape の strokeWidth は stroke centerline が pathの上に乗る。
        // ArcItem は外縁がバウンディングボックス端 → 半径 = height/2 - strokeWidth/2
        Shape {
            id: borderShape
            anchors.right: parent.right
            anchors.rightMargin: root._arcRightMargin
            anchors.verticalCenter: parent.verticalCenter
            width: root._arcH
            height: root._arcH

            ShapePath {
                strokeColor: "gray"
                strokeWidth: root.arcStrokeWidth
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap

                PathAngleArc {
                    centerX: root._arcH / 2
                    centerY: root._arcH / 2
                    radiusX: root._arcH / 2 - root.arcStrokeWidth / 2
                    radiusY: root._arcH / 2 - root.arcStrokeWidth / 2
                    startAngle: root._arcStartAngle
                    sweepAngle: root._arcSweepAngle
                }
            }
        }

        // ---- backgroundShape (Screen02 の backgroundArc に相当) ----
        Shape {
            id: backgroundShape
            anchors.centerIn: borderShape
            width: borderShape.width - 4
            height: borderShape.height - 4

            ShapePath {
                strokeColor: "lightgray"
                strokeWidth: root.arcStrokeWidth - 4
                fillColor: "transparent"
                capStyle: ShapePath.FlatCap

                PathAngleArc {
                    centerX: (root._arcH - 4) / 2
                    centerY: (root._arcH - 4) / 2
                    radiusX: (root._arcH - 4) / 2 - (root.arcStrokeWidth - 4) / 2
                    radiusY: (root._arcH - 4) / 2 - (root.arcStrokeWidth - 4) / 2
                    startAngle: root._arcStartAngle
                    sweepAngle: root._arcSweepAngle
                }
            }
        }

        Item {
            id: gaugeClipArea
            width: parent.width
            // arcEnd=180-arcBegin の対称構成では _y0=clipHeight, _y100=0 が常に成立するため単純式
            height: root.clipHeight * root.currentValue / 100
            anchors.bottom: parent.bottom
            clip: true

            // ---- gaugeShape (Screen02 の gaugeArc に相当) ----
            Shape {
                id: gaugeShape
                // backgroundShape と同じ絶対位置になるよう gaugeClipArea の座標オフセットを差し引く
                x: backgroundShape.x
                y: backgroundShape.y - gaugeClipArea.y
                width: backgroundShape.width
                height: backgroundShape.height

                ShapePath {
                    strokeColor: "#4a6fa5"
                    strokeWidth: root.arcStrokeWidth - 4
                    fillColor: "transparent"
                    capStyle: ShapePath.FlatCap

                    PathAngleArc {
                        centerX: (root._arcH - 4) / 2
                        centerY: (root._arcH - 4) / 2
                        radiusX: (root._arcH - 4) / 2 - (root.arcStrokeWidth - 4) / 2
                        radiusY: (root._arcH - 4) / 2 - (root.arcStrokeWidth - 4) / 2
                        startAngle: root._arcStartAngle
                        sweepAngle: root._arcSweepAngle
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "#88cccccc"
            border.width: 1
        }
    }

    Text {
        id: highArrow
        text: "\u25B6"
        color: "#e05050"
        // 右端を「highValue の y で内円と交差する x」の 4px 左に合わせる
        x: baseClipArea.x + root._innerCircleCx
           + Math.sqrt(Math.max(0, root._innerR * root._innerR - root._highArrowDy * root._highArrowDy))
           - width - 4
        // highValue=100→上端, highValue=0→下端
        y: baseClipArea.y + baseClipArea.height * (1 - root.highValue / 100) - height / 2
    }

    Slider {
        id: highSlider
        orientation: Qt.Vertical
        from: 0
        to: 100
        stepSize: 1
        value: root.highValue
        height: baseClipArea.height
        anchors.right: baseClipArea.left
        anchors.rightMargin: highArrow.width + 8
        anchors.verticalCenter: baseClipArea.verticalCenter
        onValueChanged: {
            root.highValue = value
            if (root.highValue <= root.lowValue)
                root.lowValue = root.highValue - 1
        }
    }

    Text {
        id: lowArrow
        text: "\u25C0"
        color: "#50a050"
        // 左端を「lowValue の y で外円と交差する x」の 4px 右に合わせる
        x: baseClipArea.x + root._innerCircleCx
           + Math.sqrt(Math.max(0, root._outerR * root._outerR - root._lowArrowDy * root._lowArrowDy))
           + 4
        // lowValue=100→上端, lowValue=0→下端
        y: baseClipArea.y + baseClipArea.height * (1 - root.lowValue / 100) - height / 2
    }

    Slider {
        id: lowSlider
        orientation: Qt.Vertical
        from: 0
        to: 100
        stepSize: 1
        value: root.lowValue
        height: baseClipArea.height
        anchors.left: baseClipArea.right
        anchors.leftMargin: lowArrow.width + 8
        anchors.verticalCenter: baseClipArea.verticalCenter
        onValueChanged: {
            root.lowValue = value
            if (root.lowValue >= root.highValue)
                root.highValue = root.lowValue + 1
        }
    }
}
