#ifndef DATAFILE_H
#define DATAFILE_H

#include "Serializable.h"
#include "ToDoItem.h"
#include <QString>

class DataFile
{
public:
    DataFile();
    void setFilename(QString a_filename) { m_filename = a_filename; };
    void saveData(QVector<ToDoItem> &a_vector);
    void readData(QVector<ToDoItem> &a_vector);

private:
    QString m_filename;
};

#endif // DATAFILE_H
