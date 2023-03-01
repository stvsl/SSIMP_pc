#ifndef ARTICLESERVICE_H
#define ARTICLESERVICE_H

#include <QObject>
#include <QQmlListProperty>
#include "ModeData/articledata.h"
#include "Utils/imgutils.h"

class ArticleService : public QObject
{
    Q_OBJECT
public:
    explicit ArticleService(QObject *parent = nullptr);
    Q_INVOKABLE void getArticleList();
    Q_INVOKABLE QQmlListProperty<ArticleData> articles();

    /// @brief 与服务器同步具体的文章的详细信息
    /// @param aid 文章的aid
    Q_INVOKABLE void fetchArticle(QString aid);

    /// @brief  添加文章到服务器
    Q_INVOKABLE void addArticle(QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status);
    Q_INVOKABLE void deleteArticle(QString aid);

    /// @brief 删除所有文章(不同步服务器)
    Q_INVOKABLE void deleteAllArticle();

    /// @brief 更新文章
    Q_INVOKABLE void updateArticle(QString aid, QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status);

signals:
    void addArticleSuccess();
    void addArticleFailed();
    void deleteArticleSuccess();
    void deleteArticleFailed();
    void updateArticleSuccess();
    void updateArticleFailed();
    void articleListChanged();
    void queryArticleSuccess();

private:
    // 文章列表
    static QList<ArticleData *> *m_articles;

    // 与服务器同步文章列表与基本信息，包括文章的aid，封面图片，标题，更新时间，浏览量
    /// @brief fetchArticleList
    /// @param aid 文章的aid
    /// @param coverimg 文章的封面图片
    /// @param title 文章的标题
    /// @param updatetime 文章的更新时间
    /// @param pageviews 文章的浏览量
    void fetchArticle(QString aid, QString coverimg, QString title, QString updatetime, int pageviews);
};

#endif // ARTICLESERVICE_H
