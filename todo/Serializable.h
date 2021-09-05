#ifndef SERIALIZABLE_H
#define SERIALIZABLE_H

#include <QDataStream>

class Serializable
{
public:
    Serializable();
    virtual void insertToDataStream(QDataStream &dataStream) const = 0;
    virtual void extractFromDataStream(QDataStream &dataStream) = 0;
};
QDataStream &operator<<(QDataStream &out, const Serializable &serializable);
QDataStream &operator>>(QDataStream &in, Serializable &serializable);

#endif // SERIALIZABLE_H
