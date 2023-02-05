#include "employeeservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "Security/encryption.h"

EmployeeService::EmployeeService(QObject *parent)
    : QObject{parent}
{
}

void EmployeeService::getEmployeeInfoList()
{
    TcpPost *post = new TcpPost("/api/account/employee/list", this);
    qDebug() << globalsecurity::TOKEN;
    post->setHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    QObject::connect(net, &TcpNetUtils::requestFinished, [=]()
                     {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                         if(resp["code"] != "SE200"){
                           qDebug() << "获取员工信息列表失败" << resp["code"].toString();
                         } 
                         else {
                            qDebug() << "获取员工信息列表成功";
                            qDebug() << resp["data"].toString();
                         } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void EmployeeService::addEmployee()
{
}

void EmployeeService::deleteEmployee(QString name)
{
}

void EmployeeService::updateEmployee(QString name, QString password)
{
}

void EmployeeService::queryEmployee(QString name)
{
}

void EmployeeService::queryEmployStatus()
{
}

// Path: Service/employeeservice.h