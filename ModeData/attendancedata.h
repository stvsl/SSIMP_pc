#ifndef ATTENDANCEDATA_H
#define ATTENDANCEDATA_H

#include <QObject>

class AttendanceData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString employid READ employid WRITE setEmployid NOTIFY employidChanged)
    Q_PROPERTY(int tid READ tid WRITE setTid NOTIFY tidChanged)
    Q_PROPERTY(QString startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged)
    Q_PROPERTY(QString endTime READ endTime WRITE setEndTime NOTIFY endTimeChanged)
    Q_PROPERTY(QString taskCompletion READ taskCompletion WRITE setTaskCompletion NOTIFY taskCompletionChanged)
    Q_PROPERTY(QString inspectionTrack READ inspectionTrack WRITE setInspectionTrack NOTIFY inspectionTrackChanged)

public:
    explicit AttendanceData(QObject *parent = nullptr);
    AttendanceData(const QString &employid, int tid, const QString &startTime, const QString &endTime,
                   const QString &taskCompletion, const QString &inspectionTrack, QObject *parent = nullptr);

    QString employid() const;
    int tid() const;
    QString startTime() const;
    QString endTime() const;
    QString taskCompletion() const;
    QString inspectionTrack() const;
signals:
    void employidChanged();
    void tidChanged();
    void startTimeChanged();
    void endTimeChanged();
    void taskCompletionChanged();
    void inspectionTrackChanged();

public slots:
    void setEmployid(const QString &employid);
    void setTid(int tid);
    void setStartTime(const QString &startTime);
    void setEndTime(const QString &endTime);
    void setTaskCompletion(const QString &taskCompletion);
    void setInspectionTrack(const QString &inspectionTrack);

private:
    QString m_employid;
    int m_tid;
    QString m_startTime;
    QString m_endTime;
    QString m_taskCompletion;
    QString m_inspectionTrack;
};

#endif // ATTENDANCEDATA_H
