#ifndef ACCOUNTSERVICE_H
#define ACCOUNTSERVICE_H

#include <QObject>

class AccountService : public QObject {
  Q_OBJECT
public:
  explicit AccountService(QObject *parent = nullptr);
  Q_INVOKABLE void login(const QString &id, const QString &password);
  Q_INVOKABLE QString regist(const QString id, const QString password);
signals:

  // QML中使用
  void loginSuccess();
  void loginFailed();
  void registerSuccess();
  void registerFailed();
};

#endif // ACCOUNTSERVICE_H
