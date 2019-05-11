import QtQuick 2.5
import  "../../../"
import '../../../Silabas.js' as Sil
Item {
    id: r
    width: app.an
    height: app.al
    property string uSilPlayed: ''
    property int uYContent: 0
    property bool showFailTools: false

    Column{
        spacing: app.fs
        anchors.centerIn: r
        width: flickableSetSil.width
        height: r.height-app.fs*2
        Sequencer{}
        Sequencer{}
        Sequencer{}
        Flickable{
            id: flickableSetSil
            width: gridSil.width
            height: gridSil.height+app.fs*2
            //anchors.centerIn: r
            contentWidth: gridSil.width
            contentHeight: gridSil.height
            Marco{}
            Grid{
                id: gridSil
                columns: 10
                spacing: app.fs*0.1
                width:  (columns*widthSil)+(spacing*(columns-1))
                anchors.horizontalCenter: parent.horizontalCenter
                property int widthSil: app.fs*3
                Repeater{
                    id: repSil
                    Item{
                        width: gridSil.widthSil
                        height: width
                        property string nom: '-'+modelData
                        ButtonDp{
                            anchors.centerIn: parent
                            text: modelData
                            //fontColor: parseInt(app.jsonSilabas[modelData][0])===-1?'red':app.c2
                            //backgroudColor: parseInt(app.jsonSilabas[modelData][0])===-1?'yellow':app.c3
                            numero: index
                            clip: false
                            width: parent.width
                            height: parent.height
                            Component.onCompleted: {
                                if((''+modelData).indexOf('silencio')>=0||modelData===''){
                                    parent.visible=false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Timer{
        id: tLoadSils
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            console.log('!Cant Sils: '+Sil.silabas.length)
            if(app.arraySilabas.length!==0){
                repSil.model=app.arraySilabas
                stop()
                for(var i=0;i<r.teclado.length;i++){
                    var b=gridSil.children[i].children[0]
                    b.t=r.teclado[i]
                    console.log('--->'+b.t)
                }
            }
        }
    }
    Timer{
        id: tYContent
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            flickableSetSil.contentY=r.uYContent
        }
    }
    Rectangle{
        width: children[0].contentWidth+app.fs
        height: app.fs*3
        anchors.centerIn: r
        opacity: !tLoadSils.running?0.0:1.0
        color: app.c3
        radius: app.fs*0.5
        border.width: 2
        border.color: app.c2
        Behavior on opacity{NumberAnimation{duration:2000}}
        onOpacityChanged: {
            if(opacity===0.0){
                tYContent.start()
            }
        }
        Text{
            id: txtLoadingSils
            text: 'Cargando audios..'
            color: app.c2
            font.pixelSize: app.fs
            anchors.centerIn: parent
        }
    }
    BotonUX{
        id: botPlay
        text: 'Hablar'
        fontColor: app.c2
        backgroudColor: app.c3
        speed: 100
        clip: false
        onClick: {
            ms.arrayWord=['yo', 'soy', '|', 'el', '|', 'rro', 'bot', '|', 'con', '|', 'la', '|', 'voz', '|', 'de', '|', 'rri', 'car', 'do']
            ms.playSil(ms.arrayWord[0])
        }
        visible:false
        anchors.verticalCenter: r.verticalCenter
    }

    property var teclado: ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'ñ', 'z', 'x', 'c', 'v', 'n', 'm']
    Component.onCompleted: {
        controles.visible=false
        app.keyEventObjectReceiver=r

    }
    function event(event){
        var pos=teclado.indexOf(event.text)
        //console.log('Evento: '+event.text+' pos='+pos)
        //if (event.text==='q'){
            //var b=gridSil.children[pos].children[0]
            //b.play()
        //}
    }
}
