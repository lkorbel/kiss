import QtQuick 2.5
import "components" as UI

Rectangle { id: panel
    
    property bool quering : false
    
    signal started
    signal stopped
    

    radius: win.button_radius
    border.width: win.button_border
    border.color: colors.alphaOff
    color: colors.betaOff
    
    Row { x: panel.border.width
        UI.Switch { id: activator
            y: panel.border.width;
            height: panel.height - 2 * y; width: panel.width / 2 - y; 
            border.width: 0
            radius:0
            titleText: title
            titleSize: win.text_small
            onSwitchEnabled:  {
                if (value != "???") 
                    panel.started()
                else
                {
                    active = false; 
                    state = "off";
                    valuator.state = "pressed"; //give user hint where to click
                }
            }
            onSwitchDisabled: panel.stopped()
        }
        UI.Button { id: valuator
            y: panel.border.width
            height: panel.height - 2 * y; width: panel.width / 2 - y;
            border.width: 0
            radius:0
            titleText: value
            titleSize: win.text_small
            onClicked: {
                panel.quering = true; 
                numbers.getNumber( 1, kiss.songsCount);
            }
        }
    }
}
