// SPDX-FileCopyrightText: 2023 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick

import org.kde.plasma.core as PlasmaCore
import org.kde.taskmanager as TaskManager

pragma Singleton

// Helper component that uses Plasma's tasks model to provide whether a maximized window is showing on the current screen.

QtObject {
    readonly property bool showingWindow: __internal.count > 0

    property var __internal: PlasmaCore.SortFilterModel {
        id: visibleMaximizedWindowsModel
        filterRole: 'IsMinimized'
        filterRegExp: 'false'
        sourceModel: TaskManager.TasksModel {
            id: tasksModel
            filterByVirtualDesktop: true
            filterByActivity: true
            filterNotMaximized: true
            filterByScreen: true
            filterHidden: true

            virtualDesktop: virtualDesktopInfo.currentDesktop
            activity: activityInfo.currentActivity

            groupMode: TaskManager.TasksModel.GroupDisabled
        }

        property var vdi: TaskManager.VirtualDesktopInfo {
            id: virtualDesktopInfo
        }

        property var ai: TaskManager.ActivityInfo {
            id: activityInfo
        }
    }
}
