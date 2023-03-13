#ifndef TASKSERVICE_H
#define TASKSERVICE_H

#include <QObject>
#include <QQmlListProperty>
#include "ModeData/taskdata.h"

class TaskService : public QObject
{
    Q_OBJECT
public:
    explicit TaskService(QObject *parent = nullptr);

    Q_INVOKABLE void getTaskList();
    Q_INVOKABLE void addTask(QString eid, int tid);
    Q_INVOKABLE void deleteTask(QString eid, int tid);
    Q_INVOKABLE void updateTask(QString eid, int tid, int newtid);

signals:
    void getTaskListChanged(QQmlListProperty<TaskData> tasks);
    void addTaskSuccess();
    void deleteTaskSuccess();
    void updateTaskSuccess();
};

#endif // TASKSERVICE_H
