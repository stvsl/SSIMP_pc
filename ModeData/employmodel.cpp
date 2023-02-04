#include "employmodel.h"

EmployeeModel::EmployeeModel(QObject *parent)
    : QObject(parent)
{
    EmployeeModel::m_employees = new QList<EmployeeData *>();
    m_employees->append(new EmployeeData(1, "John Smith", "1980-01-01", "2010-01-01", "123456789", "123 Main Street", "https://www.w3schools.com/howto/img_avatar.png", "https://www.w3schools.com/howto/img_avatar.png", this));
    m_employees->append(new EmployeeData(2, "Jane Doe", "1980-01-01", "2010-01-01", "123456789", "123 Main Street", "https://www.w3schools.com/howto/img_avatar.png", "https://www.w3schools.com/howto/img_avatar.png", this));
    m_employees->append(new EmployeeData(3, "John Smith", "1980-01-01", "2010-01-01", "123456789", "123 Main Street", "https://www.w3schools.com/howto/img_avatar.png", "https://www.w3schools.com/howto/img_avatar.png", this));
    m_employees->append(new EmployeeData(4, "Jane Doe", "1980-01-01", "2010-01-01", "123456789", "123 Main Street", "https://www.w3schools.com/howto/img_avatar.png", "https://www.w3schools.com/howto/img_avatar.png", this));
    m_employees->append(new EmployeeData(5, "John Smith", "1980-01-01", "2010-01-01", "123456789", "123 Main Street", "https://www.w3schools.com/howto/img_avatar.png", "https://www.w3schools.com/howto/img_avatar.png", this));
    m_employees->append(new EmployeeData(6, "Jane Doe", "1980-01-01", "2010-01-01", "123456789", "123 Main Street", "https://www.w3schools.com/howto/img_avatar.png", "https://www.w3schools.com/howto/img_avatar.png", this));
}

QQmlListProperty<EmployeeData> EmployeeModel::employees()
{
    return QQmlListProperty<EmployeeData>(this, m_employees);
}

// Path: ModeData/employmodel.h