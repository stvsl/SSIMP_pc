#include "taskservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/nget.h"
#include "Utils/npost.h"
#include "Daemon/global.h"
#include <QJsonArray>
#include "Service/tasksetservice.h"

TaskService::TaskService(QObject *parent)
    : QObject{parent}
{
}

void TaskService::getTaskListByEid(QString eid)
{
    TcpPost *post = new TcpPost("/api/task/employertasklist", this);
    post->addParam("eid", eid);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "获取员工任务列表失败" << resp["code"].toString();
        }
        else
        {
            QString datastr = resp["data"].toString();
            QJsonDocument dataDoc = QJsonDocument::fromJson(datastr.toUtf8());
            QJsonArray data = dataDoc.array();
            tasksetList->clear();
            for (int i = 0; i < data.size(); i++)
            {
                QJsonObject obj = data[i].toObject();
                int tid = obj["tid"].toInt();
                TaskSetData* tsdata = TaskSetService::getTaskSetListByTid(tid);
                tasksetList->append(tsdata);
            }
            emit employeeTaskListChanged(QQmlListProperty<TaskSetData>(this, tasksetList));
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void TaskService::addTask(QString eid, int tid)
{
}

void TaskService::deleteTask(QString eid, int tid)
{
}

QList<TaskSetData *> *TaskService::tasksetList = new QList<TaskSetData *>();

// Path: Service/taskservice.h
