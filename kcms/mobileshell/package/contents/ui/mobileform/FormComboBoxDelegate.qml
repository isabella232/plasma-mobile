/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

AbstractFormDelegate {
    id: root
    
    property string text: ""
    property string description: ""
    
    // TODO
    property string currentValue: ""
    property alias dialogDelegate: repeater.delegate
    property alias model: repeater.model
    
    Layout.fillWidth: true
    
    onClicked: dialog.open()
    
    Kirigami.Dialog {
        id: dialog
        showCloseButton: false
        title: root.text
        
        ColumnLayout {
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.View
            spacing: 0
            
            Repeater {
                id: repeater
            }
        }
    }
    
    contentItem: RowLayout {
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            
            Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
            }
            
            Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
            }
        }
        
        Label {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: Kirigami.Units.smallSpacing
            color: Kirigami.Theme.disabledTextColor
            text: root.currentValue
        }
        
        Kirigami.Icon {
            Layout.alignment: Qt.AlignRight
            source: "arrow-down"
            implicitWidth: Kirigami.Units.iconSizes.small
            implicitHeight: Kirigami.Units.iconSizes.small
        }
    }
}

