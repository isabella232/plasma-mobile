/*
 * SPDX-FileCopyrightText: 2022 by Devin Lin <devin@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "screenrotationutil.h"

#include <fcntl.h>
#include <unistd.h>

#include <QDebug>

ScreenRotationUtil::ScreenRotationUtil(QObject *parent)
    : QObject{parent}
{
    m_kscreenInterface = new org::kde::KScreen(QStringLiteral("org.kde.kded5"), QStringLiteral("/modules/kscreen"), QDBusConnection::sessionBus(), this);
}

bool ScreenRotationUtil::screenRotation()
{
    QDBusPendingReply<bool> reply = m_kscreenInterface->getAutoRotate();
    reply.waitForFinished();
    if (reply.isError()) {
        qWarning() << "Getting auto rotate failed:" << reply.error().name() << reply.error().message();
        return false;
    } else {
        return reply.value();
    }
}

void ScreenRotationUtil::setScreenRotation(bool value)
{
    QDBusPendingReply<> reply = m_kscreenInterface->setAutoRotate(value);
    reply.waitForFinished();
    if (reply.isError()) {
        qWarning() << "Setting auto rotate failed:" << reply.error().name() << reply.error().message();
    } else {
        Q_EMIT screenRotationChanged(value);
    }
}

bool ScreenRotationUtil::isAvailable()
{
    QDBusPendingReply<bool> reply = m_kscreenInterface->isAutoRotateAvailable();
    reply.waitForFinished();
    if (reply.isError()) {
        qWarning() << "Getting available failed:" << reply.error().name() << reply.error().message();
        return false;
    } else {
        return reply.value();
    }
}
