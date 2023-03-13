#include "taskservice.h"

TaskService::TaskService(QObject *parent)
    : QObject{parent}
{
}

void TaskService::getTaskList()
{
}

void TaskService::addTask(QString eid, int tid)
{
}

void TaskService::deleteTask(QString eid, int tid)
{
}

void TaskService::updateTask(QString eid, int tid, int newtid)
{
}

// Path: Service/taskservice.h
