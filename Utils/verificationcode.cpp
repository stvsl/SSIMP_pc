#include "verificationcode.h"
#include <QPainter>
#include <QPainterPath>
#include <QTime>
VerificationCode::VerificationCode() {
  setAntialiasing(true);
  //生成随机种子
  srand(QTime::currentTime().second() * 1000 + QTime::currentTime().msec());
  colorArray = new QColor[letter_number];
  verificationCode = new QChar[letter_number];
}

void VerificationCode::paint(QPainter *painter) {
  m_width = contentsBoundingRect().width();
  m_height = contentsBoundingRect().height();
  noice_point_number = m_width * 0.9;
  double m_scale = 1;
  painter->scale(m_scale, m_scale);

  //产生4个不同的字符
  srand(QTime::currentTime().second() * 1000 + QTime::currentTime().msec());
  produceVerificationCode();
  QString verification = "";
  for (int i = 0; i < letter_number; ++i) {
    verification = verification + verificationCode[i];
    setVerification(verification);
  }
  //产生4个不同的颜色
  produceRandomColor();
  drawCode(painter);
}

void VerificationCode::drawCode(QPainter *painter) {
  painter->save();
  QPointF p;
  //绘制验证码
  QFont textFont;
  textFont.setPixelSize(39);
  textFont.setStyle(QFont::StyleOblique);

  for (int i = 0; i < letter_number; ++i) {
    p.setX(qAbs(i * (m_width / letter_number) + m_width / 24));
    p.setY(m_height - rand() % (m_height / 10));
    painter->setPen(colorArray[i]);
    painter->setFont(textFont);
    painter->drawText(p, QString(verificationCode[i]));
  }
  //绘制干扰点
  for (int j = 0; j < noice_point_number; ++j) // noice_point_number点数
  {
    painter->setPen(colorArray[j % 4]);
    painter->setBrush(colorArray[j % 4]);
    QRect pointRect(rand() % m_width, rand() % m_height, 2, 2);
    painter->drawEllipse(pointRect);
  }
  //绘制干扰线
  for (int i = 0; i < letter_number; ++i) {
    p.setX(i * (m_width / letter_number) + m_width / 8.5);
    p.setY(m_height / 2.2);

    QPainterPath anhuipath;
    anhuipath.moveTo(rand() % m_width, rand() % m_height);
    anhuipath.lineTo(rand() % m_width, rand() % m_height);
    anhuipath.setFillRule(Qt::WindingFill);
    painter->setPen(
        QPen(colorArray[i], 1, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    painter->drawPath(anhuipath);
  }
  painter->restore();
  emit verificationChanged();
}

QString VerificationCode::getVerificationCode() {
  QString str;
  QChar cTemp;
  for (int i = 0; i < letter_number; ++i) {
    cTemp = verificationCode[i];
    str += cTemp > QChar(97) ? cTemp.toUpper() : cTemp;
  }
  return str;
}

void VerificationCode::slt_reflushVerification() { update(); }

void VerificationCode::produceVerificationCode() const {
  for (int i = 0; i < letter_number; ++i) {
    verificationCode[i] = produceRandomLetter();
  }
}

QChar VerificationCode::produceRandomLetter() const {
  QChar c;
  int flag = rand() % letter_number;
  switch (flag) {
  case 0:
    c = QChar('0' + rand() % 10);
    break;
  case 1:
    c = QChar('A' + rand() % 26);
    break;
  case 2:
    c = QChar('a' + rand() % 26);
    break;
  default:
    c = QChar('0' + rand() % 10);
    break;
  }
  return c;
}

void VerificationCode::produceRandomColor() const {
  for (int i = 0; i < letter_number; ++i)
    colorArray[i] = QColor(rand() / 255, rand() / 255, rand() / 255);
  return;
}
