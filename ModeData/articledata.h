#ifndef ARTICLEDATA_H
#define ARTICLEDATA_H

#include <QObject>
#include <QDateTime>

class ArticleData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString aid READ aid WRITE setAid)
    Q_PROPERTY(QString coverimg READ coverimg WRITE setCoverimg)
    Q_PROPERTY(QString contentimg READ contentimg WRITE setContentimg)
    Q_PROPERTY(QString title READ title WRITE setTitle)
    Q_PROPERTY(QString introduction READ introduction WRITE setIntroduction)
    Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(QDateTime writetime READ writetime WRITE setWritetime)
    Q_PROPERTY(QDateTime updatetime READ updatetime WRITE setUpdatetime)
    Q_PROPERTY(QString author READ author WRITE setAuthor)
    Q_PROPERTY(int pageviews READ pageviews WRITE setPageviews)
    Q_PROPERTY(int status READ status WRITE setStatus)

public:
    explicit ArticleData(QObject *parent = nullptr);
    explicit ArticleData(const QString &aid, const QString &coverimg, const QString &contentimg,
                         const QString &title, const QString &introduction, const QString &text,
                         const QDateTime &writetime, const QDateTime &updatetime,
                         const QString &author, int pageviews, int status, QObject *parent = nullptr);
    QString aid() const;
    QString coverimg() const;
    QString contentimg() const;
    QString title() const;
    QString introduction() const;
    QString text() const;
    QDateTime writetime() const;
    QDateTime updatetime() const;
    QString author() const;
    int pageviews() const;
    int status() const;
    void setAid(const QString &aid);
    void setCoverimg(const QString &coverimg);
    void setContentimg(const QString &contentimg);
    void setTitle(const QString &title);
    void setIntroduction(const QString &introduction);
    void setText(const QString &text);
    void setWritetime(const QDateTime &writetime);
    void setUpdatetime(const QDateTime &updatetime);
    void setAuthor(const QString &author);
    void setPageviews(int pageviews);
    void setStatus(int status);

private:
    QString m_aid;
    QString m_coverimg;
    QString m_contentimg;
    QString m_title;
    QString m_introduction;
    QString m_text;
    QDateTime m_writetime;
    QDateTime m_updatetime;
    QString m_author;
    int m_pageviews;
    int m_status;
};

#endif // ARTICLEDATA_H
