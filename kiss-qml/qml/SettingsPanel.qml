import QtQuick 2.5

Rectangle { id: panel
    
    property int handleY: 0
    
    color: "#00000000"
    state: "hidden"
    
    function show() { state = "shown"; }
    function hide() { 
        state = "hidden";
    }
    
    Rectangle{ id: arm1
        x: 0; y: handleY - height / 2
        width: 2 * win.big_button
        height: win.small_button / 2
        color: colors.alphaOff
    }
    Rectangle{ id: arm2
        x: arm1.width - width; y: arm1.y - arm2.height
        width: win.small_button / 2
        height: win.big_button
        color: colors.alphaOff
    }
    
    Rectangle{ id: valuesBox
        x: arm2.x - (width - arm2.width) / 4
        y: arm2.y - valuesBox.height
        width: 4 * win.big_button; height: 2 * win.big_button
        radius: win.button_radius
        border.width: win.button_border
        color: colors.betaOff
        border.color: colors.alphaOff
        Column {
            anchors.fill: parent
            anchors.margins: parent.border.width
            spacing: parent.border.width
            TitledInput{ id: set1
                width: valuesBox.width - 2 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: "Songs path:"
                value: kiss.songsPath
                onInputChanged: kiss.songsPath = set1.value
            }
            TitledInput{ id: set2
                width: valuesBox.width - 2 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: "Records path:"
                value: kiss.recordsPath
                onInputChanged: kiss.recordsPath = set2.value
            }
            TitledInput{ id: set3
                width: valuesBox.width - 2 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: "Record input:"
                value: kiss.recordInput
                onInputChanged: kiss.recordInput = set3.value
            }
        }
    }
    Rectangle{ id: arm3
        x: valuesBox.x + valuesBox.width / 2; y: arm1.y - arm2.height
        width: win.small_button / 4
        height: 0.6 * win.small_button
        color: colors.alphaOff
    } 
    Rectangle{ id: arm4
        x: valuesBox.x + 3 * valuesBox.width / 4; y: arm1.y - arm2.height
        width: win.small_button / 4
        height: win.small_button
        color: colors.alphaOff
    }
    Button{
        x: arm3.x - (width-arm3.width) / 2
        y: arm3.y + arm3.height
        width: 1.5 * win.small_button
        height: win.small_button
        titleText: "Wczytaj"
        titleSize: 0.8 * win.text_small
        onClicked: kiss.loadSettings()
    }
    Button{
        x: arm4.x - (width-arm4.width) / 2
        y: arm4.y + arm4.height
        width: 1.5  * win.small_button
        height: win.small_button
        titleText: "Zapisz"
        titleSize: win.text_small
        onClicked: kiss.saveSettings()
    }
    
    states:
    [
        State { name: "hidden";  
                PropertyChanges { target: panel; visible: false} },
        State { name: "shown";  
                PropertyChanges { target: panel; visible: true} }
    ]
} 
