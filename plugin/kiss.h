//----------------------------------------------------------------------------//
// KIngdom hall Sound System based on VLC
// Łukasz Korbel <korbel85@gmail.com>
// Apr 2013
//----------------------------------------------------------------------------//
#ifndef KISS_H
#define KISS_H
//----------------------------------------------------------------------------//
#include <QObject>
#include <QString>
#include <QTime>
#include <QDir>
//----------------------------------------------------------------------------//
struct libvlc_instance_t;
//----------------------------------------------------------------------------//
class Kiss : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(QString songsPath READ songsPath WRITE setSongsPath NOTIFY songsPathChanged)
    Q_PROPERTY(QString recordsPath READ recordsPath WRITE setRecordsPath NOTIFY recordsPathChanged)
    Q_PROPERTY(QString recordInput READ recordInput WRITE setRecordInput NOTIFY recordInputChanged)
    Q_PROPERTY(int songsCount READ songsCount WRITE setSongsCount NOTIFY songsCountChanged)

    public:
        Kiss( QObject *parent = 0);
        ~Kiss();
        
        QString songsPath() const;
        void setSongsPath( QString path);
        QString recordsPath() const;
        void setRecordsPath( QString path);
        QString recordInput() const;
        void setRecordInput( QString input);
        int songsCount() const;
        void setSongsCount(int count);
        
        //Audio
        Q_INVOKABLE void startRecording( QString name);
        Q_INVOKABLE void stopRecording();
        Q_INVOKABLE QString generateRecordName();
        //Music
        Q_INVOKABLE void startMusic( int number);
        Q_INVOKABLE void stopMusic();
        Q_INVOKABLE void playRandom();
        //Settings
        Q_INVOKABLE void loadSettings();
        Q_INVOKABLE void saveSettings();
        
    signals:
        void songFinished() const;
        void songsPathChanged() const;
        void recordsPathChanged() const;
        void recordInputChanged() const;
        void songsCountChanged() const;

    private:
        Q_DISABLE_COPY(Kiss); //we don't want/need copy constructor
        friend void vlcEventHandler(const struct libvlc_event_t *, void *);
        //vlc objects
        libvlc_instance_t *vlcInstance_;
        bool isPlaying_, isRecording_;
        //khss settings
        QDir songsDir_;
        QDir recordsDir_;
        QString recordInput_;
        int songsCount_;
};
//----------------------------------------------------------------------------//
#endif //KHSS_H

