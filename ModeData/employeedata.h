#ifndef EMPLOYEE_H
#define EMPLOYEE_H

#include <QObject>

class EmployeeData : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString employid READ employid CONSTANT)
  Q_PROPERTY(QString name READ name CONSTANT)
  Q_PROPERTY(QString birthDate READ birthDate CONSTANT)
  Q_PROPERTY(QString hireDate READ hireDate CONSTANT)
  Q_PROPERTY(QString idNumber READ idNumber CONSTANT)
  Q_PROPERTY(QString address READ address CONSTANT)
  Q_PROPERTY(QString imageUrl READ imageUrl CONSTANT)
  Q_PROPERTY(QString photoUrl READ photoUrl CONSTANT)
  Q_PROPERTY(QString tel READ tel CONSTANT)

public:
  EmployeeData(QString &employid, const QString &name, const QString &birthDate,
               const QString &hireDate, const QString &idNumber,
               const QString &address, const QString &imageUrl,
               const QString &photoUrl, const QString &tel, QObject *parent = nullptr);
  explicit EmployeeData(QObject *parent = nullptr);

  QString employid() const;
  QString name() const;
  QString birthDate() const;
  QString hireDate() const;
  QString idNumber() const;
  QString address() const;
  QString imageUrl() const;
  QString photoUrl() const;
  QString tel() const;

private:
  QString m_id;
  QString m_name;
  QString m_birthDate;
  QString m_hireDate;
  QString m_idNumber;
  QString m_address;
  QString m_imageUrl;
  QString m_photoUrl;
  QString m_tel;
};

#endif
