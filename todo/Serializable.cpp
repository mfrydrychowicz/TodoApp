#include "serializable.h"

Serializable::Serializable()
{

}

QDataStream &operator<<(QDataStream &out, const Serializable &serializable)
{
    serializable.insertToDataStream(out);
    return out;
}
QDataStream &operator>>(QDataStream &in, Serializable &serializable)
{
    serializable.extractFromDataStream(in);
    return in;
}
