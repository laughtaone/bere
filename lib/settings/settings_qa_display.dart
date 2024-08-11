import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../one/take_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_display.dart';
import 'package:berehearsal/custom/custom.dart';


// void main() {
//   runApp(
//     QAPageHome()
//   );
// }

// class QAPageHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: QAPage(),
//     );
//   }
// }

class QAPage extends StatelessWidget {
  // const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: allBackgroundColor(),
      appBar: AppBar(
        backgroundColor: allBackgroundColor(),
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
            Navigator.pop(context);
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
                titleText: 'このアプリについて',
                qText: 'BeReal.と機能は同じですか？',
                aText: '本アプリはBeReal.を再現したため、機能は同じですが、外/内カメラの切り替えにかける時間や画像処理など細かい部分には、多少の差がある可能性があります。\nまた本アプリは、Flutterという開発フレームワークを用いていますが、BeReal.はSwiftなどのFlutter以外を用いている可能性があるため、開発手法による差も少なからず生じている可能性はあります。'
              ),
              qaWidget(
                titleText: '',
                qText: 'このアプリのプログラムを見たいです。',
                aText: '今後、GitHubへの公開を検討しています。'
              ),
              qaWidget(
                titleText: '',
                qText: 'このアプリでバグを見つけました！',
                aText: 'お手数ですが、至急開発者(スウプ)のXのDMより教えていただければ幸いです!'
              ),
              qaWidget(
                titleText: '開発者について',
                qText: 'このアプリを通して、アプリ開発者にお金は入っていますか？',
                aText: '本アプリには、広告を掲載していない上、通信機能を実装していません。ゆえに、データや使用状況の収集もプログラム的に不可能であるため、本アプリを通して、アプリ開発者であるスウプには1円たりとも、お金・使用データは入っていませんのでご安心ください。\n\nあくまで開発者が「n回の再撮影」と表示されずにBeReal.の撮影の練習をしたいという目的で開発したアプリです。'
              ),
              qaWidget(
                titleText: '',
                qText: '機能の追加など、このアプリへの要望・感想を開発者に伝えたいです。',
                aText: '開発者(スウプ)のXのDMより教えていただければ幸いです。'
              ),
              qaWidget(
                titleText: 'BeReal.運営者さまへ\n (For BeReal. developers)',
                qText: 'BeReal.の運営者からですが、至急、このアプリの配信の中止をしてください。\n（English translation by Google Translate: This is a message from the BeReal. developers to please stop distributing this rehearsal app as soon as possible.）',
                aText: 'この度は、勝手にリハーサルアプリの作成・配信を行い、大変申し訳ありません。まずは、BeReal.運営者であることを確認し、必要に応じ、即時、配信の中止を行います。そのため、お手数ですが、当アプリ開発者のX(@suupusoup)のDMまでお願いいたします。\n(English translation by Google Translate: I am very sorry for creating and distributing this rehearsal app without permission. First of all, I will confirm that you are the operator of BeReal., and if necessary, I will immediately stop the distribution. Therefore, I apologize for the inconvenience, but please send a DM to X (@suupusoup), the developer of this rehearsal app.)'
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
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 25),
          child: Column(
            children: [
              necessityQATitle(titleText),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: qaBackgroundColor(),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: qaWidgetContainerPadding(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 1.5),
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
                      color: qaLineColor(),
                    ),
                    Container(
                      padding: qaWidgetContainerPadding(),
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




  // QA部分の余白を一括指定
  EdgeInsets qaWidgetContainerPadding() {
    return EdgeInsets.all(15);
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
    final qaTextSize = 15.5;
    return qaTextSize;
  }

  // QA部分の文字フォントを一括指定
  String qaTextFont() {
    final qaTextFont = 'NotoSansJP-Regular';
    return qaTextFont;
  }

  // QA部分のタイトルの文字フォントを一括指定
  String qaTitleTextFont() {
    final qaTitleTextFont = 'NotoSansJP-SemiBold';
    return qaTitleTextFont;
  }

  // アイコン・文字の色を指定
  Color qaContentsColor() {
    final qaContentsColor = Colors.white;
    return qaContentsColor;
  }

  // アイコン・文字・仕切り線の背景色を指定
  Color qaBackgroundColor() {
    final qaBackgroundColor = Color(0xFF2e2e2e);
    return qaBackgroundColor;
  }

  // 仕切り線の色を指定
  Color qaLineColor() {
    final qaLineColor = Color(0xFFbbbbbb);
    return qaLineColor;
  }


  Widget necessityQATitle(String valutitleText) {
    if (titleText != '') {
      return Container(
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
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

