#include <iostream>

#include <QtCore/QMap>
#include <QtCore/QString>
#include <QtWidgets/QApplication>
#include <QtGui/QScreen>

#include "Greeter.h"


int main(int argc, char **argv)
{
    setenv("DBUS_SESSION_BUS_ADDRESS", "UglyHack", true); // I need the attempt to connect to session dbus fail as fast as possible, instead of trying to start dbus-launch and failing anyway!

    QApplication app(argc, argv);

    ManagerConnection connection;
    Greeter greeter;

    QObject::connect(&connection, SIGNAL(sessionListReceived(QMap<int, Session>)), &greeter, SLOT(setSessionList(QMap<int, Session>)));

    QObject::connect(&connection, SIGNAL(errorReceived(QString)), &greeter, SLOT(showError(QString)));

    QObject::connect(&greeter, SIGNAL(newSession()), &connection, SLOT(newSession()));
    QObject::connect(&greeter, SIGNAL(openSession(int)), &connection, SLOT(openSession(int)));
    QObject::connect(&greeter, SIGNAL(cancelOpenSession()), &connection, SLOT(cancelOpenSession()));

    QObject::connect(&connection, SIGNAL(passwordRequested(bool)), &greeter, SLOT(passwordRequested(bool)));
    QObject::connect(&greeter, SIGNAL(passwordEntered(QString, QString)), &connection, SLOT(sendPassword(QString, QString)));

    greeter.setGeometry(app.screens().first()->availableGeometry());
    greeter.showFullScreen();

    return app.exec();
}
