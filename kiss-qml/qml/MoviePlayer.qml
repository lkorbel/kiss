import QtQuick 2.5
import QtQuick.Window 2.2
import QtMultimedia 5.5
import QmlVlc 0.1

Window { id: window
    color: "#000000"
    onClosing: video.stop()

    function play(movie) {
        window.showFullScreen()
        video.mrl = movie
        video.play()
    }

    VlcPlayer {
        id: video
        onMediaPlayerEndReached: {
            video.stop();
            window.close();
        }
    }

    VlcVideoSurface {
        source: video
        anchors.fill: parent
    }
}


