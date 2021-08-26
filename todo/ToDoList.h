#ifndef TODOLIST_H
#define TODOLIST_H

#include <QObject>
#include <QVector>

#include "ToDoItem.h"

class ToDoList : public QObject
{
    Q_OBJECT
public:
    explicit ToDoList(QObject *parent = nullptr);
    QVector<ToDoItem> getItems() const;
    bool updateItemAt(int index, const ToDoItem &item);

private:
    QVector<ToDoItem> m_items;

signals:
    void todoItemAdditionStart();
    void todoItemAdditionEnd();
    void todoItemRemovalStart(int index);
    void todoItemRemovalEnd();

public slots:
    void addItem();
    void removeCompletedItem();
};

#endif // TODOLIST_H
