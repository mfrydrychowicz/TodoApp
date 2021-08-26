#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "todo/ToDoModel.h"
#include "todo/ToDoList.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QFontDatabase::addApplicationFont(":/fonts/fonts/Roboto-Light.ttf");
    QFont font = QFont("Roboto Light", 12);
    app.setFont(font);

    qmlRegisterType<ToDoModel>("ToDoModel", 1, 0, "ToDoModel");
    qmlRegisterUncreatableType<ToDoList>("ToDoList",
                                         1,
                                         0,
                                         "ToDoList",
                                         QStringLiteral("ToDoList shall not be created in QML"));
    ToDoList toDoList;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("toDoList"), &toDoList);

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
