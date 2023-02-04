#include "employeedata.h"

EmployeeData::EmployeeData(int id, const QString &name, const QString &birthDate,
                           const QString &hireDate, const QString &idNumber,
                           const QString &address, const QString &imageUrl,
                           const QString &photoUrl, QObject *parent)
    : QObject(parent), m_id(id), m_name(name), m_birthDate(birthDate),
      m_hireDate(hireDate), m_idNumber(idNumber), m_address(address),
      m_imageUrl(imageUrl), m_photoUrl(photoUrl) {}

int EmployeeData::id() const { return m_id; }

QString EmployeeData::name() const { return m_name; }

QString EmployeeData::birthDate() const { return m_birthDate; }

QString EmployeeData::hireDate() const { return m_hireDate; }

QString EmployeeData::idNumber() const { return m_idNumber; }

QString EmployeeData::address() const { return m_address; }

QString EmployeeData::imageUrl() const { return m_imageUrl; }

QString EmployeeData::photoUrl() const { return m_photoUrl; }

// Path: ModeData/employeedata.h