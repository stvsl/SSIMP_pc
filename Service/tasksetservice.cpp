#include "tasksetservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/nget.h"
#include "Utils/npost.h"
#include "QJsonArray"
#include "Daemon/global.h"

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
            m_tasksets->clear();
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
                int duration = obj["duration"].toInt();
                TaskSetData *taskset = new TaskSetData(tid, name, content, area, poslo, posli, cycle,state, duration, this);
                m_tasksets->append(taskset);
            }
            qDebug() << "获取任务列表成功" << m_tasksets->size();
            emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, m_tasksets));
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

QQmlListProperty<TaskSetData> TaskSetService::tasksets()
{
    if (m_tasksets->size() == 0)
    {
        getTaskSetList();
    }
    emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, m_tasksets));
    return QQmlListProperty<TaskSetData>(this, m_tasksets);
}

QQmlListProperty<TaskSetData> TaskSetService::tasksets(QString keyname, float poslo, float posli)
{
    // 生成临时列表
    // 判断是否为空
    if (m_tasksets->size() == 0)
    {
        getTaskSetList();
    }
    QList<TaskSetData *> *temp = new QList<TaskSetData *>();
    // 查找名字不是keyname的,经纬度在半径0.02范围内的
    for (int i = 0; i < m_tasksets->size(); i++)
    {
        if (m_tasksets->at(i)->name() != keyname)
        {
            if (m_tasksets->at(i)->poslo() > poslo - 0.002 && m_tasksets->at(i)->poslo() < poslo + 0.002)
            {
                if (m_tasksets->at(i)->posli() > posli - 0.002 && m_tasksets->at(i)->posli() < posli + 0.002)
                {
                    temp->append(m_tasksets->at(i));
                }
            }
        }
    }
    emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, temp));
    return QQmlListProperty<TaskSetData>(this, temp);
}

void TaskSetService::searchTaskSet(QString keyname)
{
    // 生成临时列表
    // 判断是否为空
    if (m_tasksets->size() == 0)
    {
        getTaskSetList();
    }
    if (keyname == "")
    {
        emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, m_tasksets));
        return;
    }
    QList<TaskSetData *> *temp = new QList<TaskSetData *>();
    for (int i = 0; i < m_tasksets->size(); i++)
    {
        if (m_tasksets->at(i)->name().contains(keyname))
        {
            temp->append(m_tasksets->at(i));
        }
    }
    emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, temp));
}

void TaskSetService::modifyTaskSet(QString tid, QString name, QString content, QString area, float poslo, float posli, int cycle, int state, int duration)
{
    // 判断tid是否为0
    if (tid == "0")
    {
        // 添加任务
        addTaskSet(name, content, area, poslo, posli, cycle, state, duration);
    }
    else
    {
        // 更新任务
        updateTaskSet(tid, name, content, area, poslo, posli, cycle, state, duration);
    }
}

void TaskSetService::convertFeedbackToTaskSet(QString taskname, QString content, QString area, int duration)
{
    addTaskSet(taskname, content, area, 121.72439102324424, 41.61128739424099, -1, 5, duration);
}

void TaskSetService::deleteTaskSet(QString tid)
{
    TcpGet *get = new TcpGet("/api/taskset/delete", this);
    get->setParam("tid", tid);
    get->setHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(get);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "删除任务失败" << resp["code"].toString();
        }
        else
        {
            // 删除成功
            for (int i = 0; i < m_tasksets->size(); i++)
            {
                if (m_tasksets->at(i)->tid() == tid.toInt())
                {
                    m_tasksets->removeAt(i);
                    break;
                }
            }
            vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "删除任务", "删除成功", "");
            emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, m_tasksets));
        } });
    net->sendRequest();
    net->deleteLater();
    get->deleteLater();
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

TaskSetData *TaskSetService::getTaskSetListByTid(int tid)
{
    for (int i = 0; i < m_tasksets->size(); i++)
    {
        if (m_tasksets->at(i)->tid() == tid)
        {
            return m_tasksets->at(i);
        }
    }
    return nullptr;
}

void TaskSetService::addTaskSet(QString name, QString content, QString area, float poslo, float posli, int cycle, int state, int duration)
{
    TcpPost *post = new TcpPost("/api/taskset/add", this);
    QJsonObject body;
    post->setHeader("Authorization", globalsecurity::TOKEN);
    body.insert("name", name);
    body.insert("content", content);
    body.insert("area", area);
    body.insert("poslo", poslo);
    body.insert("posli", posli);
    body.insert("cycle", cycle);
    body.insert("state", state);
    body.insert("duration", duration);
    post->setBody(body);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "添加任务", "添加失败，请检查网络" + resp["code"].toString(), "");
            qDebug() << "添加任务失败" << resp["code"].toString();
            emit addTaskSetFailed();
        }
        else
        {
            getTaskSetList();
            emit addTaskSetSuccess();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void TaskSetService::updateTaskSet(QString tid, QString name, QString content, QString area, float poslo, float posli, int cycle, int state, int duration)
{
    TcpPost *post = new TcpPost("/api/taskset/update");
    post->setHeader("Authorization", globalsecurity::TOKEN);
    QJsonObject body;
    body.insert("tid", tid.toInt());
    body.insert("name", name);
    body.insert("content", content);
    body.insert("area", area);
    body.insert("poslo", poslo);
    body.insert("posli", posli);
    body.insert("cycle", cycle);
    body.insert("state", state);
    body.insert("duration", duration);
    post->setBody(body);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "更新任务", "更新失败，请检查网络" + resp["code"].toString(), "");
            qDebug() << "更新任务失败" << resp["code"].toString();
            emit updateTaskSetFailed();
        }
        else
        {
            // 在列表中寻找此任务并修改数据
            
            emit updateTaskSetSuccess();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void TaskSetService::fetchTaskSet(QString tid, QString name, QString content, QString area, float poslo, float posli, int cycle, int state, int duration)
{
    for (int i = 0; i < m_tasksets->size(); i++)
    {
        if (m_tasksets->at(i)->tid() == tid.toInt())
        {
            m_tasksets->at(i)->setName(name);
            m_tasksets->at(i)->setContent(content);
            m_tasksets->at(i)->setArea(area);
            m_tasksets->at(i)->setPoslo(poslo);
            m_tasksets->at(i)->setPosli(posli);
            m_tasksets->at(i)->setCycle(cycle);
            m_tasksets->at(i)->setState(state);
            m_tasksets->at(i)->setDuration(duration);
            return;
        }
    }
    emit taskSetListChanged(QQmlListProperty<TaskSetData>(this, m_tasksets));
}

QList<TaskSetData *> *TaskSetService::m_tasksets = new QList<TaskSetData *>();

// Path: Service/tasksetservice.cpp
