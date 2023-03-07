#include "tasksetservice.h"

TaskSetService::TaskSetService(QObject *parent)
    : QObject{parent}
{
}

void TaskSetService::getTaskSetList()
{
    // 从服务器获取任务列表
    // 从数据库获取任务列表
    // 从本地获取任务列表
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
