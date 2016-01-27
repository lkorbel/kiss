import QtQuick 2.0

Rectangle { id: button
    property string titleText: ""
    property int titleSize: win.text_small
    property string iconSource: ""
    state: "normal"
    signal clicked
    
    gradient: normalGradient

    Image{ id: icon
        anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 10
        height: parent.height - 2 * anchors.margins
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: iconSource
    }
    Text { id: title
        anchors.left: icon.right; anchors.top: parent.top; anchors.margins: 10
        height: icon.height
        text: titleText
        font.pointSize: titleSize
        color: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        state: "normal"
        states: 
        [
        State { name: "normal";PropertyChanges { target: title; color: "#29405c"} },
        State { name: "hover"; PropertyChanges { target: title; color: "#76a2d8"} },
        State { name: "select";PropertyChanges { target: title; color: "#96c2f8"} }
        ]
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:  { title.state = "hover"; }
        onExited:   { title.state = "normal"; }
        onPressed:  { title.state = "select"; button.state = "pressed" }
        onReleased: { title.state = "normal"; button.state = "normal"; button.clicked() }
    }
    
    Gradient{ id: normalGradient
        GradientStop{ position: 0.0; color: "#19304c"}
        GradientStop{ position: 0.5; color: "#96c2f8"}
        GradientStop{ position: 1.0; color: "#19304c"}
    }
    Gradient{ id: pressedGradient
        GradientStop{ position: 0.0; color: "#19304c"}
        GradientStop{ position: 0.2; color: "#96c2f8"}
        GradientStop{ position: 0.5; color: "#6692c8"}
        GradientStop{ position: 0.8; color: "#96c2f8"}
        GradientStop{ position: 1.0; color: "#19304c"}    
    }
    states: 
        [
        State { name: "normal";PropertyChanges { target: button; gradient: normalGradient } },
        State { name: "pressed";PropertyChanges { target: button; gradient: pressedGradient } }
        ]
}
