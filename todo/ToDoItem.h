#ifndef TODOITEM_H
#define TODOITEM_H

#include "Serializable.h"
#include <QMetaType>
#include <QObject>
#include <QString>

namespace ToDoItemEnums
{
    Q_NAMESPACE
    enum class ToDoState : int { PENDING = 0, INPROGRESS, DONE };

    Q_ENUM_NS(ToDoState)
    }; // namespace ToDoItemEnums

    struct ToDoItem : public Serializable
    {
        QString label;
        QString details;
        bool isSelected;

        ToDoItem() : isSelected(false){};
        ToDoItem(QString a_label, QString a_details)
            : label{a_label}, details{a_details}, isSelected{false} {};

        virtual void insertToDataStream(QDataStream &dataStream) const override
        {
            dataStream << label << details << isSelected;
        }

        virtual void extractFromDataStream(QDataStream &dataStream) override
        {
            dataStream >> label >> details >> isSelected;
        }
    };

    //    QDataStream &operator<<(QDataStream &out, const ToDoItem &serializable);
    //    QDataStream &operator>>(QDataStream &in, ToDoItem &serializable);
#endif // TODOITEM_H
