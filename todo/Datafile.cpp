#include "Datafile.h"

#include <QFile>

DataFile::DataFile() {}

void DataFile::saveData(QVector<ToDoItem> &a_vector)
{
    if (m_filename.isNull() && m_filename.isEmpty())
        return;

    QFile file(m_filename);
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out << a_vector;
    file.flush();
    file.close();
}

void DataFile::readData(QVector<ToDoItem> &a_vector)
{
    if (m_filename.isNull() && m_filename.isEmpty())
        return;

    QFile file(m_filename);
    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);
    in >> a_vector;
    file.close();
}
