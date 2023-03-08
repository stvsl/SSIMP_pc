#include "tasksetservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/nget.h"
#include "Utils/npost.h"
#include "QJsonArray"

TaskSetService::TaskSetService(QObject *parent)
    : QObject{parent}
{
}

void TaskSetService::getTaskSetList()
{
    TcpPost *post = new TcpPost("/api/taskset/list", this);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "获取文章列表失败" << resp["code"].toString();
        }
        else
        {
            QString datastr = resp["data"].toString();
            QJsonDocument dataDoc = QJsonDocument::fromJson(datastr.toUtf8());
            QJsonArray data = dataDoc.array();
#if TASKSET_DEBUG == 1
    qDebug() << "获取任务列表成功" << data.size();
#endif
            for (int i = 0; i < data.size(); i++)
            {
                QJsonObject obj = data[i].toObject();
                int tid = obj["tid"].toInt();
                QString name = obj["name"].toString();
                QString content = obj["content"].toString();
                QString area = obj["area"].toString();
                double poslo = obj["poslo"].toDouble();
                double posli = obj["posli"].toDouble();
                int cycle = obj["cycle"].toInt();
                int state = obj["state"].toInt();
                TaskSetData *taskset = new TaskSetData(tid, name, content, area, poslo, posli, cycle,state);
                m_tasksets->append(taskset);
            }
            for (int i = 0; i < m_tasksets->size(); i++)
            {
                qDebug() << m_tasksets->at(i);
            }
            emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, m_tasksets));
        } });
    net->sendRequest();
}

QQmlListProperty<TaskSetData> TaskSetService::tasksets()
{
    return QQmlListProperty<TaskSetData>(this, m_tasksets);
}

void TaskSetService::modifyTaskSet(QString tid, QString name, QString content, QString area, float poslo, float posli, int cycle)
{
    // 修改任务
}

void TaskSetService::deleteTaskSet(QString tid)
{
    // 删除任务
}

QVariant TaskSetService::getTaskSet(QString tid)
{
    for (int i = 0; i < m_tasksets->size(); i++)
    {
        if (m_tasksets->at(i)->tid() == tid.toInt())
        {
            return QVariant::fromValue(m_tasksets->at(i));
        }
    }
    return QVariant();
}

void TaskSetService::addTaskSet(QString name, QString content, QString area, float poslo, float posli, int cycle)
{
    // 添加任务
}

void TaskSetService::updateTaskSet(QString tid)
{
    // 更新任务
}

QList<TaskSetData *> *TaskSetService::m_tasksets = new QList<TaskSetData *>();

// Path: Service/tasksetservice.cpp
