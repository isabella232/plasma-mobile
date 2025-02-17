/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.4
import Qt5Compat.GraphicalEffects
import org.kde.plasma.core 2.0 as PlasmaCore
 
PlasmaCore.SvgItem {
    id: scrollIndicator
    
    anchors.verticalCenter: parent.verticalCenter

    z: 2
    opacity: 0
    svg: PlasmaCore.Svg {
        imagePath: "widgets/arrows"
        colorGroup: PlasmaCore.Theme.ComplementaryColorGroup
    }
    elementId: "left-arrow"
    width: PlasmaCore.Units.iconSizes.large
    height: width
    layer.enabled: true
    layer.effect: DropShadow {
        cached: true
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8.0
        samples: 16
        color: Qt.rgba(0, 0, 0, 0.8)
    }
    Behavior on opacity {
        OpacityAnimator {
            duration: PlasmaCore.Units.longDuration * 2
            easing.type: Easing.InOutQuad
        }
    }
}
