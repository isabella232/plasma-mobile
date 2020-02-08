/***************************************************************************
 *   Copyright (C) 2015 Marco Martin <mart@kde.org>                        *
 *   Copyright (C) 2018 Bhushan Shah <bshah@kde.org>                       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "phonepanel.h"

#include <QDateTime>
#include <QDBusPendingReply>
#include <QFile>
#include <QDebug>
#include <QStandardPaths>
#include <QProcess>
#include <QtConcurrent/QtConcurrent>

#include "screenshotinterface.h"

PhonePanel::PhonePanel(QObject *parent, const QVariantList &args)
    : Plasma::Containment(parent, args)
{
    //setHasConfigurationInterface(true);
}

PhonePanel::~PhonePanel()
= default;

void PhonePanel::executeCommand(const QString &command)
{
    qWarning()<<"Executing"<<command;
    QProcess::startDetached(command);
}

void PhonePanel::toggleTorch()
{
    if (!m_running) {
        gst_init(nullptr, nullptr);
        // create elements
        m_source = gst_element_factory_make("droidcamsrc", "source");
        m_sink = gst_element_factory_make("fakesink", "sink");
        m_pipeline = gst_pipeline_new("torch-pipeline");
        if (!m_pipeline || !m_source || !m_sink) {
            qDebug() << "Failed to turn on torch: failed to create elements";
            return;
        }
        gst_bin_add_many(GST_BIN(m_pipeline), m_source, m_sink, NULL);
        if (gst_element_link(m_source, m_sink) != TRUE) {
            qDebug() << "Failed to turn on torch: failed to link source and sink";
            g_object_unref(m_pipeline);
            return;
        }
        g_object_set(m_source, "mode", 2, NULL);
        g_object_set(m_source, "video-torch", TRUE, NULL);
        if (gst_element_set_state(m_pipeline, GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE) {
            qDebug() << "Failed to turn on torch: failed to start pipeline";
            g_object_unref(m_pipeline);
            return;
        }
        m_running = true;
    } else {
        gst_element_set_state(m_pipeline, GST_STATE_NULL);
        gst_object_unref(m_pipeline);
        m_running = false;
    }
}

void PhonePanel::takeScreenshot()
{
    // wait ~200 ms to wait for rest of animations
    QTimer::singleShot(200, [=]() {
        auto *interface = new org::kde::kwin::Screenshot(QStringLiteral("org.kde.KWin"), QStringLiteral("/Screenshot"), QDBusConnection::sessionBus(), this);

        // screenshot fullscreen currently doesn't work on all devices -> we need to use screenshot area
        // this won't work with multiple screens
        QSize screenSize = QGuiApplication::primaryScreen()->size();
        QDBusPendingReply<QString> reply = interface->screenshotArea(0, 0, screenSize.width(), screenSize.height());
        QDBusPendingCallWatcher *watcher = new QDBusPendingCallWatcher(reply, this);

        connect(watcher, &QDBusPendingCallWatcher::finished, this, [=](QDBusPendingCallWatcher *watcher) {
            QDBusPendingReply<QString> reply = *watcher;

            if (reply.isError()) {
                qWarning() << "Creating the screenshot failed:" << reply.error().name() << reply.error().message();
            } else {
                QString filePath = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
                if (filePath.isEmpty()) {
                    qWarning() << "Couldn't find a writable location for the screenshot! The screenshot is in /tmp.";
                    return;
                }

                QDir picturesDir(filePath);
                if (!picturesDir.mkpath(QStringLiteral("Screenshots"))) {
                    qWarning() << "Couldn't create folder at"
                            << picturesDir.path() + QStringLiteral("/Screenshots")
                            << "to take screenshot.";
                    return;
                }

                filePath += QStringLiteral("/Screenshots/Screenshot_%1.png")
                                .arg(QDateTime::currentDateTime().toString(QStringLiteral("yyyyMMdd_hhmmss")));

                const QString currentPath = reply.argumentAt<0>();
                QtConcurrent::run(QThreadPool::globalInstance(), [=]() {
                    QFile screenshotFile(currentPath);
                    if (!screenshotFile.rename(filePath)) {
                        qWarning() << "Couldn't move screenshot into Pictures folder:"
                                << screenshotFile.errorString();
                    }

                    qDebug() << "Successfully saved screenshot at" << filePath;
                });
            }

            watcher->deleteLater();
            interface->deleteLater();
        });
    });
}

K_EXPORT_PLASMA_APPLET_WITH_JSON(quicksettings, PhonePanel, "metadata.json")

#include "phonepanel.moc"
