#include "articleservice.h"

ArticleService::ArticleService(QObject *parent)
    : QObject{parent}
{
}
void ArticleService::getArticleList()
{
    emit articleListChanged();
}

QQmlListProperty<ArticleData> ArticleService::articles()
{
    return QQmlListProperty<ArticleData>(this, m_articles);
}

void ArticleService::addArticle(QString aid, QString title, QString content, QString author, QString date)
{
    ArticleData *article = new ArticleData(this);
    m_articles->append(article);
    emit addArticleSuccess();
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

void ArticleService::updateArticle(QString aid, QString title, QString content)
{
    // 在列表中查找对应的文章
    for (int i = 0; i < m_articles->size(); i++)
    {
        if (m_articles->at(i)->aid() == aid)
        {
            return;
        }
    }
    emit updateArticleFailed();
}

void ArticleService::queryArticle(QString aid)
{
    // 在列表中查找对应的文章
    for (int i = 0; i < m_articles->size(); i++)
    {
        if (m_articles->at(i)->aid() == aid)
        {
            return;
        }
    }
    emit queryArticleFailed();
}

QList<ArticleData *> *ArticleService::m_articles = new QList<ArticleData *>();

// Path: Service/articleservice.h