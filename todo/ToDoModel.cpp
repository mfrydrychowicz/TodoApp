#include "ToDoModel.h"

ToDoModel::ToDoModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_items(nullptr)
{

}

QVariant ToDoModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    switch(section)
    {
    case 0:
        return QString("Student Name"); break;

    case 1:
        return QString("Number"); break;
    default:
        return QVariant(); break;
    }
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

    return m_items->getItems().size();
}

QVariant ToDoModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();


    const ToDoItem item = m_items->getItems().at(index.row());
    switch (role) {
    case IsSelectedRole:
        return QVariant(item.isSelected);
    case DoneRole:
        return QVariant::fromValue(item.done);
    case DetailsRole:
        return QVariant(item.details);
    case LabelRole:
        return QVariant(item.label);
    }

    return QVariant();
}

bool ToDoModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!m_items)
        return false;

    ToDoItem item = m_items->getItems().at(index.row());
    switch (role) {
    case DoneRole:
        item.done = qvariant_cast<ToDoItemEnums::ToDoState>(value);
        break;
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

    if (m_items->updateItemAt(index.row(), item)) {
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
    names[IsSelectedRole] = "isSelected";
    return names;
}

ToDoList *ToDoModel::list() const
{
    return m_items;
}

void ToDoModel::setList(ToDoList *list)
{
    beginResetModel();

    if (m_items) {
        m_items->disconnect(this);
    }

    m_items = list;

    if (m_items) {
        connect(m_items, &ToDoList::todoItemAdditionStart, this, [=]() {
            const int index = m_items->getItems().size();
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(m_items, &ToDoList::todoItemAdditionEnd, this, [=]() {
            endInsertRows();
        });

        connect(m_items, &ToDoList::todoItemRemovalStart, this, [=](int index) {
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(m_items, &ToDoList::todoItemRemovalEnd, this, [=]() {
            endRemoveRows();
        });
    }

    endResetModel();
}
