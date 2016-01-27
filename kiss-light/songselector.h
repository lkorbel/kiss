#ifndef SONGSELECTOR_H
#define SONGSELECTOR_H

#include <QWidget>

class Kiss;
class QAbstractButton;
class QLineEdit;
class NumberDialog;

namespace Ui {
class SongSelector;
}

class SongSelector : public QWidget
{
    Q_OBJECT

public:
    explicit SongSelector( Kiss *kiss, QWidget *parent);
    ~SongSelector();
    bool isMeeting() const;
    void setMeeting( bool running);
    bool areSongsPrepared() const;
    bool isBackgroundMusic() const;
    void setBackgroundMusic( bool enabled);

signals:
    void userWarning( QString );
    void allSongPlayed();

private slots:
    void musicIsFinished();
    void songSelected( QString );
    void on_setSongsButton_clicked();
    void on_song1Button_clicked();
    void on_song2Button_clicked();
    void on_song3Button_clicked();
    void on_cancelButton_clicked();
    void on_acceptButton_clicked();
    void on_musicButton_toggled( bool checked);
    void on_playButton1_toggled( bool checked);
    void on_playButton2_toggled( bool checked);
    void on_playButton3_toggled( bool checked);

private: 
    void playRandomSong();
    void updateMeetingStatus();
    void resetMeetingPlayback();
    Ui::SongSelector *ui;
    Kiss *kiss;
    int mSong1, mSong2, mSong3;
    bool mIsMeeting, mSongsPrepared, mBackgroundMusic;
    QAbstractButton *mActivatedSongButton;
    QLineEdit *mActivatedEdit;
    NumberDialog *mNumberDialog;
};

#endif // SONGSELECTOR_H
