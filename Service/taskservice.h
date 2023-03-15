#ifndef TASKSERVICE_H
#define TASKSERVICE_H

#include <QObject>
#include <QQmlListProperty>
#include "ModeData/taskdata.h"
#include "ModeData/tasksetdata.h"
#include <QQmlListProperty>

class TaskService : public QObject
{
    Q_OBJECT
public:
    explicit TaskService(QObject *parent = nullptr);

    Q_INVOKABLE void getTaskListByEid(QString eid);
    Q_INVOKABLE void addTask(QString eid, int tid);
    Q_INVOKABLE void deleteTask(QString eid, int tid);
    Q_INVOKABLE void updateTask(QString eid, int tid, int newtid);

signals:
    void employeeTaskListChanged(QQmlListProperty<TaskSetData> taskList);
    void addTaskSuccess();
    void deleteTaskSuccess();
    void updateTaskSuccess();

private:
    static QList<TaskSetData *> *tasksetList;
};

#endif // TASKSERVICE_H
