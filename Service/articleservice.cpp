#include "articleservice.h"
#include "Utils/tcpnetutils.h"
#include "Utils/npost.h"
#include "Security/encryption.h"
#include <QJsonArray>
#include <QDateTime>
#include "Daemon/vctrler.h"

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
                                QString introduction = obj["introduction"].toString();
                                QString updatetime = obj["updatetime"].toString();
                                int pageviews = obj["pageviews"].toInt();
                                int status = obj["status"].toInt();
                                fetchArticle(aid,coverimg,title,introduction,updatetime,pageviews,status);
                            }
                         } });
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
    // 同步第一篇文章
    if (m_articles->size() > 0)
    {
        queryArticle(m_articles->at(0)->aid());
    }
    emit articleListChanged();
}

void ArticleService::reGetCarousel()
{
    QList<ArticleData *> *articles = new QList<ArticleData *>();
    // 遍历文章列表，查找status为2的文章
    for (int i = 0; i < m_articles->size(); i++)
    {
        qDebug() << m_articles->at(i)->status();
        if (m_articles->at(i)->status() == 2)
        {
            articles->append(m_articles->at(i));
        }
    }
    emit reGetCarouselSuccess(QQmlListProperty<ArticleData>(this, articles));
}

QQmlListProperty<ArticleData> ArticleService::articles()
{
    return QQmlListProperty<ArticleData>(this, m_articles);
}

QVariant ArticleService::queryArticle(QString aid)
{
    // 判断aid是否是0
    if (aid == "0")
    {
        emit queryArticleSuccess(QVariant::fromValue(new ArticleData(this)));
        return QVariant::fromValue(new ArticleData(this));
    }
    for (int i = 0; i < m_articles->size(); i++)
    {
        if (m_articles->at(i)->aid() == aid)
        {
            // 判断文章是否已经获取
            if (m_articles->at(i)->contentimg() == "")
            {
                fetchArticle(m_articles->at(i)->aid());
            }
            emit queryArticleSuccess(QVariant::fromValue(m_articles->at(i)));
            return QVariant::fromValue(m_articles->at(i));
        }
    }
    return QVariant::fromValue(new ArticleData(this));
}

void ArticleService::fetchArticle(QString aid, QString coverimg, QString title, QString instroduction, QString updatetime, int pageviews, int status)
{
    ArticleData *article = new ArticleData(this);
    article->setAid(aid);
    article->setCoverimg(coverimg);
    article->setTitle(title);
    article->setIntroduction(instroduction);
    article->setUpdatetime(QDateTime::fromString(updatetime, "yyyy-MM-ddTHH:mm:ss+08:00"));
    article->setPageviews(pageviews);
    article->setStatus(status);
    m_articles->append(article);
}

void ArticleService::fetchArticle(QString aid)
{
    TcpPost *post = new TcpPost("/api/article/detail", this);
    QJsonObject body;
    body.insert("aid", aid);
    post->setBody(body);
    TcpNetUtils *net = new TcpNetUtils(post);
    connect(
        net, &TcpNetUtils::requestFinished, this, [=, this]()
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
                                        return;
                                    }
                                }
                            } },
        Qt::DirectConnection);
    net->sendRequest();
    net->deleteLater();
    post->deleteLater();
}

void ArticleService::modifyArticle(QString aid, QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status)
{
    if (aid == "0")
    {
        addArticle(title, introduction, text, coverimgpath, contentimgpath, status);
        return;
    }
    else
    {
        updateArticle(aid, title, introduction, text, coverimgpath, contentimgpath, status);
    }
}

void ArticleService::addArticle(QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status)
{
    QString coverimgbase64 = ImgUtils::imgToBase64(coverimgpath);
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
    vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_YES_NO, "删除文章", "确定删除该文章吗？", "");
    QObject::connect(vctrler::m_vctrler, &vctrler::dialogResult, [=](QString result)
                     { qDebug() << "dialogResult:" << result;
                        if (result == "RESULT_YES"){
                            deletearticle(aid);
                        }
                        QObject::disconnect(vctrler::m_vctrler, &vctrler::dialogResult, nullptr, nullptr); });
}

void ArticleService::deletearticle(QString aid)
{
    TcpGet *get = new TcpGet("/api/article/delete", this);
    get->setHeader("Authorization", globalsecurity::TOKEN);
    get->setParam("aid", aid);
    TcpNetUtils *net = new TcpNetUtils(get);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                            if(resp["code"] != "SE200"){
                            vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "删除文章", "删除失败，请检查网络" + resp["code"].toString(), "");
                            qDebug() << "删除文章失败" << resp["code"].toString();
                            } 
                            else {
                                // 刷新文章列表
                                vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "删除文章", "删除成功", "");
                                getArticleList();
                                emit deleteArticleSuccess();
                            } });
    net->sendRequest();
    net->deleteLater();
    get->deleteLater();
}

void ArticleService::deleteAllArticle()
{
    m_articles->clear();
    emit deleteArticleSuccess();
}

void ArticleService::updateArticle(QString aid, QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status)
{
    // 检查是否有图片更新（如果两个路径是file开头的说明有更新）
    if (coverimgpath.startsWith("file"))
    {
        coverimgpath = ImgUtils::imgToBase64(coverimgpath);
    }
    if (contentimgpath.startsWith("file"))
    {
        contentimgpath = ImgUtils::imgToBase64(contentimgpath);
    }
    TcpPost *post = new TcpPost("/api/article/update", this);
    QJsonObject body;
    post->setHeader("Authorization", globalsecurity::TOKEN);
    body.insert("aid", aid);
    body.insert("title", title);
    body.insert("introduction", introduction);
    body.insert("text", text);
    body.insert("coverimg", coverimgpath);
    body.insert("contentimg", contentimgpath);
    body.insert("status", status);
    post->setBody(body);
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

void ArticleService::cancelCarousel(QString aid)
{
    TcpGet *get = new TcpGet("/api/article/tonocarousel", this);
    get->setHeader("Authorization", globalsecurity::TOKEN);
    get->setParam("aid", aid);
    TcpNetUtils *net = new TcpNetUtils(get);
    connect(net, &TcpNetUtils::requestFinished, this, [=, this]()
            {
                         // 获取返回值
                         QJsonDocument resp = net->getResponseBodyJsonDoc();
                            if(resp["code"] != "SE200"){
                            vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "取消轮播", "取消失败，请检查网络" + resp["code"].toString(), "");
                            qDebug() << "取消轮播失败" << resp["code"].toString() << resp["msg"].toString();
                            } 
                            else {
                                // 刷新文章列表
                                vctrler::showDialog(dialogType::DIALOG_TIP, dialogBtnType::DIALOG_OK, "取消轮播", "取消成功", "");
                                // 修改文章状态
                                for (int i = 0; i < m_articles->size(); i++)
                                {
                                    if (m_articles->at(i)->aid() == aid)
                                    {
                                        m_articles->at(i)->setStatus(0);
                                        break;
                                    }
                                }
                                emit cancelCarouselSuccess();
                            } });
    net->sendRequest();
    net->deleteLater();
    get->deleteLater();
}

// Path: Service/articleservice.h