import QtQuick 2.3

Item { id: panel
    
    property int handleY: 0
    property int mode: -1 //-1 no playing, 0 random mode, 1,2,3 - song modes
    state: "hidden"
    
    signal recordStartRequested
    signal recordStopRequested

    function show() { 
        state = "shown";
        showingSequence.running = true;
    }
    function hide() { 
        state = "hidden";
        showingSequence.running = false;
        music_prog.disable();
        music_rand.disable();
        //reset showing animation 
        arm1.width = 0; arm2.height = 0;
        music_rand.opacity = 0; music_prog.opacity = 0;
    }
    function setSong( number ) {
        song1.setValue( number );
        song2.setValue( number );
        song3.setValue( number );
    }

    Connections {
        target: kiss
        onSongFinished: {
            if (mode == 0) {
                kiss.stopMusic();
                kiss.playRandom();
            } else {
                song1.stop();
                song2.stop();
                song3.stop();
            }
        }
    }
    
     Rectangle{ id: arm1
        x: 0; y: handleY - height / 2
        width: 0//1.5 * win.big_button
        height: win.small_button / 3
        color: colors.alphaOff
    }
    Rectangle{ id: arm2
        x: arm1.width - width; y: arm1.y + arm1.height
        width: win.small_button / 3
        height: 0//win.big_button
        color: colors.alphaOff
    }
    
    Switch { id: music_rand
        x: arm2.x - (width - arm2.width) / 2
        y: arm2.y + (arm2.height - height) / 2
        height: win.medium_button; width: 2 * win.medium_button; radius: win.button_radius
        opacity: 0
        titleText: "Losowo"; titleSize: win.text_medium
        onSwitchEnabled: {
            music_prog.disable();
            mode = 0;
            kiss.playRandom()
        }
        onSwitchDisabled: {
            if (mode == 0)
            {
                kiss.stopMusic();
                mode = -1
            }
        }
    }
    Switch { id: music_prog
        x: arm2.x - (width - arm2.width) / 2
        y: arm2.y + arm2.height
        width: 2 * win.medium_button; height: win.medium_button; radius: win.button_radius
        opacity: 0
        titleText: "Zebranie"; titleSize: win.text_medium
        onSwitchEnabled: {
             music_rand.disable();
             song_panel.state = "shown";
             songPanelSequence.running = true;
         }
         onSwitchDisabled: {
             song_panel.state = "hidden";
             songPanelSequence.running = false;
             //resting song panel animation
             arm3.width = 0; arm4.height = 0;
             song1.opacity = 0; song2.opacity = 0; song3.opacity = 0;
             //stoping songs
             song1.stop();
             song2.stop();
             song3.stop();
        }
    }

    Rectangle{ id: song_panel
        x: music_prog.x + music_prog.width
        y: music_prog.y - (height - music_prog.height) / 2
        width: 3 * win.big_button; height: 2 * win.big_button; color: "#00000000"
        state: "hidden"
        
        Rectangle{ id: arm3
            x: 0; y: (song_panel.height - height) / 2
            width: 0//1.25 * win.big_button
            height: win.small_button / 4
            color: colors.alphaOff
        }
        Rectangle{ id: arm4
            x: arm3.width
            y: arm3.y - (height - arm3.height) / 2
            width: win.small_button / 4
            height: 0//1.25 * win.big_button
            color: colors.alphaOff
        }
        
        MusicSlot { id: song1
            x: arm4.x - (width - arm4.width) / 2
            y: arm4.y - height / 2
            width: 4 * win.small_button; height: win.small_button; 
            opacity: 0
            title: "Pieśń 1."
            onStarted: {
                song2.stop();
                song3.stop();
                mode = 1;
                kiss.startMusic( song1.value );
            }
            onStopped: {
                if (mode == 1) {
                    kiss.stopMusic();
                    mode = -1;
                    recordStartRequested() //prompt user for starting recording
                }
            }
        }
        MusicSlot { id: song2
            x: arm4.x - (width - arm4.width) / 2
            y: arm3.y - (height - arm3.height) / 2
            width: 4 * win.small_button; height: win.small_button; 
            opacity: 0
            title: "Pieśń 2."
            onStarted: {
                song1.stop();
                song3.stop();
                mode = 2;
                kiss.startMusic( song2.value );
            }
            onStopped: {
                if (mode == 2) {
                    kiss.stopMusic();
                    mode = -1;
                }
            }
        }
        MusicSlot { id: song3
            x: arm4.x - (width - arm4.width) / 2
            y: arm4.y - height / 2 + arm4.height
            width: 4 * win.small_button; height: win.small_button; 
            opacity: 0
            title: "Pieśń 3."
            onStarted: {
                song1.stop();
                song2.stop();
                mode = 3;
                recordStopRequested //stop recording now, so prayer will not be recorded
                kiss.startMusic( song3.value );

            }
            onStopped: {
                if (mode == 3) {
                    kiss.stopMusic();
                    mode = -1;
                }
            }
        }
        states:
        [
            State { name: "hidden";  
                    PropertyChanges { target: song_panel; visible: false} },
            State { name: "shown";  
                    PropertyChanges { target: song_panel; visible: true} }
        ]
        SequentialAnimation {
            id: songPanelSequence
            running: false
            NumberAnimation { target: arm3; property: "width"; to: 1.25 * win.big_button; duration: win.speed}
            NumberAnimation { target: arm4; property: "height"; to: 1.25 * win.big_button; duration: win.speed}
            NumberAnimation { target: song1; property: "opacity"; to: 1.0; duration: 0.5 * win.speed}
            NumberAnimation { target: song2; property: "opacity"; to: 1.0; duration: 0.5 * win.speed}
            NumberAnimation { target: song3; property: "opacity"; to: 1.0; duration: 0.5 * win.speed}
        }
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
        NumberAnimation { target: arm2; property: "height"; to: win.big_button; duration: win.speed}
        NumberAnimation { target: music_prog; property: "opacity"; to: 1.0; duration: win.speed}
        NumberAnimation { target: music_rand; property: "opacity"; to: 1.0; duration: win.speed}
    }
} 
