#ifndef ARTICLESERVICE_H
#define ARTICLESERVICE_H

#include <QObject>
#include <QQmlListProperty>
#include "ModeData/articledata.h"

class ArticleService : public QObject
{
    Q_OBJECT
public:
    explicit ArticleService(QObject *parent = nullptr);
    Q_INVOKABLE void getArticleList();
    Q_INVOKABLE QQmlListProperty<ArticleData> articles();
    Q_INVOKABLE void addArticle(QString aid, QString title, QString content, QString author, QString date);
    Q_INVOKABLE void deleteArticle(QString aid);
    Q_INVOKABLE void deleteAllArticle();
    Q_INVOKABLE void updateArticle(QString aid, QString title, QString content);
    Q_INVOKABLE void queryArticle(QString aid);

signals:
    void addArticleSuccess();
    void addArticleFailed();
    void deleteArticleSuccess();
    void deleteArticleFailed();
    void updateArticleSuccess();
    void updateArticleFailed();
    void queryArticleSuccess();
    void queryArticleFailed();
    void articleListChanged();

private:
    static QList<ArticleData *> *m_articles;
};

#endif // ARTICLESERVICE_H
