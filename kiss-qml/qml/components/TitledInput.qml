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
    
    Row {
        x: panel.border.width
        spacing: win.spacing
        Rectangle { id: title_rect
            y: panel.border.width;
            height: panel.height - 2 * y
            width: 180
            border.width: 0
            radius:0
            color: colors.betaOff
            Text{
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignRight
                text: title
                font.pointSize: win.text_small
                color: colors.gammaOff
            }           
        }

        TextField { id: field
            y: panel.border.width;
            height: panel.height - 2 * y
            width: panel.width  - title_rect.width - 3 * panel.border.width
            style: TextFieldStyle {
                textColor: colors.gammaHover
                background: Rectangle {
                    border.width: 2
                    border.color: colors.gammaOff
                    radius: 4
                    color: colors.betaHover
                }
            }
            font.pointSize: win.text_small
            onEditingFinished: panel.inputChanged()
        }
    }
}
