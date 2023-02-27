import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQuick.Layouts
import QtWebEngine
import Service.Article 1.0
import Data.Article 1.0
import "../MessageBox"

Item {
    id: contentpage

    layer.smooth: true

    Timer {
        id: timer

        interval: 100
        running: true
        repeat: false
        onTriggered: {

        }
    }
    ArticleService {
        id: articleService
    }

    Component.onCompleted: {
        // 获取文章列表
        articleService.getArticleList()
    }

    Connections {
        target: articleService

        function onArticleListChanged()
        {
            articledata.clear()
            for (var i = 0; i < articleService.articles().length; i++) {
                articledata.append(articleService.articles()[i])
            }
        }
    }

    ListModel {
        id: articledata
    }

    function isNewArticle()
    {
        return articledata.get(contentlist.currentIndex).aid == 0;
    }

    function hasNewArticle()
    {
        // 遍历列表，判断是否有新文章
        for (var i = 0; i < articledata.count; i++) {
            if (articledata.get(i).aid == 0)
                return true;
        }
        return false;
    }

    function nowArticleNum()
    {
        // 判断当前文章列表中是否有新文章，如果有则判断当前的文章是否是新文章，如果是则返回0, 如果不是则返回contentlist.currentIndex-1的值，如果没有则返回contentlist.currentIndex的值
        if (hasNewArticle())
        {
            if (isNewArticle())
                return 0;
            else
                return contentlist.currentIndex - 1;
            } else {
            return contentlist.currentIndex;
        }
    }

    Flow {
        anchors.fill: parent
        anchors.margins: 10
        layer.smooth: true
        antialiasing: true
        spacing: 15

        Text {
            width: parent.width
            height: 30
            color: "#8E99A5"
            text: qsTr("内容管理")
            font.styleName: "Demibold"
            font.pointSize: 25
        }

        // 左侧文章列表
        Rectangle {
            id: leftarea

            width: 350
            height: parent.height - 50
            layer.enabled: true
            radius: 10

            ListView {
                id: contentlist

                anchors.fill: parent
                anchors.margins: 8
                anchors.bottomMargin: 133
                spacing: 3
                model: articledata
                clip: true
                onOpacityChanged: {
                    if (opacity === 0)
                        contentlist.currentIndex = index
                }

                populate: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 200
                    }
                }

                add: Transition {
                    ParallelAnimation {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 200
                        }

                        NumberAnimation {
                            property: "y"
                            from: 0
                            duration: 200
                        }
                    }
                }

                displaced: Transition {
                    SpringAnimation {
                        property: "y"
                        spring: 3
                        damping: 0.1
                        epsilon: 0.25
                    }
                }

                remove: Transition {
                    SequentialAnimation {
                        NumberAnimation {
                            property: "y"
                            to: 0
                            duration: 120
                        }

                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: 120
                        }
                    }
                }

                delegate: Item {
                    height: 80
                    width: parent.width

                    Rectangle {
                        anchors.fill: parent
                        // 判断是否选中
                        color: contentlist.currentIndex === index ? "#F5F5F5" : "transparent"
                        radius: 10

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                contentlist.currentIndex = index
                                articleService.fetchArticle(aid)
                            }
                        }

                        // 底部分割线
                        Rectangle {
                            width: parent.width / 1.2
                            height: 1
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom

                            gradient: Gradient {
                                GradientStop {
                                    position: 0
                                    color: "#FFFFFF"
                                }

                                GradientStop {
                                    position: 0.5
                                    color: "#EEEEEE"
                                }

                                GradientStop {
                                    position: 1
                                    color: "#FFFFFF"
                                }
                            }
                        }

                        Item {
                            anchors.fill: parent

                            Image {
                                id: listimage

                                source:coverimg
                                width: 60
                                height: 60
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                            }

                            Text {
                                id: listname

                                y: 10
                                text: title
                                color: "#292826"
                                font.styleName: "Medium"
                                font.pointSize: 14
                                anchors.left: listimage.right
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: viewcount
                                width: 60
                                text: "阅读量：" + pageviews
                                color: "#8E99A5"
                                font.styleName: "Medium"
                                font.pointSize: 8
                                anchors.left: listimage.right
                                anchors.top: listname.bottom
                                anchors.leftMargin: 10
                            }

                            Text {
                                id: updatetimetext
                                text: qsTr("更新于")+Qt.formatDateTime(updatetime, "yyyy年M月d日hh")
                                color: "#8E99A5"
                                font.styleName: "Medium"
                                font.pointSize: 8
                                anchors.left: listimage.right
                                anchors.leftMargin: 10
                                anchors.bottom: listimage.bottom
                            }

                            Text {
                                text: "显示详情 >"
                                color: "#AA8E99A5"
                                font.styleName: "Medium"
                                font.pointSize: 10
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.verticalCenter: parent.verticalCenter
                            }

                        }
                    }
                }
            }
            // 分界线
            Rectangle{
                width: parent.width *0.92
                height: 1
                anchors.top:contentlist.bottom
                color: "#EEEEEE"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 功能区
            Rectangle {
                id: functionarea

                width: parent.width
                anchors.top: contentlist.bottom
                anchors.topMargin:5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 15
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    Row {
                        spacing: 10
                        width: parent.width
                        height: 40

                        Text {
                            width: 50
                            height: parent.height
                            text: qsTr("搜索:")
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextField {
                            id: searchfield
                            width: 250
                            height: parent.height
                            placeholderText: qsTr("请输入文章标题以搜索")
                            font.pointSize: 10
                            font.styleName: "Demibold"
                            color: "#8E99A5"
                        }
                    }

                    Row {
                        height: 35
                        Text {
                            width: 50
                            height: parent.height
                            text: "排序:"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }

                        ComboBox {
                            width: 116
                            id: sortcombobox
                            anchors.left: parent.left
                            anchors.leftMargin: 60
                            height: 35
                            font.pointSize: 10
                            model: ["按时间排序", "按标题排序", "按作者排序"]
                            currentIndex: 0
                        }

                        Switch {
                            anchors.left: sortcombobox.right
                            anchors.leftMargin: 10
                            id: sortswitch
                            width: 35
                            height: 35
                            scale: 0.75
                            checked: true
                        }

                        Text {
                            width: 50
                            height: 35
                            anchors.left: sortswitch.right
                            text: sortswitch.checked ? qsTr("升序排列") : qsTr("降序排列")
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Row{
                        spacing: 10
                        height: 38
                        Text{
                            width: 50
                            height: parent.height
                            text: "选项:"
                            color: "#8E99A5"
                            font.styleName: "Demibold"
                            font.pointSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }

                        //新建文章按钮和删除按钮
                        Rectangle {
                            id: newarticlebtn
                            width: 116
                            height: 25
                            radius: 5
                            color: "#1791FF"
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "新建文章"
                                font.styleName: "Demibold"
                                color: "white"
                                font.pointSize: 10
                                verticalAlignment: Text.AlignVCenter
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked:{
                                    if (hasNewArticle() == true)
                                    {
                                        errloader.sourceComponent = hasNewArticleNow
                                        return
                                    }
                                    // articledata 添加一条数据
                                    articledata.insert(0, {
                                    "aid": 0,
                                    "coverimg": "",
                                    "contentimg": "",
                                    "title": "新建文章",
                                    "introduction": "",
                                    "text": "",
                                    "writetime": new Date(),
                                    "updatetime": new Date(),
                                    "author": "admin",
                                    "pageviews": 0,
                                    "status": 3,
                                })
                                contentlist.currentIndex = 0
                            }
                        }
                    }

                    Rectangle {
                        id: deletearticlebtn
                        width: 116
                        height: 25
                        radius: 5
                        color: "#FF516B"
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: "删除文章"
                            color: "white"
                            font.styleName: "Demibold"
                            font.pointSize: 10
                            verticalAlignment: Text.AlignVCenter
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // 删除文章
                                articlemgr.deleteArticle()
                            }
                        }
                    }


                }
            }
        }

        Behavior on width {
        NumberAnimation {
            duration: 200
        }
    }

    layer.effect: DropShadow {
        cached: true
        color: "#90849292"
        horizontalOffset: 3
        verticalOffset: 3
        radius: 10
        samples: 2 * radius + 1
    }
}

