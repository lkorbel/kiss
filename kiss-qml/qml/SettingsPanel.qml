import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
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
        arm3.height = 0;
        arm4.height = 0;
        valuesBox.opacity = 0.0;
        loadButton.opacity = 0.0;
        saveButton.opacity = 0.0;
    }

    Rectangle{ id: arm1
        x: 0; y: handleY - height / 2
        width: 0 // 2 * win.big_button
        height: win.small_button / 2
        color: colors.alphaOff
    }
    Rectangle{ id: arm2
        x: arm1.width - width; y: arm1.y - arm2.height
        width: win.small_button / 2
        height: 0//win.big_button
        color: colors.alphaOff
    }
    
    Rectangle{ id: valuesBox
        opacity: 0.0
        x: arm2.x - (width - arm2.width) / 6
        y: arm2.y - valuesBox.height
        width: 4 * win.big_button;
        height: 2 * win.big_button
        radius: win.button_radius
        border.width: win.button_border
        color: colors.betaOff
        border.color: colors.alphaOff
        property double controlWidth: width - 2 * border.width - 3 * win.spacing
        ScrollView {
            anchors.fill: parent
            anchors.margins: valuesBox.border.width
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            Column {
                spacing: win.spacing
                UI.TitledInput{ id: set1
                    width: valuesBox.controlWidth
                    height: win.small_button
                    radius: 0; border.width: 0
                    title: qsTr("Katalog z pieśniami:")
                    value: kiss.songsPath
                    onInputChanged: kiss.songsPath = set1.value
                }
                UI.TitledNumberBox{ id: set4
                    width: valuesBox.controlWidth
                    height: win.small_button
                    radius: 0; border.width: 0
                    title: qsTr("Ilość pieśni:")
                    value: kiss.songsCount
                    onInputChanged: kiss.songsCount = set4.value
                }
                UI.TitledInput{ id: set2
                    width: valuesBox.controlWidth
                    height: win.small_button
                    radius: 0; border.width: 0
                    title: qsTr("Katalog na nagrania:")
                    value: kiss.recordsPath
                    onInputChanged: kiss.recordsPath = set2.value
                }
                UI.TitledInput{ id: set3
                    width: valuesBox.controlWidth
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
        height: 0 //0.6 * win.small_button
        color: colors.alphaOff
    } 
    Rectangle{ id: arm4
        x: valuesBox.x + 3 * valuesBox.width / 4; y: arm1.y - arm2.height
        width: win.small_button / 4
        height: 0 //win.small_button
        color: colors.alphaOff
    }
    UI.Button{ id: loadButton
        opacity: 0.0
        x: arm3.x - (width-arm3.width) / 2
        y: arm3.y + arm3.height
        width: 1.5 * win.small_button
        height: win.small_button
        titleText: "Wczytaj"
        titleSize: 0.8 * win.text_small
        onClicked: kiss.loadSettings()
    }
    UI.Button{ id: saveButton
        opacity: 0.0
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

    SequentialAnimation {
        id: showingSequence
        running: false
        NumberAnimation { target: arm1; property: "width"; to: 2 * win.big_button; duration: 2.5 * win.speed}
        NumberAnimation { target: arm2; property: "height"; to: win.medium_button; duration: 0.7 * win.speed}
        NumberAnimation { target: valuesBox; property: "opacity"; to: 1.0; duration: 3 * win.speed}
        NumberAnimation { target: arm3; property: "height"; to: 0.6 * win.small_button; duration: 0.5 * win.speed}
        NumberAnimation { target: loadButton; property: "opacity"; to: 1.0; duration: 3 * win.speed}
        NumberAnimation { target: arm4; property: "height"; to: win.small_button; duration: 0.6 * win.speed}
        NumberAnimation { target: saveButton; property: "opacity"; to: 1.0; duration: 3 * win.speed}
    }
} 
