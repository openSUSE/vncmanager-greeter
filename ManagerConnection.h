#ifndef MANAGERCONNECTION_H
#define MANAGERCONNECTION_H

#include <QtCore/QMap>
#include <QtCore/QObject>
#include <QtCore/QSocketNotifier>
#include <QtCore/QTextStream>

#include "Session.h"


class ManagerConnection : public QObject
{
    Q_OBJECT

public:
    ManagerConnection();

signals:
    void sessionListReceived(QMap<int, Session> list);
    void errorReceived(QString message);
    void passwordRequested(bool includeUsername);

public slots:
    void newSession();
    void openSession(int id);
    void sendPassword(QString username, QString password);
    void cancelOpenSession();

private slots:
    void read();

private:
    void readSessions();
    void readError();
    void askForPassword(bool includeUsername);

private:
    QSocketNotifier *notifier;
    QTextStream in;
    QTextStream out;
};

#endif // MANAGERCONNECTION_H
