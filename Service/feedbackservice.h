#ifndef FEEDBACKSERVICE_H
#define FEEDBACKSERVICE_H

#include <QObject>
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include <QQmlListProperty>
#include "ModeData/feedbackdata.h"
#include "Daemon/global.h"
#include <QJsonArray>

class FeedbackService : public QObject
{
    Q_OBJECT
public:
    explicit FeedbackService(QObject *parent = nullptr);
    Q_INVOKABLE void fetchFeedbackListALL();
    Q_INVOKABLE void getFeedbackListALL();
    Q_INVOKABLE void setToOrange(const QString &qid);
    Q_INVOKABLE void setToAccept(const QString &qid);
    Q_INVOKABLE void setToSolve(const QString &qid);
    Q_INVOKABLE void setToDoing(const QString &qid);
    Q_INVOKABLE void setToReject(const QString &qid);
    Q_INVOKABLE void setDelegate(const QString &qid, const QString &eid);
    Q_INVOKABLE void Delete(const QString &qid);

signals:
    void
    feedbackListGet(QQmlListProperty<FeedbackData> feedbacklist);

private:
    QList<FeedbackData *> *m_feedbacklist;
};

#endif // FEEDBACKSERVICE_H
