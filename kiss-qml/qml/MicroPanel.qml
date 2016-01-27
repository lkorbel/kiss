import QtQuick 2.0
Item { id: panel
    
    property int handleY: 0
    property string record: ""
    
    state: "hidden"
    
    signal recording( bool active )

    function show() { 
        state = "shown"; 
        showingSequence.running = true;
    }
    function hide() { 
        state = "hidden";
        showingSequence.running = false;
        //reset initial settings for showing
        arm1.width = 0; arm2.height = 0; mainArea.opacity = 0;
    }
    function setRecordName( name ) {
        record = name;
        recordname.titleText = name;
    }
    function prompt(on) {
        recordPrompt.font.bold = on
        if (on) {
            recordPrompt.font.pointSize = win.text_large
            setRecordName( kiss.generateRecordName() )
            promptAnimation.start()
        } else {
            promptAnimation.stop()
            recordPrompt.font.pointSize = win.text_medium
            recordPrompt.color = colors.gammaOff
        }
    }
    
    Rectangle{ id: arm1
        x: 0; y: handleY - height / 2
        width: 0 //2.5 * win.big_button
        height: win.small_button / 2
        color: colors.alphaOff
    }
    Rectangle{ id: arm2
        x: arm1.width - width; y: arm1.y + arm1.height
        width: win.small_button / 2
        height: 0 //win.medium_button
        color: colors.alphaOff
    }
    
    Rectangle{ id: mainArea
        x: arm2.x - (width - arm2.width) / 2
        y: arm2.y + arm2.height
        width: 3.5 * win.big_button; height: 2 * win.big_button
        radius: win.button_radius
        border.width: win.button_border
        color: colors.betaOff
        border.color: colors.alphaOff
        opacity: 0

        Item{ id: label
            anchors.left: parent.left; anchors.top: parent.top
            width: parent.width; height: parent.height / 3
            Text{ 
            anchors.centerIn: parent
            color: colors.gammaOff
            text: "Szczegóły nagrania"
            font.pointSize: win.text_large
            }
        }
        
        Row { id: fileDetails
            anchors.top: label.bottom; anchors.horizontalCenter: label.horizontalCenter
            Text { id: fileLabel
                width: 1.5 * win.small_button; height: win.small_button
                text: "Plik:"
                color: colors.gammaOff
                font.pointSize: win.text_medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Button{ id: recordname
                width: mainArea.width - 4 * mainArea.border.width - fileLabel.width
                height: win.small_button
                border.width: 0; radius: 0
                titleText: "(podaj tytuł nagrania)"
                titleSize: win.text_small
                onClicked: strings.getString()
            }
        }

        Row{ 
            anchors.top: fileDetails.bottom; anchors.horizontalCenter: label.horizontalCenter
            Text { id: recordPrompt
                width: 1.7 * win.medium_button; height: win.medium_button
                text: "Nagrywać?"
                color: colors.gammaOff
                font.pointSize: win.text_medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Switch{ id: buttonYes
                width: 1.5 * win.medium_button; height: win.medium_button
                radius: 0; border.width: 0
                titleText: "TAK"; titleSize: win.text_medium
                onEnabled: {
                    prompt(false)
                    if (record != "") //proceed only if record name given
                    {
                        buttonNo.disable();
                        recording( true );
                    }
                    else
                    {
                        active = false; 
                        state = "off";
                        recordname.state = "pressed"; //draw attetion to mising data
                    }
                }
            }
            Switch{ id: buttonNo
                width: 1.5 * win.medium_button; height: win.medium_button
                radius: 0; border.width: 0
                titleText: "NIE"; titleSize: win.text_medium
                state: "on"; active: true
                onEnabled: {
                    prompt(false)
                    buttonYes.disable();
                    recording( false );
                    record = "";
                    recordname.titleText = "(podaj tytuł nagrania)";
                }
            }
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
        NumberAnimation { target: arm1; property: "width"; to: 2 * win.big_button; duration: 2.5 * win.speed}
        NumberAnimation { target: arm2; property: "height"; to: win.medium_button; duration: 0.7 * win.speed}
        NumberAnimation { target: mainArea; property: "opacity"; to: 1.0; duration: 3 * win.speed}
    }

    SequentialAnimation {
        id: promptAnimation
        running: false
        loops: Animation.Infinite
        ColorAnimation { target: recordPrompt; property: "color"; from: colors.gammaOff;  to: colors.betaPress; duration: 250 }
        ColorAnimation { target: recordPrompt; property: "color"; from: colors.betaPress; to: colors.gammaOff;  duration: 250 }
    }
} 
