import QtQuick 2.5

Item { id: panel
    
    property int handleY: 0
    
    state: "hidden"
    
    function show() { state = "shown"; }
    function hide() { 
        state = "hidden";
    }
    
                
    states:
    [
        State { name: "hidden";  
                PropertyChanges { target: panel; visible: false} },
        State { name: "shown";  
                PropertyChanges { target: panel; visible: true} }
    ]
} 
