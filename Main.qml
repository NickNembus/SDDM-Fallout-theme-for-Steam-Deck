/***************************************************************************
 * This config was meant specifically for the Steam Deck,
 *that being the case you will have to change certain things in the
 *code to make it more functional for your use case.
 *Things changed for the steam deck include: custom video size settings,
 *custom OSK settings, custom focus settings.
 *There's a custom background image for the login stuff and you will
 *need and your own custom video to play as the looping background.
 *I included the warning info below since it was included in the file.
 *you can test your theme out using the command:
 *sddm-greeter --test-mode --theme /usr/share/sddm/themes/fallout3/
 ***************************************************************************/
/***************************************************************************
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 * OR OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/


import QtMultimedia 5.13
import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }

        function onInformationMessage(message) {
            errorMessage.color = "red"
            errorMessage.text = message
        }
    }

    MediaPlayer {
        id: videoPlayer
        source: "file:///usr/share/sddm/themes/fallout3/fallout3titlescreen.mp4"
        autoPlay: true
        muted: true
        loops: -1
    }

    VideoOutput {
        anchors.fill: parent
        source: videoPlayer
        fillMode: VideoOutput.Stretch
    }


    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Clock {
            id: clock
            anchors.margins: 40
            anchors.top: parent.top; anchors.right: parent.right
            anchors.topMargin: 40
            color: "#eaf5c4"

            timeFont {
                family: "Consolas"
                bold: true  // Make the font bold
                pixelSize: 90  // Adjust the font size as desired
            }

            dateFont {
                family: "Lucida Console"
                bold: true  // Make the font bold
                pixelSize: 30  // Adjust the font size as desired
            }
        }



        Image {
            id: rectangle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: Math.max(370, mainColumn.implicitWidth + 50)
            height: Math.max(320, mainColumn.implicitHeight + 50)
            source: "loginterminalc.png"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        width: parent.width
                        text: textConstants.userName
                        color: "#88FF88"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width; height: 30
                        text: userModel.lastUser
                        textColor: "#88FF88"
                        color: "transparent"
                        font.pixelSize: 14

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblPassword
                        width: parent.width
                        text: textConstants.password
                        color: "#88FF88"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width; height: 30
                        font.pixelSize: 14
                        textColor: "#88FF88"
                        color: "transparent"

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 4
                    width: parent.width / 2

                    Column {
                        width: parent.width * 1.3
                        spacing: 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            width: parent.width
                            text: textConstants.session
                            color: "#88FF88"
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            width: parent.width; height: 30
                            font.pixelSize: 14
                            color: "transparent"
                            arrowIcon: "angle-down.png"
                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                        }
                    }

                    Column {
                        width: parent.width * 0.7
                        spacing: 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblLayout
                            width: parent.width
                            text: textConstants.layout
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                            color: "#88FF88"
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width; height: 30
                            font.pixelSize: 14
                            color: "transparent"
                            arrowIcon: "angle-down.png"

                            KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        font.pixelSize: 10
                        color: "#88FF88"
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: 73
                        height: 75
                        color: "transparent"
                        textColor: "green"
                        enabled: true

                        onClicked: sddm.login(name.text, password.text, sessionIndex)

                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton

                        anchors.top: parent.bottom
                        anchors.topMargin: -24

                        MouseArea {
                            width: parent.width
                            height: parent.height
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "transparent"
                            onExited: parent.color = "transparent"
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sddm.login(name.text, password.text, sessionIndex)
                        }
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: 73
                        height: 75
                        color: "transparent"
                        textColor: "yellow"
                        enabled: true

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name

                        anchors.top: parent.bottom
                        anchors.topMargin: -24

                        MouseArea {
                            width: parent.width
                            height: parent.height
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "transparent"
                            onExited: parent.color = "transparent"
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sddm.reboot()
                        }
                    }

                    Button {
                        id: shutdownButton
                        text: "Power"
                        width: 73
                        height: 75
                        color: "transparent"
                        textColor: "red"
                        enabled: true

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton

                        anchors.top: parent.bottom
                        anchors.topMargin: -24

                        MouseArea {
                            width: parent.width
                            height: parent.height
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "transparent"
                            onExited: parent.color = "transparent"
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sddm.powerOff()
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text === "")
            name.focus = false
            else
                keyboardTriggerButton.focus = false
    }
}
