#ifndef MANAGERCONNECTION_H
#define MANAGERCONNECTION_H

#include <QtCore/QSocketNotifier>
#include <QVariant>

class ManagerConnection : public QObject
{
    Q_OBJECT

public:
    ManagerConnection();

signals:
    void sessionListReceived(QVariant list);
    void errorReceived(QVariant message);
    void passwordRequested(QVariant includeUsername);

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
