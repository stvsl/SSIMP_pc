#ifndef FEEDBACKDATA_H
#define FEEDBACKDATA_H

#include <QObject>

class FeedbackData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int qid READ qid WRITE setQid NOTIFY qidChanged)
    Q_PROPERTY(QString question READ question WRITE setQuestion NOTIFY questionChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QString picture READ picture WRITE setPicture NOTIFY pictureChanged)
    Q_PROPERTY(QString create_date READ create_date WRITE setCreate_date NOTIFY create_dateChanged)
    Q_PROPERTY(QString sponsor READ sponsor WRITE setSponsor NOTIFY sponsorChanged)
    Q_PROPERTY(QString teleinfo READ teleinfo WRITE setTeleinfo NOTIFY teleinfoChanged)
    Q_PROPERTY(QString principal READ principal WRITE setPrincipal NOTIFY principalChanged)
    Q_PROPERTY(int status READ status WRITE setStatus NOTIFY statusChanged)

public:
    explicit FeedbackData(QObject *parent = nullptr);
    explicit FeedbackData(int qid, const QString &question, const QString &description,
                          const QString &picture, const QString &create_date,
                          const QString &sponsor, const QString &teleinfo,
                          const QString &principal, int status, QObject *parent = nullptr);
    int qid() const;
    QString question() const;
    QString description() const;
    QString picture() const;
    QString create_date() const;
    QString sponsor() const;
    QString teleinfo() const;
    QString principal() const;
    int status() const;
    void setQid(int qid);
    void setQuestion(const QString &question);
    void setDescription(const QString &description);
    void setPicture(const QString &picture);
    void setCreate_date(const QString &create_date);
    void setSponsor(const QString &sponsor);
    void setTeleinfo(const QString &teleinfo);
    void setPrincipal(const QString &principal);
    void setStatus(int status);

signals:
    void qidChanged();
    void questionChanged();
    void descriptionChanged();
    void pictureChanged();
    void create_dateChanged();
    void sponsorChanged();
    void teleinfoChanged();
    void principalChanged();
    void statusChanged();

private:
    int m_qid;
    QString m_question;
    QString m_description;
    QString m_picture;
    QString m_create_date;
    QString m_sponsor;
    QString m_teleinfo;
    QString m_principal;
    int m_status;
};

#endif // FEEDBACKDATA_H