import QtQuick 2.5
import Qt.labs.platform 1.0
import Qt.labs.settings 1.0
import  "../../../"
import '../../../Silabas.js' as Sil
Item {
    id: r
    width: app.an
    height: app.al
    property string sectionName: 'ritme-001'
    property int area: 0

    property bool playing: false
    property string uSilPlayed: ''
    property int uYContent: 0
    property bool showFailTools: false
    property string currentFile: ''

    onCurrentFileChanged: {
        ss.uFileName=currentFile
        //var m0=
        //txtCurrenFile.text=currentFile
    }

    Settings{
        id: ss
        category: 'cf-'+app.moduleName+'-'+r.sectionName
        property string uFileName
        Component.onCompleted: {
            r.currentFile=uFileName
            loadData(r.currentFile)
        }
    }

    Column{
        id: colCentral
        spacing: app.fs*0.25
        anchors.centerIn: r
        width: gridSil.width
        height: r.height-app.fs*2
        opacity: 0.0
        Behavior on opacity{NumberAnimation{duration:250}}
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
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
            UText{
                id: txtCurrenFile
                font.pixelSize: app.fs
                color:app.c1
                anchors.verticalCenter: parent.verticalCenter
                text: r.currentFile===''?'Sin tìtulo':currentFile.split('/')[currentFile.split('/').length-1]
            }
            Item{width: app.fs*2; height: 1}
            BotonUX{
                id: botVerEditor
                text: 'Editor'
                fontColor: app.c2
                fontSize: app.fs*0.5
                backgroudColor: app.c3
                speed: 100
                clip: false
                opacity: r.area===0?1.0:0.65
                onClicked: {
                    r.area=0
                }
                anchors.verticalCenter: parent.verticalCenter
            }
            BotonUX{
                id: botVerDrumpad
                text: 'Drumpad'
                fontSize: app.fs*0.5
                fontColor: app.c2
                backgroudColor: app.c3
                speed: 100
                clip: false
                opacity: r.area===1?1.0:0.65
                onClicked: {
                    r.area=1
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Column{
            width: parent.width
            spacing: app.fs*0.5
            Item{
                width: parent.width
                height: app.fs*14
                clip: true
                visible: r.area===0
                Marco{padding: 1}
                TextInput{
                    id: tiEditor
                    width: parent.width-app.fs
                    height: gridSil.height
                    font.pixelSize: app.fs
                    color: app.c1
                    anchors.centerIn: parent
                    wrapMode: Text.WordWrap
                    validator: RegExpValidator { regExp: /((((((([0-9]){3})|(([0-9]){4})):{1}(((([0-9]){1})|(([0-9]){2}))))\*{1}(((([0-9]){1})|(([0-9]){2}))) )?)(((([0-9]){2} )+)|((([0-9]){1} )?)))+/}
                    property var currentSequencer: seq1
                    Keys.onReturnPressed: currentSequencer.sequences=text
                }
            }
            Grid{
                id: gridSil
                columns: 10
                spacing: app.fs*0.1
                width:  (columns*widthSil)+(spacing*(columns-1))
                anchors.horizontalCenter: parent.horizontalCenter
                visible: r.area===1
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
                            numero: index+1
                            clip: false
                            width: parent.width
                            height: parent.height
                            onClicked: {
                                for(var i=0;i<colSeqs.children.length;i++){
                                    if(colSeqs.children[i].tiseq.focus){
                                        colSeqs.children[i].tiseq.insert(colSeqs.children[i].tiseq.cursorPosition, numero+' ')
                                        break
                                    }
                                }
                            }
                            Component.onCompleted: {
                                if((''+modelData).indexOf('silencio')>=0||modelData===''){
                                    parent.visible=false
                                }
                            }
                        }
                    }
                }
            }
            Row{
                width: parent.width
                spacing: app.fs*0.5
                Column{
                    id: colSeqs
                    width: parent.width-colControls.width-app.fs*0.5
                    Sequencer{
                        id: seq1;
                        playing: r.playing;
                        objectName: 's1';
                        onSelected: {
                            console.log('1111')
                            tiEditor.currentSequencer=seq1
                            tiEditor.text=(''+sequences).replace(/  /g, ' ')
                            console.log('2222')
                        }
                    }
                    Sequencer{
                        id: seq2;
                        playing: r.playing;
                        objectName: 's2';
                        onSelected: {
                            tiEditor.currentSequencer=seq2;
                            tiEditor.text=sequences
                        }
                    }
                    Sequencer{
                        id: seq3;
                        playing: r.playing;
                        objectName: 's3';
                        onSelected:{
                            tiEditor.currentSequencer=seq3;
                            tiEditor.text=sequences}
                    }
                }
                Column{
                    id: colControls
                    width: app.fs*6
                    Boton{
                        t:r.playing?'\uf04d':'\uf04b'
                        w:app.fs
                        h:w
                        c: app.c1
                        b: app.c3
                        d: r.playing?'Stop':'Play'
                        tp: 0
                        onClicking: {
                            r.playing=!r.playing
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
            //console.log('!Cant Sils: '+Sil.silabas.length)
            if(app.arraySilabas.length!==0){
                repSil.model=app.arraySilabas
                stop()
                for(var i=0;i<r.teclado.length;i++){
                    var b=gridSil.children[i].children[0]
                    b.t=r.teclado[i]
                    //console.log('--->'+b.t)
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
                colCentral.opacity=1.0
            }
        }
        UText{
            id: txtLoadingSils
            text: 'Cargando audios..'
            color: app.c2
            font.pixelSize: app.fs
            anchors.centerIn: parent
        }
    }
    property var teclado: ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'ñ', 'z', 'x', 'c', 'v', 'n', 'm']
    Component.onCompleted: {
        controles.visible=false
        app.keyEventObjectReceiver=r
    }
    FileDialog {
        id: fileDialogSave
        currentFile: r.currentFile
        fileMode: FileDialog.SaveFile
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: {
            var fs=''+fileDialogSave.files[0]
            var fs2=fs.replace('file://', '')
            r.currentFile=fs2
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
        currentFile: r.currentFile
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: {
            var fs=''+fileDialogOpen.files[0]
            var fs2=fs.replace('file://', '')
            loadData(fs2)
        }
    }
    function loadData(f){
        var j=unik.getFile(f)
        var json
        try {
            json=JSON.parse(j);
            r.currentFile=f
        } catch(e) {
            console.log(e)

        }
        for(var i=0;i<Object.keys(json).length;i++){
            colSeqs.children[i].sequences=json['item'+i]
        }
    }
}
