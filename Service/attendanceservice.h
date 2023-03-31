#ifndef ATTENDANCESERVICE_H
#define ATTENDANCESERVICE_H

#include <QObject>
#include <QQmlListProperty>
#include "ModeData/attendancedata.h"
#include "ModeData/tasksetdata.h"
#include <QVariant>

class AttendanceService : public QObject
{
    Q_OBJECT
public:
    explicit AttendanceService(QObject *parent = nullptr);

    Q_INVOKABLE void getAttendanceDayList(const QString &employid);
    Q_INVOKABLE void getAttendanceList(const QString &employid, const QString &date);
    Q_INVOKABLE void getAttendanceDetail(const QString &employid, int tid, const QString &date);

signals:
    void attendanceDayListGet(QString liststr);
    void attendanceListGet(QQmlListProperty<AttendanceData> tasksetlist);
    void attendanceDetailGet(QString inspectionTrack);

signals:
};

#endif // ATTENDANCESERVICE_H
