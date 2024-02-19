#ifndef EMPLOYEESERVICE_H
#define EMPLOYEESERVICE_H

#include <QObject>
#include <QQmlListProperty>
#include "ModeData/employeedata.h"

class EmployeeService : public QObject
{
    Q_OBJECT
public:
    explicit EmployeeService(QObject *parent = nullptr);
    Q_INVOKABLE void getEmployeeInfoList();
    Q_INVOKABLE QQmlListProperty<EmployeeData> employees();

    Q_INVOKABLE void addEmployee(QString employid, QString name, QString birthDate,
                                 QString hireDate, QString idNumber,
                                 QString address, QString imageUrl,
                                 QString photoUrl, QString tel);
    Q_INVOKABLE void deleteEmployee(QString id);
    Q_INVOKABLE void deleteAllEmployee();
    Q_INVOKABLE void updateEmployee(QString employid, QString name, QString birthDate,
                                    QString hireDate, QString idNumber,
                                    QString address, QString imageUrl,
                                    QString photoUrl, QString tel);
    Q_INVOKABLE void queryEmployee(QString id);

signals:
    void addEmployeeSuccess();
    void addEmployeeFailed();
    void deleteEmployeeSuccess();
    void deleteEmployeeFailed();
    void updateEmployeeSuccess();
    void updateEmployeeFailed();
    void queryEmployeeSuccess();
    void queryEmployeeFailed();
    void employeeInfoListChanged();

private:
    static QList<EmployeeData *> *m_employees;
};

#endif // EMPLOYEESERVICE_H
