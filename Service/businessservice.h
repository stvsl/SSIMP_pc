#ifndef BUSINESSSERVICE_H
#define BUSINESSSERVICE_H

#include <QObject>

class AccountService : public QObject
{
    Q_OBJECT
public:
    explicit AccountService(QObject *parent = nullptr);
    Q_INVOKABLE void login(const QString &id, const QString &password);
    Q_INVOKABLE QString regist(QString id, QString password);
signals:

    // QML中使用
    void loginSuccess();
    void loginFailed();
    void registerSuccess();
    void registerFailed();
};

class EmployeeService : public QObject
{
    Q_OBJECT
public:
    explicit EmployeeService(QObject *parent = nullptr);
    Q_INVOKABLE void addEmployee();
    Q_INVOKABLE void deleteEmployee(QString name);
    Q_INVOKABLE void updateEmployee(QString name, QString password);
    Q_INVOKABLE void queryEmployee(QString name);
    Q_INVOKABLE void queryEmployStatus();
signals:
    void addEmployeeSuccess();
    void addEmployeeFailed();
    void deleteEmployeeSuccess();
    void deleteEmployeeFailed();
    void updateEmployeeSuccess();
    void updateEmployeeFailed();
    void queryEmployeeSuccess();
    void queryEmployeeFailed();
};

#endif // BUSINESSSERVICE_H
