#ifndef BUSINESSSERVICE_H
#define BUSINESSSERVICE_H

#include <QObject>

class AccountService : public QObject
{
    Q_OBJECT
public:
    explicit AccountService(QObject *parent = nullptr);
    Q_INVOKABLE QString Login(const QString &id, const QString &password);
    Q_INVOKABLE QString Register(QString id, QString password);
signals:
};

#endif // BUSINESSSERVICE_H
