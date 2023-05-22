#ifndef ARTICLEDATA_H
#define ARTICLEDATA_H

#include <QDateTime>
#include <QObject>

class ArticleData : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString aid READ aid WRITE setAid NOTIFY aidChanged)
  Q_PROPERTY(
      QString coverimg READ coverimg WRITE setCoverimg NOTIFY coverimgChanged)
  Q_PROPERTY(QString contentimg READ contentimg WRITE setContentimg NOTIFY
                 contentimgChanged)
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QString introduction READ introduction WRITE setIntroduction NOTIFY
                 introductionChanged)
  Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
  Q_PROPERTY(QDateTime writetime READ writetime WRITE setWritetime NOTIFY
                 writetimeChanged)
  Q_PROPERTY(QDateTime updatetime READ updatetime WRITE setUpdatetime NOTIFY
                 updatetimeChanged)
  Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)
  Q_PROPERTY(
      int pageviews READ pageviews WRITE setPageviews NOTIFY pageviewsChanged)
  Q_PROPERTY(int status READ status WRITE setStatus NOTIFY statusChanged)

public:
  explicit ArticleData(QObject *parent = nullptr);
  explicit ArticleData(const QString &aid, const QString &coverimg,
                       const QString &contentimg, const QString &title,
                       const QString &introduction, const QString &text,
                       const QDateTime &writetime, const QDateTime &updatetime,
                       const QString &author, int pageviews, int status,
                       QObject *parent = nullptr);
  QString aid() const;
  QString coverimg() const;
  QString contentimg() const;
  QString title() const;
  QString introduction() const;
  QString text() const;
  QDateTime writetime() const;
  QDateTime updatetime() const;
  QString author() const;
  QString toString() const;
  QString getWriteTime() const;
  QString getUpdateTime() const;
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

signals:
  void aidChanged();
  void coverimgChanged();
  void contentimgChanged();
  void titleChanged();
  void introductionChanged();
  void textChanged();
  void writetimeChanged();
  void updatetimeChanged();
  void authorChanged();
  void pageviewsChanged();
  void statusChanged();

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
