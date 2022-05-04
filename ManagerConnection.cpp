#include <QtCore/QFile>
#include <QVariantMap>

#include "ManagerConnection.h"

ManagerConnection::ManagerConnection()
    : in(stdin, QIODevice::ReadOnly)
    , out(stdout, QIODevice::WriteOnly)
{
    notifier = new QSocketNotifier(fileno(stdin), QSocketNotifier::Read, this);
    connect(notifier, SIGNAL(activated(int)), this, SLOT(read()));
}

void ManagerConnection::read()
{
    QString cmd = in.readLine();

    if (cmd == "SESSIONS")
        readSessions();
    else if (cmd == "ERROR")
        readError();
    else if (cmd == "GET PASSWORD")
        askForPassword(false);
    else if (cmd == "GET CREDENTIALS")
        askForPassword(true);
}

void ManagerConnection::readSessions()
{
    QVariantMap list;

    int count;
    in >> count;
    for (int i = 0; i < count; i++) {
        int id;
        QString username;
        QString name;

        in >> id;
        in >> username;
        name = in.readLine();

        list.insert(QString::number(id), QString(name + "\n(" + username + ")"));
    }

    emit sessionListReceived(list);
}

void ManagerConnection::readError()
{
    QString line, message;
    while (true) {
        line = in.readLine();
        if (line == "END ERROR")
            break;

        message += line + "\n";
    }

    emit errorReceived(message);
}

void ManagerConnection::askForPassword(bool includeUsername)
{
    emit passwordRequested(includeUsername);
}

void ManagerConnection::newSession()
{
    out << "NEW" << Qt::endl;
}

void ManagerConnection::openSession(int id)
{
    out << "OPEN " << id << Qt::endl;
}

void ManagerConnection::sendPassword(QString username, QString password)
{
    if (username.isEmpty()) {
        out << "PASSWORD " << password << Qt::endl;
    } else {
        out << "CREDENTIALS " << username << " " << password << Qt::endl;
    }
}

void ManagerConnection::cancelOpenSession()
{
    out << "CANCEL" << Qt::endl;
}
