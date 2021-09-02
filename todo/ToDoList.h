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
    void dropItem(QString a_label, QString a_details, bool a_done, bool a_isSelected);

    QVector<ToDoItem> m_items;

private:
signals:
    void todoItemAdditionStart();
    void todoItemAdditionEnd();
    void todoItemRemovalStart(int index);
    void todoItemRemovalEnd();

public slots:
    void addItem(QString a_label, QString a_details);
    void removeCompletedItem();
    void removeSelectedItems();
};

#endif // TODOLIST_H
