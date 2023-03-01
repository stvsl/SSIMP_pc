#include "articleservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "Security/encryption.h"
#include <QJsonArray>
#include <QDateTime>

QList<ArticleData *> *ArticleService::m_articles = new QList<ArticleData *>();

ArticleService::ArticleService(QObject *parent)
    : QObject{parent}
{
}

void ArticleService::getArticleList()
{
    TcpPost *post = new TcpPost("/api/article/list", this);
    post->setHeader("Authorization", globalsecurity::TOKEN);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                         if(resp["code"] != "SE200"){
                           qDebug() << "获取文章列表失败" << resp["code"].toString();
                         } 
                         else {
                            QString datastr = resp["data"].toString();

#if ARTICLE_DEBUG == 1
                            qDebug() << "获取文章信息列表成功";
                            qDebug() << datastr;
#endif
                            // 解析
                            QJsonDocument data = QJsonDocument::fromJson(datastr.toUtf8());
                            QJsonArray array = data.array();
                            deleteAllArticle();
                            for (int i = 0; i < array.size(); i++) {
                                QJsonObject obj = array.at(i).toObject();
                                QString aid = obj["aid"].isString() ? obj["aid"].toString() : QString::number(obj["aid"].toVariant().toLongLong());
                                QString coverimg = obj["coverimg"].toString();
                                QString title = obj["title"].toString();
                                QString updatetime = obj["updatetime"].toString();
                                int pageviews = obj["pageviews"].toInt();
                                fetchArticle(aid,coverimg,title,updatetime,pageviews);
                            }
                         } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
    // 同步第一篇文章
    if (m_articles->size() > 0)
    {
        fetchArticle(m_articles->at(0)->aid());
    }
    emit articleListChanged();
}

QQmlListProperty<ArticleData> ArticleService::articles()
{
    return QQmlListProperty<ArticleData>(this, m_articles);
}

void ArticleService::fetchArticle(QString aid, QString coverimg, QString title, QString updatetime, int pageviews)
{
    ArticleData *article = new ArticleData(this);
    article->setAid(aid);
    article->setCoverimg(coverimg);
    article->setTitle(title);
    article->setUpdatetime(QDateTime::fromString(updatetime, "yyyy-MM-ddTHH:mm:ss+08:00"));
    article->setPageviews(pageviews);
    m_articles->append(article);
}

void ArticleService::fetchArticle(QString aid)
{
    TcpPost *post = new TcpPost("/api/article/detail", this);
    QJsonObject body;
    body.insert("aid", aid);
    post->setBody(body);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                            if(resp["code"] != "SE200"){
                            qDebug() << "获取文章失败" << resp["code"].toString();
                            } 
                            else {
                                QString datastr = resp["data"].toString();

#if ARTICLE_DEBUG == 1
                                qDebug() << "获取文章信息成功";
                                qDebug() << datastr;
#endif
                                //"{\"aid\":0,\"coverimg\":\"\",\"contentimg\":\"\",\"title\":\"\",\"introduction\":\"\",\"text\":\"\",\"writetime\":\"0001-01-01T00:00:00Z\",\"updatetime\":\"0001-01-01T00:00:00Z\",\"author\":\"\",\"pageviews\":0,\"status\":0}"
                                QJsonDocument data = QJsonDocument::fromJson(datastr.toUtf8());
                                QString coverimg = data["coverimg"].toString();
                                QString contentimg = data["contentimg"].toString();
                                QString title = data["title"].toString();
                                QString introduction = data["introduction"].toString();
                                QString text = data["text"].toString();
                                QString writetime = data["writetime"].toString();
                                QString updatetime = data["updatetime"].toString();
                                QString author = data["author"].toString();
                                int pageviews = data["pageviews"].toInt();
                                int status = data["status"].toInt();
                                for (int i = 0; i < m_articles->size(); i++)
                                {
                                    if (m_articles->at(i)->aid() == aid)
                                    {
                                        m_articles->at(i)->setCoverimg(coverimg);
                                        m_articles->at(i)->setContentimg(contentimg);
                                        m_articles->at(i)->setTitle(title);
                                        m_articles->at(i)->setIntroduction(introduction);
                                        m_articles->at(i)->setText(text);
                                        m_articles->at(i)->setWritetime(QDateTime::fromString(writetime, "yyyy-MM-ddTHH:mm:ss+08:00"));
                                        m_articles->at(i)->setUpdatetime(QDateTime::fromString(updatetime, "yyyy-MM-ddTHH:mm:ss+08:00"));
                                        m_articles->at(i)->setAuthor(author);
                                        m_articles->at(i)->setPageviews(pageviews);
                                        m_articles->at(i)->setStatus(status);
                                        emit queryArticleSuccess();
                                        return;
                                    }
                                }
                            } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void ArticleService::addArticle(QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status)
{
    QString coverimgbase64 = ImgUtils::imgToBase64(coverimgpath);
    qDebug() << "coverimgbase64:" << coverimgbase64;
    QString contentimgbase64 = ImgUtils::imgToBase64(contentimgpath);
    TcpPost *post = new TcpPost("/api/article/add", this);
    QJsonObject body;
    post->setHeader("Authorization", globalsecurity::TOKEN);
    body.insert("title", title);
    body.insert("introduction", introduction);
    body.insert("text", text);
    body.insert("coverimg", coverimgbase64);
    body.insert("contentimg", contentimgbase64);
    body.insert("status", status);
    post->setBody(body);
    qDebug() << "addArticle（）：" << body;
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                            if(resp["code"] != "SE200"){
                            qDebug() << "添加文章失败" << resp["code"].toString();
                            } 
                            else {
                                // 刷新文章列表
                                getArticleList();
                                emit addArticleSuccess();
                            } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void ArticleService::deleteArticle(QString aid)
{
    for (int i = 0; i < m_articles->size(); i++)
    {
        if (m_articles->at(i)->aid() == aid)
        {
            m_articles->removeAt(i);
            emit deleteArticleSuccess();
            return;
        }
    }
    emit deleteArticleFailed();
}

void ArticleService::deleteAllArticle()
{
    m_articles->clear();
    emit deleteArticleSuccess();
}

void ArticleService::updateArticle(QString aid, QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status)
{
    QString coverimgbase64 = ImgUtils::imgToBase64(coverimgpath);
    QString contentimgbase64 = ImgUtils::imgToBase64(contentimgpath);
    TcpPost *post = new TcpPost("/api/article/update", this);
    QJsonObject body;
    post->setHeader("Authorization", globalsecurity::TOKEN);
    body.insert("aid", aid);
    body.insert("title", title);
    body.insert("introduction", introduction);
    body.insert("text", text);
    body.insert("coverimg", coverimgbase64);
    body.insert("contentimg", contentimgbase64);
    body.insert("status", status);
    post->setBody(body);
    // qDebug() << "更新文章" << post->getBody();
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                            if(resp["code"] != "SE200"){
                            qDebug() << "更新文章失败" << resp["code"].toString();
                            } 
                            else {
                                // 刷新文章列表
                                getArticleList();
                                emit updateArticleSuccess();
                            } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

// Path: Service/articleservice.h