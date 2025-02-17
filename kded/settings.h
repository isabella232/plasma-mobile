// SPDX-FileCopyrightText: 2023 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#include <QObject>

#include <KConfigGroup>
#include <KSharedConfig>

class Settings : public QObject
{
    Q_OBJECT

public:
    Settings(QObject *parent = nullptr);
    static Settings *self();

    // whether the initial start wizard should be started
    bool shouldStartWizard();

    // set that the wizard has finished
    void setWizardFinished();

    // apply the configuration
    void applyConfiguration();

private:
    // loads the saved configuration, so it can be restored on desktop
    void loadSavedConfiguration();

    // applies our mobile configuration
    void applyMobileConfiguration();

    void writeKeys(const QString &fileName, KSharedConfig::Ptr &config, const QMap<QString, QMap<QString, QVariant>> &settings, bool overwriteOnlyIfEmpty);
    void loadKeys(const QString &fileName, KSharedConfig::Ptr &config, const QMap<QString, QMap<QString, QVariant>> &settings);
    void saveConfigSetting(const QString &fileName, const QString &group, const QString &key, const QVariant value);
    void loadSavedConfigSetting(KSharedConfig::Ptr &config, const QString &fileName, const QString &group, const QString &key);

    void reloadKWinConfig();

    // whether this is Plasma Mobile
    bool m_isMobilePlatform;

    KSharedConfig::Ptr m_initialStartConfig;
    KSharedConfig::Ptr m_kwinrcConfig;
    KSharedConfig::Ptr m_appBlacklistConfig;
    KSharedConfig::Ptr m_kdeglobalsConfig;
};
