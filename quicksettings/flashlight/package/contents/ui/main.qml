// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15

import org.kde.plasma.quicksetting.flashlight 1.0
import org.kde.plasma.private.mobileshell 1.0 as MobileShell
import org.kde.plasma.private.mobileshell.quicksettingsplugin as QS

QS.QuickSetting {
    text: i18n("Flashlight")
    icon: "flashlight-on"
    enabled: FlashlightUtil.torchEnabled
    available: FlashlightUtil.available
    function toggle() {
        FlashlightUtil.toggleTorch()
    }
}
