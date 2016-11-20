import QtQuick 2.5
import QtQuick.Controls 1.4
import lukhaz.theo.Kiss 1.0
import "components" as UI

ApplicationWindow { id:win
    property int spacing: 10
    property int speed: 100
    property int button_radius: 10
    property int button_border: 5
    property int big_button: (height-6*spacing)/5
    property int medium_button: 0.7 * big_button
    property int small_button: 0.5 * big_button
    property real text_large: 20
    property real text_medium: 14
    property real text_small: 11
    color: "#9faaaaaa"
    width: 8 * 150
    height: 5 * 150
    visible: true
    title: "Kingdom Hall Sound System"
    
    Colors { id: colors }
    Kiss { id: kiss }
    Item { id: internal
        property double panelOffsetY: main_panel.y + main_panel.height
    }
    MainPanel { id: main_panel 
        x: 3 * win.spacing
        PropertyAnimation on y { 
            from: - win.big_button
            to: win.spacing; duration: 700 
        }      
        height: win.big_button
        width: 8 * win.big_button
    }

    UI.Switch { id: micro
        PropertyAnimation on x { 
            from: - win.big_button
            to: 4 * win.spacing; duration: 550 }
        y: 2 * win.spacing + win.big_button
        width: 4 * win.big_button
        height: win.big_button
        iconSource: "../../img/micro.svg"
        titleText: qsTr("Nagrywanie programu")
        titleSize: win.text_large
        onSwitchEnabled: {
            music.disable()
            movie.disable()
            settings.disable()
            micro_panel.show()
        }
        onSwitchDisabled: micro_panel.hide()
    }
    MicroPanel { id: micro_panel 
        x: micro.x + micro.width
        y: internal.panelOffsetY
        width: main_panel.width - micro.width
        height: parent.height - main_panel.height - 6 * win.spacing
        handleY: micro.y + micro.height/2 - internal.panelOffsetY
        onRecording: {
            if (active) {
                kiss.startRecording( record )
                micro.titleText = qsTr("Trwa nagrywanie")
            } else {
                kiss.stopRecording()
                micro.titleText = qsTr("Nagrywanie programu")
            }
        }
    }
    
    UI.Switch { id: music
        PropertyAnimation on x { 
            from: - win.big_button - win.small_button
            to: 4 * win.spacing; duration: 600 }
        y: 3 * win.spacing + 2 * win.big_button
        width: 3 * win.big_button  
        height: win.big_button
        iconSource: "../../img/music.svg"
        titleText: qsTr("Muzyka")
        titleSize: win.text_large
        onSwitchEnabled: {
            micro.disable(); 
            movie.disable()
            settings.disable()
            music_panel.show() 
        }
        onSwitchDisabled: music_panel.hide()
    }
    MusicPanel { id: music_panel 
        x: music.x + music.width
        y: internal.panelOffsetY
        width: main_panel.width - music.width
        height: parent.height - main_panel.height - 6 * win.spacing
        handleY: music.y + music.height/2 - internal.panelOffsetY
        onRecordStartRequested: {
            micro.enable()
            micro_panel.prompt(true)
        }
        onRecordStopRequested: micro_panel.recording(false)
    }    
    
    UI.Switch { id: movie
        PropertyAnimation on x { 
            from: - win.big_button - 2 * win.small_button
            to:  4 * win.spacing; duration: 650 }
        y: 4 * win.spacing + 3 * win.big_button
        width: 3 * win.big_button  
        height: win.big_button
        iconSource: "../../img/movie.svg"
        titleText: "Filmy"
        titleSize: win.text_large
        onSwitchEnabled: {
            micro.disable() 
            music.disable()
            settings.disable()
            movie_panel.show()
        }
        onSwitchDisabled: movie_panel.hide()
    }
    MoviePanel { id: movie_panel
        x: movie.x + movie.width
        y: internal.panelOffsetY
        height: parent.height - main_panel.height - 6 * win.spacing
        handleY: movie.y + movie.height/2 - internal.panelOffsetY
    }
    
    UI.Switch { id: settings
        PropertyAnimation on x { 
            from: - win.big_button - 3 * win.small_button
            to: 4 * win.spacing; duration: 700 }
        y: 5 * win.spacing + 4 * win.big_button
        width: 3 * win.big_button  
        height: win.big_button
        iconSource: "../../img/settings.svg"
        titleText: qsTr("Ustawienia")
        titleSize: win.text_large
        onSwitchEnabled: {
            micro.disable()
            music.disable() 
            movie.disable()
            settings_panel.show()
        }
        onSwitchDisabled: settings_panel.hide()
    }
    SettingsPanel { id: settings_panel 
        x: settings.x + settings.width
        y: internal.panelOffsetY
        width: main_panel.width - settings.width
        height: parent.height - main_panel.height - 6 * win.spacing
        handleY: settings.y + settings.height / 2 - internal.panelOffsetY
    }

    //Dialogs
    UI.NumberDialog{ id: numbers
        anchors.centerIn:parent
        width: parent.width - 7 *win.spacing; height: parent.height - 7 * win.spacing
        elementSize: 0.4 * win.big_button
        onChoosed: music_panel.setSong( value );
    }
    UI.StringDialog{ id: strings
        anchors.centerIn:parent
        width: 4 * win.big_button; height: 2 * win.big_button
        onChoosed: micro_panel.setRecordName( value );
    }
}
