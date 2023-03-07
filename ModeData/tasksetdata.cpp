#include "tasksetdata.h"

TaskSetData::TaskSetData(QObject *parent)
    : QObject{parent}
{
}

TaskSetData::TaskSetData(int tid, const QString &name, const QString &content,
                         const QString &area, float poslo, float posli,
                         int cycle, QObject *parent)
    : QObject{parent}, m_tid{tid}, m_name{name}, m_content{content}, m_area{area}, m_poslo{poslo}, m_posli{posli}, m_cycle{cycle}
{
}

int TaskSetData::tid() const
{
    return m_tid;
}

QString TaskSetData::name() const
{
    return m_name;
}

QString TaskSetData::content() const
{
    return m_content;
}

QString TaskSetData::area() const
{
    return m_area;
}

float TaskSetData::poslo() const
{
    return m_poslo;
}

float TaskSetData::posli() const
{
    return m_posli;
}

int TaskSetData::cycle() const
{
    return m_cycle;
}

void TaskSetData::setTid(int tid)
{
    if (m_tid == tid)
        return;

    m_tid = tid;
    emit tidChanged();
}

void TaskSetData::setName(const QString &name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged();
}

void TaskSetData::setContent(const QString &content)
{
    if (m_content == content)
        return;

    m_content = content;
    emit contentChanged();
}

void TaskSetData::setArea(const QString &area)
{
    if (m_area == area)
        return;

    m_area = area;
    emit areaChanged();
}

void TaskSetData::setPoslo(float poslo)
{
    if (m_poslo == poslo)
        return;

    m_poslo = poslo;
    emit posloChanged();
}

void TaskSetData::setPosli(float posli)
{
    if (m_posli == posli)
        return;

    m_posli = posli;
    emit posliChanged();
}

void TaskSetData::setCycle(int cycle)
{
    if (m_cycle == cycle)
        return;

    m_cycle = cycle;
    emit cycleChanged();
}
