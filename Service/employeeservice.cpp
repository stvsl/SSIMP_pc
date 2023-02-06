#include "employeeservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "Security/encryption.h"
#include <QJsonArray>
QList<EmployeeData *> *EmployeeService::m_employees = new QList<EmployeeData *>();

EmployeeService::EmployeeService(QObject *parent)
    : QObject{parent}
{
}

void EmployeeService::getEmployeeInfoList()
{
    TcpPost *post = new TcpPost("/api/account/employee/list", this);
    post->setHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    QObject::connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
                     {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                         if(resp["code"] != "SE200"){
                           qDebug() << "获取员工信息列表失败" << resp["code"].toString();
                         } 
                         else {
                            qDebug() << "获取员工信息列表成功";
                            // 解析
                            QString datastr = resp["data"].toString();
                            QJsonDocument data = QJsonDocument::fromJson(datastr.toUtf8());
                            QJsonArray array = data.array();
                            for (int i = 0; i < array.size(); i++) {
                                QJsonObject obj = array.at(i).toObject();
                                QString employid = obj["employid"].toString();
                                QString name = obj["name"].toString();
                                QString idcard = obj["idcard"].isString() ? obj["idcard"].toString() : QString::number(obj["idcard"].toVariant().toLongLong());
                                QString telephone = obj["telephone"].isString() ? obj["telephone"].toString() : QString::number(obj["telephone"].toVariant().toLongLong());
                                QString tel = obj["tel"].isString() ? obj["telephone"].toString() : QString::number(obj["telephone"].toVariant().toLongLong());
                                QString address = obj["address"].toString();
                                QString avatar = obj["avatar"].toString();
                                QString passwd = obj["passwd"].toString();
                                QString hireDay = obj["employDay"].toString();
                                QString birthday = obj["birthDay"].toString();
                                QString bustPhoto = obj["bustPhoto"].toString();
                                EmployeeData employeedata;
                                addEmployee(employid,name,birthday,hireDay,idcard,address,avatar,bustPhoto,tel);
                             
                            }
                         } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}
QQmlListProperty<EmployeeData> EmployeeService::employees()
{
    return QQmlListProperty<EmployeeData>(this, m_employees);
}

void EmployeeService::addEmployee(QString employid, QString name, QString birthDate, QString hireDate,
                                  QString idNumber, QString address, QString imageUrl, QString photoUrl, QString tel)
{
    EmployeeData *employee = new EmployeeData(employid, name, birthDate, hireDate,
                                              idNumber,
                                              address, imageUrl, photoUrl, tel);
    m_employees->append(employee);
    emit addEmployeeSuccess();
    emit employeeInfoListChanged();
}

void EmployeeService::deleteEmployee(QString idNumber)
{
    for (int i = 0; i < m_employees->size(); i++)
    {
        if (m_employees->at(i)->idNumber() == idNumber)
        {
            m_employees->removeAt(i);
            emit deleteEmployeeSuccess();
            emit employeeInfoListChanged();
            return;
        }
    }
    emit deleteEmployeeFailed();
}

void EmployeeService::updateEmployee(QString employid, QString name, QString birthDate, QString hireDate,
                                     QString idNumber, QString address, QString imageUrl, QString photoUrl, QString tel)
{
    for (int i = 0; i < m_employees->size(); i++)
    {
        if (m_employees->at(i)->employid() == employid)
        {
            m_employees->at(i)->name() = name;
            m_employees->at(i)->birthDate() = birthDate;
            m_employees->at(i)->hireDate() = hireDate;
            m_employees->at(i)->idNumber() = idNumber;
            m_employees->at(i)->address() = address;
            m_employees->at(i)->imageUrl() = imageUrl;
            m_employees->at(i)->photoUrl() = photoUrl;
            emit updateEmployeeSuccess();
            emit employeeInfoListChanged();
            return;
        }
    }
    emit updateEmployeeFailed();
}

void EmployeeService::queryEmployee(QString employid)
{
    for (int i = 0; i < m_employees->size(); i++)
    {
        if (m_employees->at(i)->employid() == employid)
        {
            emit queryEmployeeSuccess();
            return;
        }
    }
    emit queryEmployeeFailed();
    return;
}
// Path: Service/employeeservice.h