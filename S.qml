import QtQuick 2.5
import QtQuick.Dialogs 1.2
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
        spacing: app.fs*0.25
        anchors.centerIn: r
        width: flickableSetSil.width
        height: r.height-app.fs*2
        Row{
            spacing: app.fs
            Boton{
                w:app.fs
                h:w
                tp:3
                d:'Guardar'
                c:app.c3
                b:app.c2
                t:'\uf0c7'
                onClicking: {
                    fileDialogSave.visible=true
                }
            }
            Boton{
                w:app.fs
                h:w
                tp:3
                d:'Abrir'
                c:app.c3
                b:app.c2
                t:'\uf07c'
                onClicking: {
                    fileDialogOpen.visible=true
                }
            }

        }
        Column{
            id: colSeqs
            width: parent.width
            //height: app.fs*1.2*children.length
            Sequencer{}
            Sequencer{}
            Sequencer{}
        }
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
                        tipo: 'percusion'
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
    FileDialog {
        id: fileDialogSave
        selectExisting: false
        //currentFile: document.source
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        width: r.width
        height: r.height

        onAccepted: {
            var fs=''+fileDialogSave.fileUrls[0]
            var fs2=fs.replace('file://', '')
            //console.log('Save: '+fs2)
            var ext=fs2.substring(fs2.length-4, fs2.length)
            console.log('Save: '+ext)
            var nfn
            if(ext==='.json'){
                nfn=fs2
            }else{
                nfn=fs2+'.json'
            }
            var data=''
            data+='{'
            for(var i=0;i<colSeqs.children.length;i++){

                data+='"item'+i+'" : "'+colSeqs.children[i].sequences+'"'
                if(i!==colSeqs.children.length-1){
                    data+=','
                }
            }
            data+='}'
            unik.setFile(fs2, data)
        }
    }
    FileDialog {
        id: fileDialogOpen
        selectExisting: false
        //currentFile: document.source
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        width: r.width
        height: r.height
        onAccepted: {
            var fs=''+fileDialogOpen.fileUrls[0]
            var fs2=fs.replace('file://', '')
            //console.log('fs2:'+fs2)
            var j=unik.getFile(fs2)
            console.log('fs2:'+j)
            var json=JSON.parse(j)
            for(var i=0;i<Object.keys(json).length;i++){
                colSeqs.children[i].sequences=json['item'+i]
            }
        }
    }
    function event(event){
        //var pos=teclado.indexOf(event.text)
        //console.log('Evento: '+event.text+' pos='+pos)
        //if (event.text==='q'){
        //var b=gridSil.children[pos].children[0]
        //b.play()
        //}
    }
}
