#include "ToDoModel.h"

#include <QIODevice>
#include <QMimeData>

ToDoModel::ToDoModel(QObject *parent) : QAbstractListModel(parent), m_list(nullptr) {}

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
    if (!m_list)
        return false;

    ToDoItem item = m_list->getItems().at(index.row());
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
    names[DoneRole] = "done";
    names[DetailsRole] = "details";
    names[LabelRole] = "label";
    names[IsSelectedRole] = "isSelected";
    return names;
}

Qt::DropActions ToDoModel::supportedDropActions() const
{
    return Qt::MoveAction;
}

QStringList ToDoModel::mimeTypes() const
{
    QStringList types;
    types << "application/todoitem.list";
    return types;
}

QMimeData *ToDoModel::mimeData(const QModelIndexList &indexes) const
{
    QMimeData *mimeData = new QMimeData();
    QByteArray encodedData;

    QDataStream stream(&encodedData, QIODevice::WriteOnly);

    foreach (QModelIndex index, indexes) {
        if (index.isValid()) {
            QString label = data(index, DoneRole).toString();
            QString details = data(index, DetailsRole).toString();
            bool isSelected = data(index, IsSelectedRole).toBool();
            bool done = data(index, DoneRole).toBool();
            stream << label << details << isSelected << done;
        }
    }

    mimeData->setData("application/todoitem.list", encodedData);
    return mimeData;
}

bool ToDoModel::dropMimeData(
    const QMimeData *data, Qt::DropAction action, int row, int column, const QModelIndex &parent)
{
    if (action == Qt::IgnoreAction)
        return true;

    if (!data->hasFormat("application/todoitem.list"))
        return false;

    if (column > 0)
        return false;

    int beginRow;

    //    if (row != -1)
    //        beginRow = row;
    //    else if (parent.isValid())
    //        beginRow = parent.row();
    //    else
    //        beginRow = m_items->getItems().size();

    QByteArray encodedData = data->data("application/todoitem.list");
    QDataStream stream(&encodedData, QIODevice::ReadOnly);

    int rows = 0;

    while (!stream.atEnd()) {
        QString label;
        QString details;
        bool isSelected;
        bool done;
        stream >> done;
        stream >> isSelected;
        stream >> details;
        stream >> label;
        m_list->dropItem(label, details, isSelected, done);
    }

    return true;
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
