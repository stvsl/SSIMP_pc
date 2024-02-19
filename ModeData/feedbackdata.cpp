#include "feedbackdata.h"

FeedbackData::FeedbackData(QObject *parent)
    : QObject{parent}
{
}

FeedbackData::FeedbackData(int qid, const QString &question, const QString &description, const QString &picture, const QString &create_date, const QString &sponsor, const QString &teleinfo, const QString &principal, int status, QObject *parent)
    : QObject{parent}, m_qid{qid}, m_question{question}, m_description{description}, m_picture{picture}, m_create_date{create_date}, m_sponsor{sponsor}, m_teleinfo{teleinfo}, m_principal{principal}, m_status{status}
{
}

int FeedbackData::qid() const
{
    return m_qid;
}

QString FeedbackData::question() const
{
    return m_question;
}

QString FeedbackData::description() const
{
    return m_description;
}

QString FeedbackData::picture() const
{
    return m_picture;
}

QString FeedbackData::create_date() const
{
    return m_create_date;
}

QString FeedbackData::sponsor() const
{
    return m_sponsor;
}

QString FeedbackData::teleinfo() const
{
    return m_teleinfo;
}

QString FeedbackData::principal() const
{
    return m_principal;
}

int FeedbackData::status() const
{
    return m_status;
}

void FeedbackData::setQid(int qid)
{
    if (m_qid == qid)
        return;

    m_qid = qid;
    emit qidChanged();
}

void FeedbackData::setQuestion(const QString &question)
{
    if (m_question == question)
        return;

    m_question = question;
    emit questionChanged();
}

void FeedbackData::setDescription(const QString &description)
{
    if (m_description == description)
        return;

    m_description = description;
    emit descriptionChanged();
}

void FeedbackData::setPicture(const QString &picture)
{
    if (m_picture == picture)
        return;

    m_picture = picture;
    emit pictureChanged();
}

void FeedbackData::setCreate_date(const QString &create_date)
{
    if (m_create_date == create_date)
        return;

    m_create_date = create_date;
    emit create_dateChanged();
}

void FeedbackData::setSponsor(const QString &sponsor)
{
    if (m_sponsor == sponsor)
        return;

    m_sponsor = sponsor;
    emit sponsorChanged();
}

void FeedbackData::setTeleinfo(const QString &teleinfo)
{
    if (m_teleinfo == teleinfo)
        return;

    m_teleinfo = teleinfo;
    emit teleinfoChanged();
}

void FeedbackData::setPrincipal(const QString &principal)
{
    if (m_principal == principal)
        return;

    m_principal = principal;
    emit principalChanged();
}

void FeedbackData::setStatus(int status)
{
    if (m_status == status)
        return;

    m_status = status;
    emit statusChanged();
}

// Path: ModeData/feedbackdata.h
