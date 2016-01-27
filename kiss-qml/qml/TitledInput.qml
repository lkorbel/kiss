import QtQuick 2.0

Rectangle { id: panel
    
    property string title: "Title:"
    property string value: "???"
    property bool quering : false
    
    signal started
    signal stopped
    
    function setValue( newValue) {
        if (quering == true)
        {
            value = newValue;
            quering = false;
        }
    }
    function stop() {
        activator.disable();
    }
    
    radius: win.button_radius
    border.width: win.button_border
    border.color: colors.alphaOff
    color: colors.betaOff
    
    Row { x: panel.border.width
        Rectangle { 
            y: panel.border.width;
            height: panel.height - 2 * y; width: panel.width / 4 - y; 
            border.width: 0
            radius:0
            color: colors.betaOff
            Text{
                anchors.centerIn: parent
                verticalAlignment: TextInput.AlignVCenter
                text: title
                font.pointSize: win.text_small
                color: colors.gammaOff
            }
            
        }
        Rectangle { 
            y: panel.border.width;
            height: panel.height - 2 * y; width: 3 * panel.width / 4 - y; 
            border.width: 0
            radius:0
            color: colors.betaHover
            TextInput{
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
                text: value
                font.pointSize: win.text_small
                color: colors.gammaHover
            }
        }
    }
}
