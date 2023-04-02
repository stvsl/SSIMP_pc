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

signals:
    void feedbackListGet(QQmlListProperty<FeedbackData> feedbacklist);

private:
    static QList<FeedbackData *> *m_feedbacklist;
};

#endif // FEEDBACKSERVICE_H
