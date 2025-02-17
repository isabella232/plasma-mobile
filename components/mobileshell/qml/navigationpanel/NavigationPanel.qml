/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *  SPDX-FileCopyrightText: 2021 Devin Lin <devin@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import Qt5Compat.GraphicalEffects

import org.kde.taskmanager 0.1 as TaskManager
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0

import org.kde.plasma.private.mobileshell.state 1.0 as MobileShellState

import "../components" as Components

Item {
    id: root
    
    property bool shadow: false
    property color backgroundColor
    property var foregroundColorGroup
    
    property NavigationPanelAction leftAction
    property NavigationPanelAction middleAction
    property NavigationPanelAction rightAction
    
    property NavigationPanelAction leftCornerAction
    property NavigationPanelAction rightCornerAction
    
    DropShadow {
        anchors.fill: root
        visible: shadow
        cached: true
        horizontalOffset: 0
        verticalOffset: 1
        radius: 4.0
        samples: 17
        color: Qt.rgba(0,0,0,0.8)
        source: icons
    }
        
    Item {
        id: icons
        anchors.fill: parent

        property real buttonLength: 0

        // background colour
        Rectangle {
            anchors.fill: parent
            color: root.backgroundColor
        }

        // button row (anchors provided by state)
        NavigationPanelButton {
            id: leftButton
            visible: root.leftAction.visible
            colorGroup: root.foregroundColorGroup
            enabled: root.leftAction.enabled
            iconSizeFactor: root.leftAction.iconSizeFactor
            iconSource: root.leftAction.iconSource
            onClicked: {
                if (enabled) {
                    root.leftAction.triggered();
                }
            }
        }

        NavigationPanelButton {
            id: middleButton
            anchors.centerIn: parent
            visible: root.middleAction.visible
            colorGroup: root.foregroundColorGroup
            enabled: root.middleAction.enabled
            iconSizeFactor: root.middleAction.iconSizeFactor
            iconSource: root.middleAction.iconSource
            onClicked: {
                if (enabled) {
                    root.middleAction.triggered();
                }
            }
        }

        NavigationPanelButton {
            id: rightButton
            visible: root.rightAction.visible
            colorGroup: root.foregroundColorGroup
            enabled: root.rightAction.enabled
            iconSizeFactor: root.rightAction.iconSizeFactor
            iconSource: root.rightAction.iconSource
            onClicked: {
                if (enabled) {
                    root.rightAction.triggered();
                }
            }
        }

        NavigationPanelButton {
            id: rightCornerButton
            visible: root.rightCornerAction.visible
            colorGroup: root.foregroundColorGroup
            enabled: root.rightCornerAction.enabled
            iconSizeFactor: root.rightCornerAction.iconSizeFactor
            iconSource: root.rightCornerAction.iconSource
            onClicked: {
                if (enabled) {
                    root.rightCornerAction.triggered();
                }
            }
        }
    }

    states: [
        State {
            name: "landscape"
            when: root.width < root.height
            PropertyChanges {
                target: icons
                buttonLength: Math.min(PlasmaCore.Units.gridUnit * 10, icons.height * 0.7 / 3)
            }
            AnchorChanges {
                target: leftButton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: middleButton.bottom
                }
            }
            PropertyChanges {
                target: leftButton
                width: parent.width
                height: icons.buttonLength
            }
            PropertyChanges {
                target: middleButton
                width: parent.width
                height: icons.buttonLength
            }
            AnchorChanges {
                target: rightButton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: middleButton.top
                }
            }
            PropertyChanges {
                target: rightButton
                height: icons.buttonLength
                width: icons.width
            }
            AnchorChanges {
                target: rightCornerButton
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                }
            }
            PropertyChanges {
                target: rightCornerButton
                height: PlasmaCore.Units.gridUnit * 2
                width: icons.width
            }
        }, State {
            name: "portrait"
            when: root.width >= root.height
            PropertyChanges {
                target: icons
                buttonLength: Math.min(PlasmaCore.Units.gridUnit * 8, icons.width * 0.7 / 3)
            }
            AnchorChanges {
                target: leftButton
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: middleButton.left
                }
            }
            PropertyChanges {
                target: leftButton
                height: parent.height
                width: icons.buttonLength
            }
            PropertyChanges {
                target: middleButton
                height: parent.height
                width: icons.buttonLength
            }
            AnchorChanges {
                target: rightButton
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: middleButton.right
                }
            }
            PropertyChanges {
                target: rightButton
                height: parent.height
                width: icons.buttonLength
            }
            AnchorChanges {
                target: rightCornerButton
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
            }
            PropertyChanges {
                target: rightCornerButton
                height: parent.height
                width: PlasmaCore.Units.gridUnit * 2
            }
        }
    ]
}
