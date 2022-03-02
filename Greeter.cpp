#include "Greeter.h"

#include <QtGui/QCloseEvent>
#include <QtGui/QScreen>
#include <QtGui/QWindow>

Greeter::Greeter()
    : QMainWindow(nullptr, Qt::X11BypassWindowManagerHint)
{
    ui.setupUi(this);

    connect(ui.newSessionBtn, SIGNAL(clicked(bool)), SIGNAL(newSession()));
    connect(&mapper, SIGNAL(mapped(int)), this, SIGNAL(openSession(int)));

    connect(ui.existingSessionsBtn, SIGNAL(clicked(bool)), SLOT(showSessions()));
    connect(ui.cancelSessionsBtn, SIGNAL(rejected()), SLOT(showHome()));

    connect(ui.password, SIGNAL(returnPressed()), this, SLOT(passwordButtonClicked()));
    connect(ui.username, SIGNAL(returnPressed()), this, SLOT(passwordButtonClicked()));
    connect(ui.submitPasswordBtn, SIGNAL(accepted()), this, SLOT(passwordButtonClicked()));
    connect(ui.submitPasswordBtn, SIGNAL(rejected()), this, SLOT(cancelAuthentication()));

    connect(ui.errorOkBtn, SIGNAL(accepted()), this, SLOT(showHome()));
}

Greeter::~Greeter()
{}

void Greeter::setSessionList(QMap<int, Session> list)
{
    while (QLayoutItem *item = ui.sessionListLayout->takeAt(0)) {
        if (QWidget *widget = item->widget())
            delete widget;
        delete item;
    }

    for (auto iter = list.begin(); iter != list.end(); ++iter) {
        QPushButton *pushButton = new QPushButton(ui.sessionList);
        pushButton->setText(iter.value().name + "\n(" + iter.value().username + ")");
        pushButton->setMinimumHeight(75);

        connect(pushButton, SIGNAL(clicked(bool)), &mapper, SLOT(map()));
        mapper.setMapping(pushButton, iter.key());

        ui.sessionListLayout->addWidget(pushButton);
    }

    // Height of scrollArea depends on number of sessions
    ui.scrollArea->setMinimumHeight(qMin(list.size(), 4) * (ui.sessionListLayout->spacing() + 75) + ui.sessionListLayout->contentsMargins().bottom());

    ui.existingSessionsBtn->setVisible((list.size() != 0));
}

void Greeter::showError(QString message)
{
    ui.errorLabel->setText(message);
    ui.stackedWidget->setCurrentWidget(ui.pageError);
}

void Greeter::closeEvent(QCloseEvent *event)
{
    // This window is never supposed to be closed.
    event->ignore();
}

void Greeter::showSessions()
{
    ui.stackedWidget->setCurrentWidget(ui.pageSessions);
}

void Greeter::showHome()
{
    ui.stackedWidget->setCurrentWidget(ui.pageHome);
}

void Greeter::passwordRequested(bool includeUsername)
{
    ui.usernameLbl->setVisible(includeUsername);
    ui.username->setVisible(includeUsername);

    ui.username->setDisabled(false);
    ui.username->clear();

    ui.password->setDisabled(false);
    ui.password->clear();

    ui.submitPasswordBtn->setDisabled(false);
    ui.passwordWarning->setVisible(false);

    ui.stackedWidget->setCurrentWidget(ui.pagePassword);
}

void Greeter::passwordButtonClicked()
{
    if (ui.password->text().isEmpty() || (ui.username->isVisible() && ui.username->text().isEmpty()))
    {
        ui.passwordWarning->setVisible(true);
        return;
    }

    emit passwordEntered(ui.username->text(), ui.password->text());

    ui.password->clear();
    ui.password->setDisabled(true);
    ui.username->clear();
    ui.username->setDisabled(true);
    ui.submitPasswordBtn->setDisabled(true);
    ui.passwordWarning->setVisible(false);

void Greeter::cancelAuthentication()
{
    emit cancelOpenSession();

    ui.password->clear();
    ui.password->setDisabled(true);
    ui.username->clear();
    ui.username->setDisabled(true);
    ui.submitPasswordBtn->setDisabled(true);
    ui.passwordWarning->setVisible(false);

    ui.stackedWidget->setCurrentWidget(ui.pageSessions);
}
}

#include "Greeter.moc"
