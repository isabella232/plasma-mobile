/*
 * SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>
 * 
 * SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import Qt5Compat.GraphicalEffects

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.private.mobileshell 1.0 as MobileShell

import org.kde.kquickcontrolsaddons 2.0 as KQCAddons

MouseArea {
    id: thumbnailArea

    // The protocol supports multiple URLs but so far it's only used to show
    // a single preview image, so this code is simplified a lot to accommodate
    // this usecase and drops everything else (fallback to app icon or ListView
    // for multiple files)
    property var urls

    readonly property alias menuOpen: fileMenu.visible

    property int _pressX: -1
    property int _pressY: -1

    property int leftPadding: 0
    property int rightPadding: 0
    property int topPadding: 0
    property int bottomPadding: 0

    signal openUrl(string url)
    signal fileActionInvoked(QtObject action)

    implicitHeight: Math.max(menuButton.height + 2 * menuButton.anchors.topMargin,
                             Math.round(Math.min(width / 3, width / thumbnailer.ratio)))
                    + topPadding + bottomPadding

    MobileShell.NotificationFileMenu {
        id: fileMenu
        url: thumbnailer.url
        visualParent: menuButton
        onActionTriggered: thumbnailArea.fileActionInvoked(action)
    }

    MobileShell.NotificationThumbnailer {
        id: thumbnailer

        readonly property real ratio: pixmapSize.height ? pixmapSize.width / pixmapSize.height : 1

        url: urls[0]
        // height is dynamic, so request a "square" size and then show it fitting to aspect ratio
        size: Qt.size(thumbnailArea.width, thumbnailArea.width)
    }

    KQCAddons.QPixmapItem {
        id: previewBackground
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        opacity: 0.25
        pixmap: thumbnailer.pixmap
        layer.effect: FastBlur {
            source: previewBackground
            anchors.fill: parent
            radius: 30
        }
    }

    Item {
        anchors {
            fill: parent
            leftMargin: thumbnailArea.leftPadding
            rightMargin: thumbnailArea.rightPadding
            topMargin: thumbnailArea.topPadding
            bottomMargin: thumbnailArea.bottomPadding
        }

        KQCAddons.QPixmapItem {
            id: previewPixmap
            anchors.fill: parent
            pixmap: thumbnailer.pixmap
            smooth: true
            fillMode: Image.PreserveAspectFit
        }

        PlasmaCore.IconItem {
            anchors.centerIn: parent
            width: height
            height: PlasmaCore.Units.roundToIconSize(parent.height)
            usesPlasmaTheme: false
            source: !thumbnailer.busy && !thumbnailer.hasPreview ? thumbnailer.iconName : ""
        }

        PlasmaComponents3.BusyIndicator {
            anchors.centerIn: parent
            running: thumbnailer.busy
            visible: thumbnailer.busy
        }

        PlasmaComponents3.Button {
            id: menuButton
            anchors {
                top: parent.top
                right: parent.right
                margins: PlasmaCore.Units.smallSpacing
            }
            Accessible.name: tooltip.text
            icon.name: "application-menu"
            checkable: true

            onPressedChanged: {
                if (pressed) {
                    // fake "pressed" while menu is open
                    checked = Qt.binding(function() {
                        return fileMenu.visible;
                    });

                    fileMenu.visualParent = this;
                    // -1 tells it to "align bottom left of visualParent (this)"
                    fileMenu.open(-1, -1);
                }
            }

            PlasmaComponents3.ToolTip {
                id: tooltip
                text: i18n("More Options…")
            }
        }
    }
}
