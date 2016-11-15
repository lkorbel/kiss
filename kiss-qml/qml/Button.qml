import QtQuick 2.5

Rectangle { id: button
    property string titleText: ""
    property real titleSize: 0
    property string iconSource: ""
    state: "normal"
    signal clicked
    
    radius: win.button_radius
    border.width: win.button_border

    Text { id: title
        anchors.centerIn: parent
        text: titleText
        font.pointSize: titleSize
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:  { button.state = "hovered"; }
        onExited:   { button.state = "normal"; }
        onPressed:  { button.state = "pressed" }
        onReleased: { button.clicked() }
    }
    
    states: 
    [
        State { name: "normal"; 
                PropertyChanges { target: button; color: colors.betaOff}
                PropertyChanges { target: button; border.color: colors.alphaOff}
                PropertyChanges { target: title; color: colors.gammaOff}
        },
        State { name: "hovered";  
                PropertyChanges { target: button; color: colors.betaHover}
                PropertyChanges { target: button; border.color: colors.alphaHover}
                PropertyChanges { target: title; color: colors.gammaHover} 
        },
        State { name: "pressed"; 
                PropertyChanges { target: button; color: colors.betaPress}
                PropertyChanges { target: button; border.color: colors.alphaPress}
                PropertyChanges { target: title; color: colors.gammaPress} 
        }
    ]
    
    transitions:
        Transition {
            to: "*"
            ColorAnimation { target: button; duration: 200}
            ColorAnimation { target: button.border; duration: 200}
            ColorAnimation { target: title; duration: 200}
        }
}