Rectangle {
    id: rightarea

    width: parent.width - leftarea.width - 20
    height: leftarea.height
    radius: 10
    color: "transparent"

    Text {
        id: carouselmgrtitle

        text: "轮播设置"
        height: 25
        color: "#8E99A5"
        font.styleName: "Medium"
        font.pointSize: 18

        Behavior on height {
        NumberAnimation {
            duration: 200
        }
    }
}

// 轮播系统设置面板
Rectangle {
    id: carouselmgrpanel

    width: parent.width
    y: 32

    height: 175
    radius: 10
    layer.enabled: true
    color: "white"

    Behavior on height {
    NumberAnimation {
        duration: 400
    }
}

layer.effect: DropShadow {
    cached: true
    color: "#90849292"
    horizontalOffset: 3
    verticalOffset: 3
    radius: 10
    samples: 2 * radius + 1
}
}

Rectangle {
    anchors.top: carouselmgrpanel.bottom
    anchors.topMargin: 5
    width: parent.width
    height: 35
    color: "transparent"

    Text {
        text: "内容编辑"
        width: 120
        height: 25
        color: "#8E99A5"
        font.styleName: "Medium"
        font.pointSize: 18
    }

    Rectangle {
        width: 80
        height: 25
        color: "#1791FF"
        radius: 3
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: qsTr("沉浸模式")
            color: "white"
            font.styleName: "Medium"
            font.pointSize: 10
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (leftarea.visible)
                {
                    leftarea.visible = false
                    carouselmgrpanel.height = 0
                    carouselmgrpanel.y = 0
                    carouselmgrtitle.height = 0
                    carouselmgrtitle.visible = false
                    carouselmgrpanel.visible = false
                    leftarea.width = 0
                } else {
                leftarea.visible = true
                carouselmgrpanel.height = 200
                carouselmgrpanel.y = 35
                carouselmgrtitle.height = 25
                carouselmgrtitle.visible = true
                carouselmgrpanel.visible = true
                leftarea.width = 400
            }
        }
    }
}
}

