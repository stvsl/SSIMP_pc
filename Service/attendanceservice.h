#ifndef ATTENDANCESERVICE_H
#define ATTENDANCESERVICE_H

#include <QObject>

class AttendanceService : public QObject
{
    Q_OBJECT
public:
    explicit AttendanceService(QObject *parent = nullptr);

signals:

};

#endif // ATTENDANCESERVICE_H
