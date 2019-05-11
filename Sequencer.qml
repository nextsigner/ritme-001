import QtQuick 2.0
import QtQuick.Controls 2.0
import "../../.."

Rectangle {
    id: r
    width: parent.width
    height: app.fs*1.2
    color: app.c3
    border.width: 2
    border.color: app.c1
    property alias sequences: seq.text
    property var arrayNums: []
    onSequencesChanged: {
        var s0=''+sequences.replace(/  /g, ' ').replace(/   /g, ' ')
       var cf='['+s0.substring(s0.length-1, s0.length)+']'
        console.log(cf)
        if(s0.substring(s0.length-1, s0.length)===' '){
            s0=s0.substring(0, s0.length-2)
        }
        arrayNums=s0.split(' ')
    }
    Row{
        spacing: app.fs*0.5
        TextInput{
            id: seq
            width: r.width-bp.width-parent.spacing
            height: r.height-app.fs*0.1
            color: app.c2
            font.pixelSize: app.fs
            //validator: RegExpValidator { regExp: /([0-9]{1}[0-9]? )+/ }
            onTextChanged: {
                //c1.sequence=text
            }
            Keys.onReturnPressed: r.focus=true
        }
        BotonUX{
            id:bp
            text: tr.running?'Stop':'Play'
            fs: app.fs*0.5
            anchors.verticalCenter: parent.verticalCenter
            onClick: {
                tr.running=!tr.running
            }
        }
    }
    Timer{
        id: tr
        running: false
        repeat: true
        interval: 160
        property int p: 0
        onTriggered: {
            if(tr.p<r.arrayNums.length-1){
                p++
            }else{
                p=0
            }
            var dp=parseInt(r.arrayNums[p])
            var b=gridSil.children[dp].children[0]
            if(b){
                b.play()
            }

        }
    }
}
