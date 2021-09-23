import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import QtLocation 5.15
import QtQml 2.15


Window {
    id:window
    width: 500
    height: 1060
    visible: true
    title: qsTr("Hello World")
    property bool isFullScreen:false


    XmlListModel {
        id: xmlModel
        source: "channels.xml"
        query: "/channels/channel"

        XmlRole { name: "uid"; query: "uid/string()" }
        XmlRole { name: "icon"; query: "icon/string()" }
        XmlRole { name: "start"; query: "start/string()" }
        XmlRole { name: "end"; query: "start/string()" }
        XmlRole { name: "url"; query: "url/string()" }

     }

    GridLayout{
        id:grid
       // anchors.fill:parent
        width:parent.width
        height:parent.height
        //rows:2
       // columns:1
        rowSpacing: 5
        flow:GridLayout.TopToBottom
        property bool isLandscape:parent.width>parent.height
        rows:isLandscape?1:2
        columns:isLandscape ? 2 : 1

        onFlowChanged: {
            if(rows===2 && columns===1){
                flow=GridLayout.TopToBottom
                video.height=500
                video.width=300
            }
            else if(columns===2 && rows===1){
                flow=GridLayout.LeftToRight
                video.height=1060
                video.width=parent.width*0.5

            }
        }

        Rectangle{
            id:rect3
            color:'black'
            width:video.width
            height:75
            anchors.top:grid.top
            visible:isFullScreen?false:true
            //anchors.left:window.left
            //anchors.bottom:video.top

            Text{
                id:text2
                text:"Task 5"
                color:'white'
                font.pointSize: 16
                anchors.left:rect3.left
                x:10
                y:20


            }
            Text{
                id:clock
                anchors.right:rect3.right
                x:10
                y:20
                color:'white'
                font.pointSize: 16
            }

            Timer{
                id:timer
                running:true
                interval:500
                repeat:true


                onTriggered:{
                    var date=new Date()
                    clock.text=date.toLocaleTimeString(Qt.locale("en_US"), "hh:mm")
                }

            }

            Image{
                id:back_button
                width:50
                height:50
                anchors.right:clock.left
                x:10
                y:15
                source:'qrc:back-button.jpg'

                MouseArea{
                    id:mouse1
                    anchors.fill:parent

                    onClicked: {
                        Qt.quit()

                    }
                }
            }

            Image{
                id:search_button
                width:50
                height:50
                x:10
                y:15
                anchors.right:back_button.left
                source:'qrc:search.jpg'

                 Loader { id: pageLoader }

                MouseArea{
                    id:mouse2
                    anchors.fill:parent

                    //Za sada ne radi
                    onClicked: {
                        pageLoader.source = "empty_file.txt"

                    }
                }
            }


        }


        Video{
                 id:video
                 //width:500
                 //height:300
                 anchors.top:rect3.bottom
                 autoLoad: true
                 autoPlay: true
                 width:isFullScreen? window.width : 500
                 height:isFullScreen?window.height : 300
                 Layout.fillHeight: isFullScreen
                 Layout.fillWidth: isFullScreen


                 Image{
                     id:play_from_start_image
                     width:parent.width/5
                     height:parent.height/5
                     anchors.right:play_image.left
                     anchors.verticalCenter: parent.verticalCenter
                     source:'qrc:play-from-start.png'
                     opacity:timer3.running?1.0:0.0
                     Behavior on opacity {
                         PropertyAnimation { duration: 5000 }
                     }

                     Timer{
                         id:timer3
                         interval:5000
                         running: true
                  }

                     MouseArea{
                         anchors.fill:parent
                         onClicked:{
                             timer3.start()
                             video.seek(0)
                             video.play()
                         }
                     }




                 }

                 Image{
                     id:stop_image
                     width:parent.width/5-20
                     height:parent.height/5-20
                     anchors.left:play_image.right
                     anchors.verticalCenter: parent.verticalCenter
                     source:'qrc:stop-button.png'
                     opacity:timer4.running?1.0:0.0
                     Behavior on opacity {
                         PropertyAnimation { duration: 5000 }
                     }

                     Timer{
                         id:timer4
                         interval:5000
                         running:true
                  }


                       MouseArea{
                        anchors.fill:parent
                        onClicked:{
                            timer4.start()
                            video.pause()
                        }

                       }



                 }

                 Image{
                     id:play_image
                     width:parent.width/5
                     height:parent.height/5
                     anchors.centerIn: parent
                     source:'qrc:play.svg'
                     opacity:timer1.running?1.0:0.0
                     Behavior on opacity {
                         PropertyAnimation { duration: 5000 }
                     }

                     Timer{
                         id:timer1
                         interval:5000
                         running:true
                  }


                       MouseArea{
                        anchors.fill:parent
                        onClicked:{
                            if(video.playbackState===1){
                                  timer1.start()
                                  video.pause()
                                  play_image.source='qrc:play.svg'

                                }else if(video.playbackState===2){
                                  video.play()
                                  play_image.source='qrc:pause.svg'
                                  timer1.stop()


                               }
                          }
                       }

                   }

                 Image{
                     id:enter_exit_image
                     width:parent.width/5
                     height:parent.height/5
                     anchors.top:video.top
                     anchors.right:video.right
                     source: isFullScreen? 'qrc:enter-outline.svg':'qrc:exit-outline.svg'
                     opacity:timer2.running?1.0:0.0
                     Behavior on opacity {
                         PropertyAnimation { duration: 5000 }
                     }

                     Timer{
                         id:timer2
                         interval:5000
                         running:true
                     }


                     MouseArea{
                        anchors.fill:parent

                          onClicked:{
                              timer2.start()
                              isFullScreen=!isFullScreen
                              //timer2.stop()

                          }


                      }

                 }

        }

        ListView{
            id:list
            model:xmlModel
            width:video.width
            height:parent.height-video.height
            //pokusaj da 'zalijepim' listView za gornji rectangle kada je aktivan landscape mod:
            //anchors:isLandscape?rect3.bottom:video.bottom //anchors read only property error
            anchors.top:video.bottom
            anchors.left:grid.left
            spacing:2
            Layout.fillHeight:true
            focus:true
            keyNavigationEnabled: true
            keyNavigationWraps:true
            visible:isFullScreen?false:true


            delegate:
                Rectangle{
                    id:rect1
                    width:75
                    height:75
                    color:"#333333"


                    onFocusChanged:{
                        if(focus){
                          console.log("fokus")
                          list.currentIndex=index
                          video.source=url
                          video.play()
                        }
                    }


                    Image{
                        id:img1
                        anchors.centerIn: parent
                        source:icon
                    }


                    Rectangle{
                        id:rect2
                        width:video.width-rect1.width
                        height:rect1.height
                        anchors.left:rect1.right
                        //color:"#333333"
                        border.color: "darkgray"
                        color:focus?"red":"#333333"

                        //workaround:should be below rect2:
                        onFocusChanged:{
                            if(focus){
                              console.log("fokus")
                              list.currentIndex=index
                              video.source=url
                              video.play()
                            }
                        }

                        Text{
                            id:text1
                            text:uid
                            color:'white'
                            font.pointSize: 14
                            x:15
                            y:17
                            anchors.left: parent

                        }


                    MouseArea{
                        id:mouse
                        anchors.fill:parent

                        onClicked:{
                            list.currentIndex=index
                            //console.log("klik"+ url)
                            video.source=url
                            video.play()
                            //console.log(video.playbackState)
                        }
                    }
                 }
              }
           }
         }
      }
