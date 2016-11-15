import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
Rectangle { id: panel
    
    property string title: "Title:"
    property alias value: field.text
    
    signal started
    signal stopped
    signal inputChanged

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

        TextField { id: field
            y: panel.border.width;
            height: panel.height - 2 * y;
            width: 3 * panel.width / 4 - y;
            style: TextFieldStyle {
                textColor: colors.gammaHover
                background: Rectangle {
                    border.width: 0
                    radius:0
                    color: colors.betaHover
                }
            }
            font.pointSize: win.text_small
            onEditingFinished: panel.inputChanged()
        }
    }
}
