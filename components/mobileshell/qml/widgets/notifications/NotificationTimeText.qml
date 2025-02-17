/*
 * SPDX-FileCopyrightText: 2021 Devin Lin <devin@kde.org>
 * SPDX-FileCopyrightText: 2018-2019 Kai Uwe Broulik <kde@privat.broulik.de>
 * 
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick 2.8
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.notificationmanager 1.0 as NotificationManager

import org.kde.kcoreaddons 1.0 as KCoreAddons

import "util.js" as Util

PlasmaComponents.Label {
    id: ageLabel
    
    property int notificationType: model.type
    property int jobState
    property QtObject jobDetails
    
    property var time
    property P5Support.DataSource timeSource
    
    // notification created/updated time changed
    onTimeChanged: updateAgoText()
    
    Connections {
        target: timeSource
        // clock time changed
        function onDataChanged() {
            ageLabel.updateAgoText()
        }
    }
    
    Component.onCompleted: updateAgoText()
    
    function updateAgoText() {
        ageLabel.agoText = Util.generateNotificationHeaderAgoText(time, jobState);
    }
    
    font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 0.8

    // the "n minutes ago" text, for jobs we show remaining time instead
    // updated periodically by a Timer hence this property with generate() function
    property string agoText: ""
    visible: text !== ""
    opacity: 0.6
    text: Util.generateNotificationHeaderRemainingText(notificationType, jobState, jobDetails) || agoText
}
