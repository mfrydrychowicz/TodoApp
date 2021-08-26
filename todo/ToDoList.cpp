#include "ToDoList.h"


ToDoList::ToDoList(QObject *parent) : QObject(parent)
{
    m_items.append({true, QStringLiteral("Email"), QStringLiteral("Email X company to regarding Y")});
    m_items.append({true, QStringLiteral("Wash Dishes"), QLatin1String("")});
    m_items.append({true, QStringLiteral("Read 1h"), QLatin1String("")});
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
            item.label == currentItem.label))
        {
            m_items[index] = item;
        }
    }
    return result;
}

void ToDoList::addItem()
{
    emit todoItemAdditionStart();

    ToDoItem item;
    item.done = false;
    item.label = QStringLiteral("Label example");
    item.details = QStringLiteral("Details example");
    m_items.append(item);

    emit todoItemAdditionEnd();
}

void ToDoList::removeCompletedItem()
{
    for (int index = 0; index < m_items.size(); ++index) {
        if (m_items.at(index).done) {
            emit todoItemRemovalStart(index);

            m_items.removeAt(index);

            emit todoItemRemovalEnd();
        }
    }
}
