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
    Q_INVOKABLE void reGetCarousel();
    Q_INVOKABLE QQmlListProperty<ArticleData> articles();

    /// @brief 向删除文章事务
    Q_INVOKABLE void deleteArticle(QString aid);

    /// @brief 向服务器请求文章详细信息(如果本地有则不请求)
    Q_INVOKABLE QVariant queryArticle(QString aid);

    /// @brief 向服务器添加文章或者更新文章
    Q_INVOKABLE void modifyArticle(QString aid, QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status);

    /// @brief 取消文章的轮播模式，变为发布模式
    Q_INVOKABLE void cancelCarousel(QString aid);

signals:
    void
    addArticleSuccess();
    void addArticleFailed();
    void deleteArticleSuccess();
    void deleteArticleFailed();
    void updateArticleSuccess();
    void updateArticleFailed();
    void articleListChanged();
    void queryArticleSuccess(QVariant article);
    void reGetCarouselSuccess(QQmlListProperty<ArticleData> articles);
    void cancelCarouselSuccess();

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
    void fetchArticle(QString aid, QString coverimg, QString title, QString instroduction, QString updatetime, int pageviews, int status);

    /// @brief 与服务器同步具体的文章的详细信息
    /// @param aid 文章的aid
    void fetchArticle(QString aid);

    /// @brief 与服务器同步删除文章
    void deletearticle(QString aid);

    /// @brief  添加文章到服务器
    void addArticle(QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status);

    /// @brief 更新文章
    void updateArticle(QString aid, QString title, QString introduction, QString text, QString coverimgpath, QString contentimgpath, int status);

    /// @brief 删除所有文章(不同步服务器)
    void deleteAllArticle();
};

#endif // ARTICLESERVICE_H
