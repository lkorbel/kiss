import QtQuick 2.5
import "components" as UI

Item { id: panel
    
    property int handleY: 0
    
    state: "hidden"
    
    function show() {
        state = "shown";
        showingSequence.start();
    }
    function hide() { 
        state = "hidden";
        showingSequence.stop();
        arm1.width = 0;
        arm2.height = 0;
        arm3.width = 0;
        arm4.height = 0;
        mainPanel.opacity = 0.0;
        addButton.opacity = 0.0;
    }
    
    Rectangle { id: arm1
        x: 0; y: handleY - height / 2
        width: 0 // 1.5 * win.big_button
        height: win.small_button / 2
        color: colors.alphaOff
    }
    Rectangle { id: arm2
        x: arm1.width - width; y: arm1.y - arm2.height
        width: win.small_button / 2
        height: 0 // 3 * win.big_button
        color: colors.alphaOff
    }
    Rectangle { id: arm3
        x: arm2.x + arm2.width; y: arm2.y
        width: 0 // win.big_button
        height: win.small_button / 2
        color: colors.alphaOff
    }
    Rectangle { id: arm4
        x: arm3.x + arm3.width - width; y: arm3.y + arm3.height
        width: win.small_button / 2
        height: 0// 0.5 * win.big_button
        color: colors.alphaOff
    }

    Rectangle { id: mainPanel
        opacity: 0.0
        x: arm4.x - (width - arm4.width) / 5
        y: arm4.y + arm4.height
        width: 3 * win.big_button;
        height: 2 * win.big_button
        radius: win.button_radius
        border.width: win.button_border
        color: colors.betaOff
        border.color: colors.alphaOff
    }

    UI.Button { id: addButton
        opacity: 0.0
        x: arm1.width - (width + arm2.width) / 2
        y: arm1.y + (arm1.height - height) / 2
        width: win.small_button
        height: win.small_button
        titleText: "+"
        titleSize: win.text_small
        onClicked: moviePlayer.play("file:///home/lukhaz/Pobrane/imie_Jehowa.mp4")

    }

    MoviePlayer {
        id: moviePlayer
    }

    states:
    [
        State { name: "hidden";  
                PropertyChanges { target: panel; visible: false} },
        State { name: "shown";  
                PropertyChanges { target: panel; visible: true} }
    ]

    SequentialAnimation {
        id: showingSequence
        running: false
        NumberAnimation { target: arm1; property: "width"; to: 1.5 * win.big_button; duration: 1.5 * win.speed}
        NumberAnimation { target: arm2; property: "height"; to: 3 * win.medium_button; duration: 3 * win.speed}
        NumberAnimation { target: arm3; property: "width"; to: win.big_button; duration: win.speed}
        NumberAnimation { target: arm4; property: "height"; to: 0.5 * win.medium_button; duration: 0.5 * win.speed}
        NumberAnimation { target: mainPanel; property: "opacity"; to: 1.0; duration: 3 * win.speed}
        NumberAnimation { target: addButton; property: "opacity"; to: 1.0; duration: 3 * win.speed}
    }
} 
