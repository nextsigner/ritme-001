import QtQuick 2.0
import QtQuick.Controls 2.0
import "../../.."

Item{
    id: r
    width: parent.width
    height: app.fs*1.2
    clip: true
    property bool playing: false
    property bool silence: false
    property alias tiseq: seq
    property alias sequences: seq.text
    property var arrayNums: []
    property var arrayIntervals: []
    signal selected
    onSequencesChanged: {
        //tr.stop()
        arrayNums=[]
        arrayIntervals=[]
        var m0=sequences.split(' ')
        for(var i=0;i<m0.length;i++){
            var o=m0[i].split(':')
            if(o.length===2){
                var ms=100
                if(parseInt(o[0])>=100){
                    ms=o[0]
                }
                tr.p=0
                tr.interval=ms
                if(o[1].indexOf('*')>0){
                    var m1=o[1].split('*')
                    for(var i2=0;i2<parseInt(m1[1]);i2++){
                        arrayNums.push(m1[0])
                        arrayIntervals.push(ms)
                    }
                }else{
                    arrayNums.push(o[1])
                    arrayIntervals.push(ms)
                }

            }
        }
        /*var s0=''+sequences.replace(/  /g, ' ').replace(/   /g, ' ')
       var cf='['+s0.substring(s0.length-1, s0.length)+']'
        //console.log(cf)
        if(s0.substring(s0.length-1, s0.length)===' '){
            s0=s0.substring(0, s0.length-2)
        }
        arrayNums=s0.split(' ')*/
    }
    Row{
        spacing: app.fs*0.5
        Text{
            id: seq
            width: r.width-bp.width-parent.spacing
            height: r.height-app.fs*0.1
            color: app.c2
            font.pixelSize: app.fs
            //validator: RegExpValidator { regExp: /([0-9]{1}[0-9]? )+/ }
            //focus: true
            /*onFocusChanged: {
                if(focus){
                    r.selected()
                }
            }*///r.focus=focus
            onTextChanged: {
                //c1.sequence=text
            }
            Keys.onReturnPressed: r.focus=true
            anchors.verticalCenter: parent.verticalCenter
            Marco{
                padding:app.fs*0.1
                Rectangle{
                    anchors.fill: parent
                    color: app.c1
                    opacity: 0.5
                    visible:!seq.focus
                }
                Rectangle{
                    id: ran
                    width: 0
                    height: parent.height
                    color: 'red'
                    SequentialAnimation{
                        id: anSeqNum
                        running: false

                        NumberAnimation {
                            target:ran
                            property: "width"
                            duration: tr.interval
                            easing.type: Easing.InOutQuad
                            from: ran.parent.width
                            to:0
                        }
                    }
                }
            }

        }
        Boton{
            id:bp
            t: '\uf026'
            w:app.fs
            h:w
            c: app.c1
            b: app.c3
            d: r.silence?'Sound':'Mute'
            tp: 1
            anchors.verticalCenter: parent.verticalCenter
            onClicking: {
                r.silence=!r.silence
            }
            Text{
                text: '<b>X</b>'
                font.pixelSize: parent.w*0.8
                color: 'red'
                anchors.centerIn: parent
                visible: r.silence
            }
        }
    }
    MouseArea{
        width: r.width-bp.width
        height: r.height
        anchors.centerIn: r
        onClicked: {
            r.selected()
        }
    }
    Timer{
        id: tr
        running: r.playing && !r.silence
        repeat: true
        interval: 160
        property int p: 0
        property int nextInterval: 0
        onTriggered: {
            if(tr.p<r.arrayNums.length-1){
                p++
            }else{
                p=0
            }
            var dp=''+r.arrayNums[p]
            tr.stop()
            tr.interval=parseInt(r.arrayIntervals[p])
            tr.start()
            var b
            try {
                b=gridSil.children[parseInt(dp-1)].children[0]
            } catch(e) {
                return
            }
            if(b){
                //anSeqNum.start()
                b.play()
            }
            /*tr.interval=nextInterval
            if(p>0){
                tr.nextInterval=parseInt(r.arrayIntervals[p])
            }*/

        }
    }
}
