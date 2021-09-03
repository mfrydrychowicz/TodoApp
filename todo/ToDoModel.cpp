#include "ToDoModel.h"

#include <QIODevice>
#include <QMimeData>

ToDoModel::ToDoModel(QObject *parent) : QAbstractListModel(parent), m_list(nullptr) {}

int ToDoModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_list->getItems().size();
}

QVariant ToDoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const ToDoItem item = m_list->getItems().at(index.row());
    switch (role) {
    case IsSelectedRole:
        return QVariant(item.isSelected);
    case DetailsRole:
        return QVariant(item.details);
    case LabelRole:
        return QVariant(item.label);
    }

    return QVariant();
}

bool ToDoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!m_list)
        return false;

    ToDoItem item = m_list->getItems().at(index.row());
    switch (role) {
    case IsSelectedRole:
        item.isSelected = value.toBool();
        qDebug() << "now value item.isSelected " << value.toBool();
        break;
    case DetailsRole:
        item.details = value.toString();
        break;
    case LabelRole:
        item.label = value.toString();
        break;
    }

    if (m_list->updateItemAt(index.row(), item)) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags ToDoModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags defaultFlags = ToDoModel::flags(index);

    if (index.isValid())
        return Qt::ItemIsDragEnabled | Qt::ItemIsDropEnabled | defaultFlags;
    else
        return Qt::ItemIsDropEnabled |  Qt::ItemIsEditable | defaultFlags;

}

QHash<int, QByteArray> ToDoModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[DetailsRole] = "details";
    names[LabelRole] = "label";
    names[IsSelectedRole] = "isSelected";
    return names;
}

bool ToDoModel::removeRows(int row, int count, const QModelIndex &parent)
{
    if (parent.isValid())
        return false;

    if (row >= m_list->getItems().size() || row + count <= 0)
        return false;

    int beginRow = qMax(0, row);
    int endRow = qMin(row + count - 1, m_list->getItems().size() - 1);

    beginRemoveRows(parent, beginRow, endRow);

    while (beginRow <= endRow) {
        m_list->m_items.removeAt(beginRow);
        ++beginRow;
    }

    endRemoveRows();
    return true;
}

bool ToDoModel::removeRow(int row)
{
    return removeRows(row, 1, QModelIndex());
}

ToDoList *ToDoModel::list() const
{
    return m_list;
}

void ToDoModel::setList(ToDoList *list)
{
    beginResetModel();

    if (m_list) {
        m_list->disconnect(this);
    }

    m_list = list;

    if (m_list) {
        connect(m_list, &ToDoList::todoItemAdditionStart, this, [=]() {
            const int index = m_list->getItems().size();
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(m_list, &ToDoList::todoItemAdditionEnd, this, [=]() { endInsertRows(); });

        connect(m_list, &ToDoList::todoItemRemovalStart, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_list, &ToDoList::todoItemRemovalEnd, this, [=]() { endRemoveRows(); });
    }

    endResetModel();
}
