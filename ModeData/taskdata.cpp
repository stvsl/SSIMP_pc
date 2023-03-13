#include "taskdata.h"

TaskData::TaskData(QObject *parent)
    : QObject{parent}
{
}

TaskData::TaskData(const QString &employid, const int tid, QObject *parent)
    : QObject{parent}, m_employid{employid}, m_tid{tid}
{
}

QString TaskData::employid() const
{
    return m_employid;
}

void TaskData::setEmployid(QString eid)
{
    if (m_employid == eid)
        return;
    m_employid = eid;
    emit employidChanged();
}

int TaskData::tid() const
{
    return m_tid;
}

void TaskData::setTid(int tid)
{
    if (m_tid == tid)
        return;

    m_tid = tid;
    emit tidChanged();
}
