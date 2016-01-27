#ifndef MAINWIDGET_H
#define MAINWIDGET_H

#include <QWidget>

namespace Ui {
class MainWidget;
}
class Kiss;
class SongSelector;
class RecordingPanel;
class GlobalSettings;
class QTimer;

class MainWidget : public QWidget
{
    Q_OBJECT

public:
    explicit MainWidget(QWidget *parent = 0);
    ~MainWidget();

public slots:
    void showInfo( QString message, int time = 0);
    void showWarning( QString message, int time = 0);
    void showCritical( QString message, int time = 0);

protected:
    void closeEvent(QCloseEvent *event);

private slots:
    void determineMeeting();
    void updateTime(); //TODO move time managment to Kiss
    void updateMessages();
    void on_startButton_clicked();
    void on_endButton_clicked();
    void on_settingsButton_clicked();

private:
    int timeToMeeting( QTime now);
    enum Meeting { None, Ministry, Watchtower};
    Ui::MainWidget *ui;
    Kiss *kiss;
    SongSelector *mSongSelector;
    RecordingPanel *mRecordingPanel;
    GlobalSettings *settingsWidget;
    QTimer *timer; //TODO move time manamgent to KISS
    Meeting meeting;
    int infoMessageLife, warningMessageLife, criticalMessageLife;

    const int messagesDefaultLife;
    const int meetingPrepareTime;
    const int meetingSilenceTime;
    const int meetingCountdownTime;
    const int meetingDuration;
    const int earlyEndingThreshold;
};

#endif // MAINWIDGET_H
