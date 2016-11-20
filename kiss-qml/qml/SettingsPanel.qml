import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "components" as UI

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
        x: arm2.x - (width - arm2.width) / 6
        y: arm2.y - valuesBox.height
        width: 4 * win.big_button;
        height: 2 * win.big_button
        radius: win.button_radius
        border.width: win.button_border
        color: colors.betaOff
        border.color: colors.alphaOff
        ScrollView {
            anchors.fill: parent
            anchors.margins: valuesBox.border.width
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        Column {
            //anchors.fill: parent
            //anchors.margins: panel.border.width
            spacing: panel.border.width
            UI.TitledInput{ id: set1
                width: valuesBox.width - 6 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: qsTr("Katalog z pieśniami:")
                value: kiss.songsPath
                onInputChanged: kiss.songsPath = set1.value
            }
            UI.TitledNumberBox{ id: set4
                width: valuesBox.width - 6 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: qsTr("Ilość pieśni:")
                value: kiss.songsCount
                onInputChanged: kiss.songsCount = set4.value
            }
            UI.TitledInput{ id: set2
                width: valuesBox.width - 6 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: qsTr("Katalog na nagrania:")
                value: kiss.recordsPath
                onInputChanged: kiss.recordsPath = set2.value
            }
            UI.TitledInput{ id: set3
                width: valuesBox.width - 6 * valuesBox.border.width
                height: win.small_button
                radius: 0; border.width: 0
                title: qsTr("Źródło nagrywania:")
                value: kiss.recordInput
                onInputChanged: kiss.recordInput = set3.value
            }
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
    UI.Button{
        x: arm3.x - (width-arm3.width) / 2
        y: arm3.y + arm3.height
        width: 1.5 * win.small_button
        height: win.small_button
        titleText: "Wczytaj"
        titleSize: 0.8 * win.text_small
        onClicked: kiss.loadSettings()
    }
    UI.Button{
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
