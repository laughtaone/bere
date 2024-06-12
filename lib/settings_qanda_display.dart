import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'take_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_display.dart';


void main() {
  runApp(
    QandAPageHome()
  );
}

class QandAPageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QandAPage(),
    );
  }
}

class QandAPage extends StatelessWidget {
  // const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'よくある質問',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text(
              //   '節名',
              //   style: TextStyle(color: Colors.white),
              // ),
              qaWidget(
                qText: 'BeRehearsal.で撮影した写真を保存するにはどうすればいいですか？',
                aText: '現地点では、BeRehearsal.で撮影した写真を保存する機能はありません。また、スクショもできないような仕様となっています。\nこれは、BeRehearsal.で撮影した画像とBeReal.で撮影した画像に見分けがつかなくなり、BeReal.アプリでひとときの瞬間を撮影する楽しみを奪ってしまうことを防ぐためです。\nなお、BeReal.との見分けをつける方法として、内と外で別々の2枚の画像で保存する機能の実装を検討しています。',
              ),
              qaWidget(
                qText: '',
                aText: '',
              ),
            ]
          ),
        )
      )
    );
  }

}

// Q＆A用のウィジェット
class qaWidget extends StatelessWidget {
  final String qText;
  final String aText;

  const qaWidget({
    Key? key,
    required this.qText,
    required this.aText,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            Text(
              'data',
              style: TextStyle(
                color: Colors.white,
                fontSize: qaTitleSize(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: qaBackgroundColor(),
              ),
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.help_outline,
                            color: qaContentsColor(),
                            size: qaIconSize(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              qText,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: qaTextSize(),
                                color: qaContentsColor(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: qaContentsColor(),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            color: qaContentsColor(),
                            size: qaIconSize(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              aText,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: qaTextSize(),
                                color: qaContentsColor(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }




  // QA部分のタイトルサイズを一括指定
  double qaTitleSize() {
    final qaIconSize = 20.0;
    return qaIconSize;
  }

  // QA部分のアイコンサイズを一括指定
  double qaIconSize() {
    final qaIconSize = 24.0;
    return qaIconSize;
  }

  // QA部分の文字サイズを一括指定
  double qaTextSize() {
    final qaTextSize = 16.0;
    return qaTextSize;
  }

  // アイコン・文字色・仕切り線の背景色を指定
  Color qaContentsColor() {
    final qaContentsColor = Colors.white;
    return qaContentsColor;
  }

  // アイコン・文字色・仕切り線の背景色を指定
  Color qaBackgroundColor() {
    final qaBackgroundColor = Color(0xFF555555);
    return qaBackgroundColor;
  }

}
