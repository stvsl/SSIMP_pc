#ifndef TASKDATA_H
#define TASKDATA_H

#include <QObject>

class TaskData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString employid READ employid WRITE setEmployid NOTIFY employidChanged)
    Q_PROPERTY(int tid READ tid WRITE setTid NOTIFY tidChanged)

public:
    TaskData(const QString &employid, const int tid, QObject *parent = nullptr);
    explicit TaskData(QObject *parent = nullptr);

    QString employid() const;
    int tid() const;
    void setEmployid(QString eid);
    void setTid(int tid);

signals:
    void employidChanged();
    void tidChanged();

private:
    QString m_employid;
    int m_tid;
};

#endif // TASKDATA_H
