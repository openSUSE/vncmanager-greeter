#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QQmlContext>
#include <QQmlComponent>

#include "ManagerConnection.h"


int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QSettings settings(QString("/etc/vnc/vncmanager-greeter.conf"), QSettings::defaultFormat());
    QQmlComponent styleComponent(&engine, QUrl(QString("file:") + settings.value("style").toString()));
    QObject *styleObject = styleComponent.create();
    engine.rootContext()->setContextProperty("Style", styleObject);

    engine.load(QUrl(QString("qrc:/vncmanager_greeter/greeter.qml")));

    ManagerConnection connection;
    QObject *greeter = engine.rootObjects().first();

    QObject::connect(&connection, SIGNAL(sessionListReceived(QVariant)), greeter, SLOT(setSessionList(QVariant)));

    QObject::connect(greeter, SIGNAL(newSession()), &connection, SLOT(newSession()));
    QObject::connect(greeter, SIGNAL(openSession(int)), &connection, SLOT(openSession(int)));
    QObject::connect(greeter, SIGNAL(cancelOpenSession()), &connection, SLOT(cancelOpenSession()));
     
    QObject::connect(&connection, SIGNAL(errorReceived(QVariant)), greeter, SLOT(showError(QVariant)));

    QObject::connect(&connection, SIGNAL(passwordRequested(QVariant)), greeter, SLOT(passwordRequested(QVariant)));
    QObject::connect(greeter, SIGNAL(passwordEntered(QString, QString)), &connection, SLOT(sendPassword(QString, QString)));

    return app.exec();
}
