#ifndef EMPLOYEESERVICE_H
#define EMPLOYEESERVICE_H

#include <QObject>

class EmployeeService : public QObject
{
    Q_OBJECT
public:
    explicit EmployeeService(QObject *parent = nullptr);
    Q_INVOKABLE void getEmployeeInfoList();
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

#endif // EMPLOYEESERVICE_H
