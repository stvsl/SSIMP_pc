#include "attendanceservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "QJsonArray"
#include "Daemon/global.h"
#include "Service/tasksetservice.h"

AttendanceService::AttendanceService(QObject *parent)
    : QObject{parent}
{
}

void AttendanceService::getAttendanceDayList(const QString &employid)
{
    TcpPost *post = new TcpPost("/api/attendance/list/day", this);
    post->addParam("eid", employid);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "获取考勤日期列表失败" << resp["code"].toString();
        }
        else
        {
            QString datastr = resp["data"].toString();
            // 去掉首尾的中括号
            datastr = datastr.mid(1, datastr.length() - 2);
            // 将,替换为|,将"替换为空
            datastr.replace(",", "|");
            datastr.replace("\"", "");
#if ATTENDANCE_DEBUG == 1
            qDebug() << "获取考勤日期列表成功" << data.size();
#endif
            emit attendanceDayListGet(datastr);
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void AttendanceService::getAttendanceList(const QString &employid, const QString &date)
{
    TcpPost *post = new TcpPost("/api/attendance/list", this);
    post->addParam("eid", employid);
    post->addParam("date", date);
    post->setHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "获取考勤列表失败" << resp["code"].toString();
        }
        else
        {
            QString datastr = resp["data"].toString();
            QJsonDocument dataDoc = QJsonDocument::fromJson(datastr.toUtf8());
            QJsonArray data = dataDoc.array();
#if ATTENDANCE_DEBUG == 1
            qDebug() << "获取考勤列表成功" << data.size();
#endif
            QList<AttendanceData *> *list = new QList<AttendanceData *>();
            for (int i = 0; i < data.size(); i++)
            {
                QJsonObject obj = data[i].toObject();
                QString tid = QString::number(obj["tid"].toInt());
                QString starttime = obj["startTime"].toString();
                QString endtime = obj["endTime"].toString();
                QString task_completion = obj["taskCompletion"].toString();

                AttendanceData *attendance = new AttendanceData(this);
                attendance->setTid(obj["tid"].toInt());
                attendance->setEmployid(obj["eid"].toString());
                attendance->setStartTime(obj["startTime"].toString().mid(0, 10));
                attendance->setEndTime(obj["endTime"].toString().mid(0, 10));
                // 判断结束时间是不是0001-01-01
                if (attendance->endTime() == "0001-01-01")
                {
                    attendance->setEndTime("未完成");
                }
                attendance->setTaskCompletion(obj["taskCompletion"].toString());
                list->append(attendance);
            }
            emit attendanceListGet(QQmlListProperty<AttendanceData>(this, list));
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void AttendanceService::getAttendanceDetail(const QString &employid, int tid, const QString &date)
{
    TcpPost *post = new TcpPost("/api/attendance/record", this);
    post->addParam("eid", employid);
    post->addParam("tid", QString::number(tid));
    post->addParam("date", date);
    post->setHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "获取考勤详情失败" << resp["code"].toString();
        }
        else
        {
            QString datastr = resp["data"].toString();
            QJsonDocument dataDoc = QJsonDocument::fromJson(datastr.toUtf8());
#if ATTENDANCE_DEBUG == 1
            qDebug() << "获取考勤详情成功" << data.size();
#endif
            AttendanceData *att = new AttendanceData();
            QJsonObject obj = dataDoc.object();
            emit attendanceDetailGet(obj["inspectionTrack"].toString());
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}