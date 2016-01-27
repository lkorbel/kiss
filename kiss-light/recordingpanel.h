#ifndef RECORDINGPANEL_H
#define RECORDINGPANEL_H

#include <QWidget>

namespace Ui {
class RecordingPanel;
}
class Kiss;

class RecordingPanel : public QWidget
{
    Q_OBJECT

public:
    explicit RecordingPanel(Kiss * kiss, QWidget *parent = 0);
    ~RecordingPanel();
    bool isRecording() const;

public slots:
    void setRecording( bool on);

private slots:
    void on_pauseButton_toggled(bool checked);

private:
    Ui::RecordingPanel *ui;
    Kiss * kiss;
    bool mRecording;
    QString mFilename;
};

#endif // RECORDINGPANEL_H
