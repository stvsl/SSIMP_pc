#include "attendancedata.h"

AttendanceData::AttendanceData(QObject *parent)
    : QObject{parent}
{
}

AttendanceData::AttendanceData(const QString &employid, int tid, const QString &startTime, const QString &endTime,
                               const QString &taskCompletion, const QString &inspectionTrack, QObject *parent)
    : QObject{parent}, m_employid{employid}, m_tid{tid}, m_startTime{startTime}, m_endTime{endTime}, m_taskCompletion{taskCompletion}, m_inspectionTrack{inspectionTrack}
{
}

QString AttendanceData::employid() const
{
    return m_employid;
}

int AttendanceData::tid() const
{
    return m_tid;
}

QString AttendanceData::startTime() const
{
    return m_startTime;
}

QString AttendanceData::endTime() const
{
    return m_endTime;
}

QString AttendanceData::taskCompletion() const
{
    return m_taskCompletion;
}

QString AttendanceData::inspectionTrack() const
{
    return m_inspectionTrack;
}

void AttendanceData::setEmployid(const QString &employid)
{
    if (m_employid == employid)
        return;

    m_employid = employid;
    emit employidChanged();
}

void AttendanceData::setTid(int tid)
{
    if (m_tid == tid)
        return;

    m_tid = tid;
    emit tidChanged();
}

void AttendanceData::setStartTime(const QString &startTime)
{
    if (m_startTime == startTime)
        return;

    m_startTime = startTime;
    emit startTimeChanged();
}

void AttendanceData::setEndTime(const QString &endTime)
{
    if (m_endTime == endTime)
        return;

    m_endTime = endTime;
    emit endTimeChanged();
}

void AttendanceData::setTaskCompletion(const QString &taskCompletion)
{
    if (m_taskCompletion == taskCompletion)
        return;

    m_taskCompletion = taskCompletion;
    emit taskCompletionChanged();
}

void AttendanceData::setInspectionTrack(const QString &inspectionTrack)
{
    if (m_inspectionTrack == inspectionTrack)
        return;

    m_inspectionTrack = inspectionTrack;
    emit inspectionTrackChanged();
}

// Path: ModeData/attendancedata.h
