#ifndef GREETER_H
#define GREETER_H

#include <QtCore/QMap>
#include <QtCore/QSignalMapper>
#include <QtCore/QString>
#include <QtWidgets/QMainWindow>

#include "ManagerConnection.h"

#include "ui_Greeter.h"

class Greeter : public QMainWindow
{
    Q_OBJECT

public:
    Greeter();
    virtual ~Greeter();

signals:
    void newSession();
    void openSession(int id);
    void passwordEntered(QString username, QString password);
    void cancelOpenSession();

public slots:
    void setSessionList(QMap<int, Session> list);
    void showError(QString message);
    void passwordRequested(bool includeUsername);

protected slots:
    void showHome();
    void passwordButtonClicked();
    void showSessions();
    void cancelAuthentication();

protected:
    virtual void closeEvent(QCloseEvent *);

private:
    Ui_Greeter ui;

    QSignalMapper mapper;
};

#endif // GREETER_H
