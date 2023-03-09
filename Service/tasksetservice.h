#ifndef TASKSETSERVICE_H
#define TASKSETSERVICE_H

#include <QObject>
#include "ModeData/tasksetdata.h"
#include <QQmlListProperty>

class TaskSetService : public QObject
{
    Q_OBJECT
public:
    explicit TaskSetService(QObject *parent = nullptr);

    Q_INVOKABLE void getTaskSetList();
    Q_INVOKABLE QQmlListProperty<TaskSetData> tasksets();
    Q_INVOKABLE void modifyTaskSet(QString tid, QString name, QString content, QString area, float poslo, float posli, int cycle);
    Q_INVOKABLE void deleteTaskSet(QString tid);
    Q_INVOKABLE QVariant getTaskSet(QString tid);

private:
    void addTaskSet(QString name, QString content, QString area, float poslo, float posli, int cycle);
    void updateTaskSet(QString tid, QString name, QString content, QString area, float poslo, float posli, int cycle);
signals:
    void taskSetListChanged(QQmlListProperty<TaskSetData> tasksets);

private:
    // 任务列表
    static QList<TaskSetData *> *m_tasksets;
};

#endif // TASKSERVICE_H
