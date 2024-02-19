#include "feedbackservice.h"

FeedbackService::FeedbackService(QObject *parent)
    : QObject{parent}
{
    m_feedbacklist = new QList<FeedbackData *>();
}

void FeedbackService::fetchFeedbackListALL()
{
    TcpPost *post = new TcpPost("/api/feedback/list/all", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "获取反馈信息列表失败" << resp["code"].toString();
        }
        else
        {
            QString datastr = resp["data"].toString();
            // data转换为json数组并遍历
            QJsonArray data = QJsonDocument::fromJson(datastr.toUtf8()).array();
            m_feedbacklist->clear();
            for (int i = 0; i < data.size(); i++)
            {
                QJsonObject obj = data[i].toObject();
                FeedbackData *feedback = new FeedbackData(this);
                feedback->setQid(obj["qid"].toInt());
                feedback->setQuestion(obj["question"].toString());
                feedback->setDescription(obj["description"].toString());
                feedback->setPicture(obj["picture"].toString());
                feedback->setCreate_date(obj["createDate"].toString().mid(0, 10));
                feedback->setSponsor(obj["sponsor"].toString());
                feedback->setTeleinfo(obj["teleinfo"].toString());
                feedback->setPrincipal(obj["principal"].toString() == ""? "暂无": obj["principal"].toString());
                feedback->setStatus(obj["status"].toInt());
                m_feedbacklist->append(feedback);
            }
            emit feedbackListGet(QQmlListProperty<FeedbackData>(this, m_feedbacklist));
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::getFeedbackListALL()
{
    if (m_feedbacklist->length() > 0)
    {
        qDebug() << "反馈信息列表已存在，直接返回";
        emit feedbackListGet(QQmlListProperty<FeedbackData>(this, m_feedbacklist));
    }
    else
    {
        fetchFeedbackListALL();
    }
}

void FeedbackService::setToOrange(const QString &qid)
{
    TcpPost *post = new TcpPost("/api/feedback/set/orange", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    post->addParam("qid", qid);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈信息状态修改失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::setToAccept(const QString &qid)
{
    TcpPost *post = new TcpPost("/api/feedback/set/accept", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    post->addParam("qid", qid);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈信息状态修改失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::setToSolve(const QString &qid)
{
    TcpPost *post = new TcpPost("/api/feedback/set/solved", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    post->addParam("qid", qid);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈信息状态修改失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::setToDoing(const QString &qid)
{
    TcpPost *post = new TcpPost("/api/feedback/set/doing", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    post->addParam("qid", qid);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈信息状态修改失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::setToReject(const QString &qid)
{
    TcpPost *post = new TcpPost("/api/feedback/set/reject", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    post->addParam("qid", qid);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈信息状态修改失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::setDelegate(const QString &qid, const QString &eid)
{
    TcpPost *post = new TcpPost("/api/feedback/set/delegate", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    QJsonObject obj;
    obj.insert("qid", qid);
    obj.insert("eid", eid);
    post->setBody(obj);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈委派人员失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void FeedbackService::Delete(const QString &qid)
{
    TcpPost *post = new TcpPost("/api/feedback/delete", this);
    post->addHeader("Authorization", globalsecurity::TOKEN);
    post->addParam("qid", qid);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
        {
        // 获取返回值
        QJsonDocument resp = net->getResponseBodyJsonDoc();
        if (resp["code"] != "SE200")
        {
            qDebug() << "反馈信息状态修改失败" << resp["code"].toString();
        }
        else
        {
            fetchFeedbackListALL();
        } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}