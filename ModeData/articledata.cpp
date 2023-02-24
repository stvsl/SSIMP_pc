#include "articledata.h"

ArticleData::ArticleData(QObject *parent)
    : QObject{parent}
{
}

ArticleData::ArticleData(const QString &aid, const QString &coverimg, const QString &contentimg,
                         const QString &title, const QString &introduction, const QString &text,
                         const QDateTime &writetime, const QDateTime &updatetime,
                         const QString &author, int pageviews, int status, QObject *parent)
    : QObject{parent}, m_aid{aid}, m_coverimg{coverimg}, m_contentimg{contentimg}, m_title{title}, m_introduction{introduction}, m_text{text}, m_writetime{writetime}, m_updatetime{updatetime}, m_author{author}, m_pageviews{pageviews}, m_status{status}
{
}

QString ArticleData::aid() const
{
    return m_aid;
}

QString ArticleData::coverimg() const
{
    return m_coverimg;
}

QString ArticleData::contentimg() const
{
    return m_contentimg;
}

QString ArticleData::title() const
{
    return m_title;
}

QString ArticleData::introduction() const
{
    return m_introduction;
}

QString ArticleData::text() const
{
    return m_text;
}

QDateTime ArticleData::writetime() const
{
    return m_writetime;
}

QDateTime ArticleData::updatetime() const
{
    return m_updatetime;
}

QString ArticleData::author() const
{
    return m_author;
}

QString ArticleData::toString() const
{
    return QString("aid: %1, coverimg: %2, contentimg: %3, title: %4, introduction: %5, text: %6, writetime: %7, updatetime: %8, author: %9, pageviews: %10, status: %11")
        .arg(m_aid)
        .arg(m_coverimg)
        .arg(m_contentimg)
        .arg(m_title)
        .arg(m_introduction)
        .arg(m_text)
        .arg(m_writetime.toString())
        .arg(m_updatetime.toString())
        .arg(m_author)
        .arg(m_pageviews)
        .arg(m_status);
}

QString ArticleData::getWriteTime() const
{
    return m_writetime.toString("yyyy-MM-dd hh:mm:ss");
}

QString ArticleData::getUpdateTime() const
{
    return m_updatetime.toString("yyyy-MM-dd hh:mm:ss");
}

int ArticleData::pageviews() const
{
    return m_pageviews;
}

int ArticleData::status() const
{
    return m_status;
}

void ArticleData::setAid(const QString &aid)
{
    if (m_aid == aid)
        return;

    m_aid = aid;
}

void ArticleData::setCoverimg(const QString &coverimg)
{
    if (m_coverimg == coverimg)
        return;

    m_coverimg = coverimg;
}

void ArticleData::setContentimg(const QString &contentimg)
{
    if (m_contentimg == contentimg)
        return;

    m_contentimg = contentimg;
}

void ArticleData::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
}

void ArticleData::setIntroduction(const QString &introduction)
{
    if (m_introduction == introduction)
        return;

    m_introduction = introduction;
}

void ArticleData::setText(const QString &text)
{
    if (m_text == text)
        return;

    m_text = text;
}

void ArticleData::setWritetime(const QDateTime &writetime)
{
    if (m_writetime == writetime)
        return;

    m_writetime = writetime;
}

void ArticleData::setUpdatetime(const QDateTime &updatetime)
{
    if (m_updatetime == updatetime)
        return;

    m_updatetime = updatetime;
}

void ArticleData::setAuthor(const QString &author)
{
    if (m_author == author)
        return;

    m_author = author;
}

void ArticleData::setPageviews(int pageviews)
{
    if (m_pageviews == pageviews)
        return;

    m_pageviews = pageviews;
}

void ArticleData::setStatus(int status)
{
    if (m_status == status)
        return;

    m_status = status;
}
