#include "ToDoList.h"
#include <QDebug>
#include <QVector>
ToDoList::ToDoList(ToDoItemEnums::ToDoState state, DataFile &datafile, QObject *parent)
    : QObject(parent), m_state{state}, m_datafile{datafile}
{
    QString filename = "todoitems_" + QString::number(static_cast<int>(m_state)) + ".dat";
    m_datafile.setFilename(filename);
    m_datafile.readData(m_items);
}

ToDoList::~ToDoList()
{
    m_datafile.saveData(m_items);
}

void ToDoList::fillWithDummyData()
{
    m_items.push_back({QStringLiteral("Email"), QStringLiteral("Email X company to regarding Y")});
    m_items.push_back({QStringLiteral("Wash Dishes"), QLatin1String("")});
    m_items.push_back({QStringLiteral("Read 1h"), QLatin1String("")});
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
        if (false
            == (item.details == currentItem.details && item.label == currentItem.label
                && item.isSelected == currentItem.isSelected)) {
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
        item.label = a_label;
        item.details = a_details;
        m_items.append(item);

        emit todoItemAdditionEnd();
    }
}

void ToDoList::dropItem(QString a_label, QString a_details, bool a_done, bool a_isSelected)
{
    qDebug() << "do i even enter here";
    if (a_label.length() > 0) {
        emit todoItemAdditionStart();

        ToDoItem item;
        item.label = a_label;
        item.details = a_details;
        item.isSelected = a_isSelected;
        m_items.append(item);

        emit todoItemAdditionEnd();
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
