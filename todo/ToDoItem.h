#ifndef TODOITEM_H
#define TODOITEM_H

#include <QString>

struct ToDoItem {
    bool done;
    QString label;
    QString details;
};

#endif // TODOITEM_H
