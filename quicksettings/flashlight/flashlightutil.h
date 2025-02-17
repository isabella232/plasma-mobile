/*
 * SPDX-FileCopyrightText: 2022 by Devin Lin <devin@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#pragma once

#include <QObject>

class FlashlightUtil : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool torchEnabled READ torchEnabled NOTIFY torchChanged);
    Q_PROPERTY(bool available READ isAvailable CONSTANT);

public:
    FlashlightUtil(QObject *parent = nullptr);

    Q_INVOKABLE void toggleTorch();
    bool torchEnabled() const;
    bool isAvailable() const;

Q_SIGNALS:
    void torchChanged(bool value);

private:
    bool m_torchEnabled;
};
