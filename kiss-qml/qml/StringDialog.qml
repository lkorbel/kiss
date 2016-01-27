import QtQuick 2.0

Rectangle { id: dialog
    
    signal choosed( string value)
    function getString() { 
        state = "query";
    }
    
    state: "suspend"
    radius: win.button_radius
    color: colors.alphaOff
    
    Rectangle{ id: inputRect
        x: win.spacing; y: win.spacing
        width: parent.width - 2*x
        height: win.medium_button
        radius: win.button_radius
        color: colors.betaOff
        
        TextInput{ id: valuator
            x: win.button_border; y: win.button_border
            width: parent.width - 2*x
            height: parent.height -2*y
            font.pointSize: win.text_medium
            verticalAlignment: TextInput.AlignVCenter
            color: colors.gammaOff
            text: kiss.generateRecordName()
        }
    }
    
    Row{
        anchors.horizontalCenter: inputRect.horizontalCenter
        anchors.top: inputRect.bottom; anchors.topMargin: win.spacing
        
        Button{ 
            width: 2 * win.small_button; height: win.small_button
            radius: win.button_radius; border.width: 0
            titleText: "Zapisz"
            titleSize: win.text_small
            onClicked: {
                dialog.state ="suspend";
                choosed( valuator.text );
            }
        }
        Button{ 
            width: 2 * win.small_button; height: win.small_button
            radius: win.button_radius; border.width: 0
            titleText: "Anuluj"
            titleSize: win.text_small
            onClicked: dialog.state ="suspend"
        }
    }
    
    states:
    [
        State { name: "suspend"; PropertyChanges{ target: dialog; visible: false }},
        State { name: "query";   PropertyChanges{ target: dialog; visible: true }}
    ]
}
