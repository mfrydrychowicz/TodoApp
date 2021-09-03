#ifndef TODOMODEL_H
#define TODOMODEL_H

#include <QAbstractListModel>

#include "ToDoList.h"
#include "ToDoItem.h"

class ToDoModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(ToDoList *list READ list WRITE setList)
public:
    explicit ToDoModel(QObject *parent = nullptr);

    enum { IsSelectedRole = Qt::UserRole + 1, LabelRole, DetailsRole };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    bool removeRows(int row, int count, const QModelIndex &parent) override;
    Q_INVOKABLE bool removeRow(int row);

    ToDoList *list() const;
    void setList(ToDoList* list);

private:
    ToDoList *m_list;
};

#endif // TODOMODEL_H
