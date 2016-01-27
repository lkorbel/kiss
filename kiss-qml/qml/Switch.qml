import QtQuick 2.0

Rectangle { id: button
    
    property string titleText: ""
    property real titleSize: 0
    property string iconSource: ""
    property bool active: false
    
    signal enabled
    signal disabled
    function enable() { 
        active = true;
        state = "on";
        button.enabled();
    }
    function disable() { 
        active = false;
        state = "off";
        button.disabled();
    }
    
    state: "off"
    border.width: win.button_border
    radius: win.button_radius
    
    Image{ id: icon
        anchors.left: parent.left; anchors.top: parent.top
        anchors.margins: win.spacing
        height: parent.height - 2 * anchors.margins
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: iconSource
    }
    Item{
        anchors.left: icon.right; anchors.top: parent.top
        anchors.margins: win.spacing
        height: icon.height; width: parent.width - icon.width - 2 * anchors.margins
        Text { id: title
            anchors.centerIn: parent
            text: button.titleText
            font.pointSize: button.titleSize
        }
    }
    
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:  { button.state = "hovered"; }
        onExited:   { button.active ? button.state = "on" : button.state = "off" }
        onPressed:  { button.state = "pressed" }
        onReleased: { button.active = true; button.state = "on"; button.enabled()}
    }
    
    states: 
    [
        State { name: "off"; 
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
        },
        State { name: "on"; 
                PropertyChanges { target: button; color: colors.betaOn} 
                PropertyChanges { target: button; border.color: colors.alphaOn}
                PropertyChanges { target: title; color: colors.gammaOn} 
        }
    ]
    
    transitions:
        Transition {
            to: "*"
            ColorAnimation { target: button; duration: 100}
            ColorAnimation { target: button.border; duration: 100}
            ColorAnimation { target: title; duration: 100}
        }
}
