#include "employeedata.h"

EmployeeData::EmployeeData(QObject *parent)
    : QObject(parent)
{
}

EmployeeData::EmployeeData(QString &employid, const QString &name,
                           const QString &birthDate, const QString &hireDate,
                           const QString &idNumber, const QString &address,
                           const QString &imageUrl, const QString &photoUrl,
                           const QString &tel, QObject *parent)
    : QObject(parent),
      m_id(employid), m_name(name), m_birthDate(birthDate),
      m_hireDate(hireDate), m_idNumber(idNumber), m_address(address),
      m_imageUrl(imageUrl), m_photoUrl(photoUrl), m_tel(tel)
{
}

QString EmployeeData::employid() const { return m_id; }

QString EmployeeData::name() const { return m_name; }

QString EmployeeData::birthDate() const { return m_birthDate; }

QString EmployeeData::hireDate() const { return m_hireDate; }

QString EmployeeData::idNumber() const { return m_idNumber; }

QString EmployeeData::address() const { return m_address; }

QString EmployeeData::imageUrl() const { return m_imageUrl; }

QString EmployeeData::photoUrl() const { return m_photoUrl; }

QString EmployeeData::tel() const { return m_tel; }

void EmployeeData::UpdateEmployeeData(const QString &name, const QString &idNumber,
                                      const QString &address, const QString &imageUrl,
                                      const QString &photoUrl, const QString &tel)
{
  m_name = name;
  m_idNumber = idNumber;
  m_address = address;
  m_imageUrl = imageUrl;
  m_photoUrl = photoUrl;
  m_tel = tel;
}

//  Path: ModeData/employeedata.h
