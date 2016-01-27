import QtQuick 2.0

Rectangle { id: dialog
    property int elements: 0
    property int elementFrom: 0
    property int elementSize: 0
    
    signal choosed( int value)
    function getNumber( from, to ) { 
        dialog.elementFrom = from;
        dialog.elements = to - from + 1;
        dialog.state = "query";
        grid.rows = Math.floor((dialog.height - 3 * win.spacing) / (dialog.elementSize + win.spacing));
        grid.columns = Math.floor((dialog.width - 3 * win.spacing)  / (dialog.elementSize + win.spacing));
        grid.x = (dialog.width - grid.columns * (dialog.elementSize + win.spacing)) / 2;
        grid.y = (dialog.height - Math.ceil( dialog.elements / grid.columns) * (dialog.elementSize + win.spacing)) / 2;
        //console.log("w " + dialog.width + ", h " + dialog.height + ", rows " + grid.rows + ", cols" + grid.columns + ", x" + grid.x + ", y" + grid.y + "space" + (dialog.elementSize + win.spacing));
    }
    
    state: "suspend"
    radius: win.button_radius
    color: colors.alphaOff
    
    Grid { id: grid
        spacing: win.spacing 
        Repeater { 
            model: dialog.elements
            Button{
                width: elementSize; height: elementSize; radius: win.button_radius
                border.width: 0
                titleText: elementFrom + index
                titleSize: win.text_small
                onClicked: {
                    dialog.state = "suspend"
                    dialog.choosed( elementFrom + index )
                }
            }
        }
    }
    
    states:
    [
        State { name: "suspend"; PropertyChanges{ target: dialog; visible: false }},
        State { name: "query";   PropertyChanges{ target: dialog; visible: true }}
    ]
}