import QtQuick 2.3

Rectangle { 
    radius: win.button_radius
    border.width: win.button_border
    border.color: colors.alphaOff
    color: colors.betaOff  

    Text {
        anchors.centerIn: parent
        font.pointSize: 32
        color: colors.alphaOff
        text: "Kingdom Hall Sound System"
    }
    Button {
        anchors.top: parent.top; anchors.right: parent.right
        anchors.margins: (parent.height - win.small_button) / 2
        titleText: "x"
        titleSize: win.text_large
        width: win.small_button
        height: win.small_button
        onClicked: Qt.quit()
    }
} 
