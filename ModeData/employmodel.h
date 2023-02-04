#ifndef EMPLOYMODEL_H
#define EMPLOYMODEL_H

#include <ModeData/employeedata.h>
#include <QQmlListProperty>
#include <QObject>

class EmployeeModel : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QQmlListProperty<EmployeeData> employees READ employees NOTIFY employeesChanged)

public:
  explicit EmployeeModel(QObject *parent = nullptr);
  QQmlListProperty<EmployeeData> employees();

signals:
  void employeesChanged();

private:
  QList<EmployeeData *> *m_employees = nullptr;
};
#endif
