#include "ToDoModel.h"

ToDoModel::ToDoModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_list(nullptr)
{
}

QVariant ToDoModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
}

bool ToDoModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    if (value != headerData(section, orientation, role)) {
        // FIXME: Implement me!
        emit headerDataChanged(orientation, section, section);
        return true;
    }
    return false;
}

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
    case DoneRole:
        return QVariant(item.done);
    case DetailsRole:
        return QVariant(item.details);
    case LabelRole:
        return QVariant(item.label);
    }

    return QVariant();
}

bool ToDoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        // FIXME: Implement me!
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags ToDoModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable; // FIXME: Implement me!
}

QHash<int, QByteArray> ToDoModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[DoneRole] = "done";
    names[DetailsRole] = "details";
    names[LabelRole] = "label";
    return names;
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
        connect(m_list, &ToDoList::todoItemAdditionEnd, this, [=]() {
            endInsertRows();
        });

        connect(m_list, &ToDoList::todoItemRemovalStart, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_list, &ToDoList::todoItemRemovalEnd, this, [=]() {
            endRemoveRows();
        });
    }

    endResetModel();
}
