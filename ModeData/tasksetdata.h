#ifndef TASKSETDATA_H
#define TASKSETDATA_H

#include <QObject>

class TaskSetData : public QObject {
  Q_OBJECT
  Q_PROPERTY(int tid READ tid WRITE setTid NOTIFY tidChanged)
  Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
  Q_PROPERTY(
      QString content READ content WRITE setContent NOTIFY contentChanged)
  Q_PROPERTY(QString area READ area WRITE setArea NOTIFY areaChanged)
  Q_PROPERTY(float poslo READ poslo WRITE setPoslo NOTIFY posloChanged)
  Q_PROPERTY(float posli READ posli WRITE setPosli NOTIFY posliChanged)
  Q_PROPERTY(int cycle READ cycle WRITE setCycle NOTIFY cycleChanged)
  Q_PROPERTY(int state READ state WRITE setState NOTIFY stateChanged)
  Q_PROPERTY(
      int duration READ duration WRITE setDuration NOTIFY durationChanged)
public:
  explicit TaskSetData(QObject *parent = nullptr);
  explicit TaskSetData(int tid, const QString &name, const QString &content,
                       const QString &area, float poslo, float posli, int cycle,
                       int state, int duration, QObject *parent = nullptr);

  int tid() const;
  QString name() const;
  QString content() const;
  QString area() const;
  float poslo() const;
  float posli() const;
  int cycle() const;
  int state() const;
  int duration() const;
  void setTid(int tid);
  void setName(const QString &name);
  void setContent(const QString &content);
  void setArea(const QString &area);
  void setPoslo(float poslo);
  void setPosli(float posli);
  void setCycle(int cycle);
  void setState(int state);
  void setDuration(int duration);

signals:
  void tidChanged();
  void nameChanged();
  void contentChanged();
  void areaChanged();
  void posloChanged();
  void posliChanged();
  void cycleChanged();
  void stateChanged();
  void durationChanged();

private:
  int m_tid;
  QString m_name;
  QString m_content;
  QString m_area;
  float m_poslo;
  float m_posli;
  int m_cycle;
  int m_state;
  int m_duration;
};

#endif // TASKSETDATA_H