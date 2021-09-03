#include <QFontDatabase>
#include <QGuiApplication>
#include <QMetaType>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "todo/ToDoModel.h"
#include "todo/ToDoList.h"
#include "todo/ToDoItem.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QFontDatabase::addApplicationFont(":/fonts/fonts/Roboto-Light.ttf");
    QFont font = QFont(
                "Roboto Light", 12);
    app.setFont(font);

    qmlRegisterType<ToDoModel>("ToDoModel", 1, 0, "ToDoModel");
    qmlRegisterUncreatableMetaObject(ToDoItemEnums::staticMetaObject,
                                     "todo.ToDoItem",
                                     1, 0,
                                     "ToDoItemEnums",
                                     "Error: cannot create enum in QML");
    qmlRegisterUncreatableType<ToDoList>("ToDoList",
                                         1,
                                         0,
                                         "ToDoList",
                                         QStringLiteral("ToDoList shall not be created in QML"));
    ToDoList toDoListPending = ToDoList(ToDoItemEnums::ToDoState::PENDING);
    toDoListPending.fillWithDummyData();
    ToDoList toDoListInProgress = ToDoList(ToDoItemEnums::ToDoState::INPROGRESS);
    ToDoList toDoListDone = ToDoList(ToDoItemEnums::ToDoState::DONE);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("toDoListPending"), &toDoListPending);
    engine.rootContext()->setContextProperty(QStringLiteral("toDoListInProgress"),
                                             &toDoListInProgress);
    engine.rootContext()->setContextProperty(QStringLiteral("toDoListDone"), &toDoListDone);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
