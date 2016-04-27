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

    connect(ui.submitPasswordBtn, SIGNAL(accepted()), this, SLOT(passwordButtonClicked()));
    connect(ui.password, SIGNAL(returnPressed()), this, SLOT(passwordButtonClicked()));

    connect(ui.errorOkBtn, SIGNAL(accepted()), this, SLOT(errorOkButtonClicked()));
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
        pushButton->setMinimumHeight(64);

        connect(pushButton, SIGNAL(clicked(bool)), &mapper, SLOT(map()));
        mapper.setMapping(pushButton, iter.key());

        ui.sessionListLayout->addWidget(pushButton);
    }
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

void Greeter::errorOkButtonClicked()
{
    ui.stackedWidget->setCurrentWidget(ui.pageSessions);
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

    ui.stackedWidget->setCurrentWidget(ui.pagePassword);
}

void Greeter::passwordButtonClicked()
{
    if (ui.password->text().isEmpty() || (ui.username->isVisible() && ui.username->text().isEmpty()))
        return;

    emit passwordEntered(ui.username->text(), ui.password->text());

    ui.password->clear();
    ui.password->setDisabled(true);
    ui.username->clear();
    ui.username->setDisabled(true);
    ui.submitPasswordBtn->setDisabled(true);
}

#include "Greeter.moc"
