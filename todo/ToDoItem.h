#ifndef TODOITEM_H
#define TODOITEM_H

#include <QString>
#include <QMetaType>
#include <QObject>

namespace ToDoItemEnums
{
    Q_NAMESPACE
    enum class ToDoState : int
    {
        PENDING = 0,
        INPROGRESS,
        DONE
    };

     Q_ENUM_NS(ToDoState)
};

struct ToDoItem
{
    ToDoItemEnums::ToDoState done;
    QString label;
    QString details;
    bool isSelected;

    ToDoItem() : isSelected(false){};
    ToDoItem(ToDoItemEnums::ToDoState a_done, QString a_label, QString a_details)
        : done {a_done}
        , label {a_label}
        , details {a_details}
        , isSelected{false}
    {};
};

#endif // TODOITEM_H
