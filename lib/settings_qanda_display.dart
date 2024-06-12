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
                titleText: '本アプリについて',
                qText: 'BeRehearsal.で撮影した写真を保存するにはどうすればいいですか？',
                aText: '現地点では、BeRehearsal.で撮影した写真を保存する機能はありません。また、スクショもできないような仕様となっています。\nこれは、BeRehearsal.で撮影した画像とBeReal.で撮影した画像の2つに見分けがつかなくなり、BeReal.アプリでひとときの瞬間を撮影する楽しみを奪ってしまうことを防ぐためです。\nなお、BeReal.との見分けをつける方法として、内と外で別々の2枚の画像で保存する機能の実装を検討しています。',
              ),
              qaWidget(
                titleText: '',
                qText: 'BeReal.と機能は同じですか？',
                aText: '本アプリはBeReal.を再現したものであるため機能は同じですが、外/内カメラの切り替えにかける時間や画像処理など細かい部分には、多少の差がある可能性があります。\nまた本アプリは、Flutterというプログラミング言語を用いていますが、BeReal.はSwiftなどのFlutter以外のプログラミング言語を用いている可能性があるため、プログラミング言語による差も少なからず生じている可能性があります。'
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
  final String titleText;

  const qaWidget({
    Key? key,
    required this.qText,
    required this.aText,
    required this.titleText
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 3),
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  titleText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: qaTitleSize(),
                    fontFamily: qaTitleTextFont(),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: qaBackgroundColor(),
                ),
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
                                  fontFamily: qaTextFont(),
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
                                  fontFamily: qaTextFont(),
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
        ),
      ],
    );
  }




  // QA部分のタイトルサイズを一括指定
  double qaTitleSize() {
    final qaIconSize = 21.0;
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

  // QA部分の文字フォントを一括指定
  String qaTextFont() {
    final qaTextFont = 'NotoSansJP-Medium';
    return qaTextFont;
  }

  // QA部分のタイトルの文字フォントを一括指定
  String qaTitleTextFont() {
    final qaTitleTextFont = 'NotoSansJP-SemiBold';
    return qaTitleTextFont;
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
