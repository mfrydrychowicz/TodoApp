#include "ToDoList.h"
#include <QDebug>


ToDoList::ToDoList(QObject *parent) : QObject(parent)
{
    m_items.append({ToDoItemEnums::ToDoState::PENDING, QStringLiteral("Email"), QStringLiteral("Email X company to regarding Y")});
    m_items.append(
        {ToDoItemEnums::ToDoState::PENDING, QStringLiteral("Wash Dishes"), QLatin1String("")});
    m_items.append({ToDoItemEnums::ToDoState::PENDING, QStringLiteral("Read 1h"), QLatin1String("")});
}

QVector<ToDoItem> ToDoList::getItems() const
{
    return m_items;
}

bool ToDoList::updateItemAt(int index, const ToDoItem &item)
{
    bool result = false;
    if (index > 0 || index < m_items.size()) {
        const ToDoItem &currentItem = m_items.at(index);
        if (false == (item.done == currentItem.done &&
            item.details == currentItem.details &&
            item.label == currentItem.label &&
            item.isSelected == currentItem.isSelected))
        {
            m_items[index] = item;
            result = true;
        }
    }
    return result;
}

void ToDoList::addItem(QString a_label, QString a_details)
{
    if (a_label.length() > 0) {
        emit todoItemAdditionStart();

        ToDoItem item;
        item.done = ToDoItemEnums::ToDoState::PENDING;
        item.label = a_label;
        item.details = a_details;
        m_items.append(item);

        emit todoItemAdditionEnd();
    }
}

void ToDoList::removeCompletedItem()
{
    for (int index = 0; index < m_items.size(); ++index) {
        if (ToDoItemEnums::ToDoState::DONE == m_items.at(index).done) {
            emit todoItemRemovalStart(index);

            m_items.removeAt(index);

            emit todoItemRemovalEnd();
        }
    }
}


void ToDoList::removeSelectedItems()
{
    for (int index =  m_items.size() - 1; index >= 0; --index) {
         qDebug() <<  "index: " << index;
        if (m_items.at(index).isSelected) {

            emit todoItemRemovalStart(index);

            m_items.removeAt(index);
            qDebug() <<  "is selected at index: " << index;
            emit todoItemRemovalEnd();
        }
    }
}