// 内容编辑器
Rectangle {
    id: contenteditor

    width: parent.width
    anchors.top: carouselmgrpanel.bottom
    anchors.topMargin: 40
    anchors.bottom: parent.bottom
    radius: 10
    layer.enabled: true
    layer.effect: DropShadow {
        cached: true
        color: "#90849292"
        horizontalOffset: 3
        verticalOffset: 3
        radius: 10
        samples: 2 * radius + 1
    }
    color: "white"

    WebEngineView {
        id: webview
        anchors.fill: parent
        anchors.margins: 10
        anchors.bottomMargin: parent.height / 5
        url: "qrc:/htmlpage/htmlpage/contentedit.html"
    }
    // 分割线
    Rectangle {
        width: parent.width
        height: 1
        color: "#E5E5E5"
        anchors.top: webview.bottom
        anchors.topMargin: 3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 3
    }
    // 底部信息编辑面板
    Rectangle {
        id: bottompanel

        width: parent.width
        anchors.top: webview.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        // 标题和简介
        Rectangle {
            id: bottompanelcontent1
            anchors.fill: parent
            anchors.rightMargin: parent.width * 0.44

            // 标题
            Row {
                height: 40
                width: parent.width
                Text {
                    width: 80
                    height: parent.height - 15
                    text: qsTr("文章标题:")
                    color: "#AA201F1F"
                    font.styleName: "Medium"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                }

                TextField {
                    id: articletitle
                    text: isNewArticle() ? articledata.get(0).title : articleService.articles()[nowArticleNum()].title
                    width: parent.width - 105
                    height: 38
                    placeholderText: qsTr("请输入文章标题~")
                    verticalAlignment: TextInput.AlignBottom
                    font.styleName: "Normal"
                    font.pointSize: 10
                    color: "#082342"
                    focus: true
                }
            }
            // 多行支持的简介
            Row {
                height: parent.height - 35
                width: parent.width
                anchors.bottom: parent.bottom

                Text {
                    width: 80
                    height: 25
                    text: qsTr("文章简介:")
                    color: "#AA201F1F"
                    font.styleName: "Medium"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignBottom
                }

                Rectangle {
                    width: parent.width - 105
                    height: parent.height
                    TextArea {
                        id: articlesummary
                        text: isNewArticle() ? articledata.get(0).introduction : articleService.articles()[nowArticleNum()].introduction
                        anchors.fill: parent
                        placeholderText: qsTr("请输入文章简介~")
                        font.styleName: "Normal"
                        font.pointSize: 10
                        color: "#082342"
                        focus: true
                        // 禁止大小改变和溢出
                        clip: true
                        onTextChanged: {
                            // 最大3行, 200字
                            if (text.length > 200)
                            {
                                text = text.substring(0, 200)
                            }
                            var lines = text.split("\n")
                            if (lines.length > 3)
                            {
                                lines = lines.slice(0, 3)
                                text = lines.join("\n")
                            }
                        }
                        wrapMode: TextEdit.Wrap

                        // 右下角字数指示器 当前/最大
                        Text {
                            id: wordcount
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 10
                            anchors.rightMargin: 5
                            text: articlesummary.text.length + "/200"
                            color: "#A0201F1F"
                            font.styleName: "Medium"
                            font.pointSize: 6
                        }
                    }
                }
            }
        }
        // 封面
        Rectangle {
            id: cover
            anchors.left: bottompanelcontent1.right
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.3
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: "transparent"

            Text {
                id: covertitle
                width: parent.width / 2 - 50
                height: 25
                text: qsTr("封面:")
                color: "#AA201F1F"
                font.styleName: "Medium"
                font.pointSize: 12
                verticalAlignment: Text.AlignBottom
            }

            // 封面图片
            Rectangle {
                anchors.top: covertitle.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                radius: 5
                layer.enabled: true
                layer.effect: DropShadow {
                    cached: true
                    color: "#90849292"
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 10
                    samples: 2 * radius + 1
                }
                Text {
                    anchors.centerIn: parent
                    text: qsTr("点击选择封面")
                    color: "#A0201F1F"
                    font.styleName: "Medium"
                    font.pointSize: 14
                }
                Image {
                    id: coverimage
                    source: isNewArticle() ? articledata.get(0).coverimg : articleService.articles()[nowArticleNum()].coverimg
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    visible: source != ""
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        fileDialog.open()
                    }
                }
                // 文件选择窗口
                FileDialog {
                    id: fileDialog
                    title: qsTr("选择封面图片")
                    nameFilters: [qsTr(
                        "Images (*.png *.jpeg *.jpg)")]
                        fileMode: FileDialog.OpenFile
                        onAccepted: coverimage.source = selectedFile
                    }
                }
            }
            // 页面大图
            Rectangle {
                id: page
                anchors.left: cover.right
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.12
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "transparent"
                // 页面大图
                Text {
                    id: pagetitle
                    width: parent.width / 2 - 50
                    height: 25
                    text: qsTr("页面大图:")
                    color: "#AA201F1F"
                    font.styleName: "Medium"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignBottom
                }

                // 页面大图图片
                Rectangle {
                    anchors.top: pagetitle.bottom
                    anchors.topMargin: 5
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    radius: 5
                    layer.enabled: true
                    layer.effect: DropShadow {
                        cached: true
                        color: "#90849292"
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 10
                        samples: 2 * radius + 1
                    }
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("点击选择页面大图")
                        color: "#A0201F1F"
                        font.styleName: "Medium"
                        font.pointSize: 14
                    }
                    Image {
                        id: pageimage
                        source: isNewArticle() ? articledata.get(0).contentimg : articleService.articles()[nowArticleNum()].contentimg
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        visible: source != ""
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            fileDialog2.open()
                        }
                    }
                    // 文件选择窗口
                    FileDialog {
                        id: fileDialog2
                        title: qsTr("选择页面大图")
                        nameFilters: [qsTr(
                            "Images (*.png *.jpeg *.jpg)")]
                            fileMode: FileDialog.OpenFile
                            onAccepted: pageimage.source = selectedFile
                        }
                    }
                }
                //状态
                Rectangle {
                    anchors.left: page.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "transparent"
                    Text {
                        id: statustitle
                        height: 25
                        text: qsTr("状态:")
                        color: "#AA201F1F"
                        font.styleName: "Medium"
                        font.pointSize: 12
                        verticalAlignment: Text.AlignBottom
                    }
                    // 状态
                    // 下拉菜单
                    ComboBox {
                        id: statuscombobox
                        anchors.top: statustitle.bottom
                        anchors.topMargin: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height * 0.4
                        width: parent.width / 1.2
                        model: ["已发布", "草稿", "轮播", "私密"]
                        currentIndex: isNewArticle() ? 1 : articleService.articles()[nowArticleNum()].status
                    }
                    // 保存按钮
                    Rectangle {
                        id: savebutton
                        anchors.top: status.bottom
                        anchors.topMargin: parent.height * 0.05
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height * 0.1
                        width: parent.width *0.8
                        anchors.horizontalCenter: parent.horizontalCenter
                        radius: 5
                        color: "#1791FF"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("保存")
                            color: "white"
                            font.styleName: "Medium"
                            font.pointSize: 12
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {

                                // 保存文章
                                // 判断文章列表当前选中的文章的aid是不是0

                            }
                        }
                    }
                }
            }
        }
    }
}

Loader {
    id: errloader

    anchors.centerIn: parent
}

Component {
    id: hasNewArticleNow

    MessageBox {
        type: "tips"
        texts: "当前已有正在编辑的文章"
        helptext: "请先完成当前文章的编辑"
        conform: true
        yesorno: false
        justconform: true
    }
}

Connections {
    function onBtnClicked(x)
    {
        errloader.sourceComponent = null
    }

    target: errloader.item
}
}
