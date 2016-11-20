import QtQuick 2.5
import QtQuick.Window 2.2
import QtMultimedia 5.5

Window { id: window
    function play(movie) {
        window.showFullScreen()
        video.source = movie
        video.play()
    }

    Video { id: video
        anchors.fill: parent
        onStopped: window.hide()
    }
}


