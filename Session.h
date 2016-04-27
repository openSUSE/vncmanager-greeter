#ifndef SESSION_H
#define SESSION_H

#include <QtCore/QString>


class Session
{
public:
    Session(QString name, QString username);

    QString name;
    QString username;
};

#endif // SESSION_H
