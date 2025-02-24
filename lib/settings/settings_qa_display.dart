import 'package:flutter/material.dart';
import 'package:berehearsal/components/comp_qa.dart';


// 質問データをリスト管理
const List<Map<String, dynamic>> qaData = [
  {
    'title': 'このアプリについて',
    'q': 'BeReal.と機能は同じですか？',
    'a': '本アプリはBeReal.を再現したため、機能は同じですが、外/内カメラの切り替えにかける時間や画像処理など細かい部分には、多少の差がある可能性があります。\nまた本アプリは、Flutterという開発フレームワークを用いていますが、BeReal.はSwiftなどのFlutter以外を用いている可能性があるため、開発手法による差も少なからず生じている可能性はあります。'
  },
  {
    'title': '',
    'q': 'このアプリのプログラムを見たいです。',
    'a': '今後、GitHubへの公開を検討しています。'
  },
  {
    'title': '',
    'q': 'このアプリでバグを見つけました！',
    'a': 'お手数ですが、至急開発者のXのDMより教えていただければ幸いです!'
  },
  {
    'title': '開発者について',
    'q': 'このアプリを通して、アプリ開発者にお金は入っていますか？',
    'a': '本アプリには、広告を掲載していない上、通信機能を実装していません。ゆえに、データや使用状況の収集もプログラム的に不可能であるため、本アプリを通して、アプリ開発者には1円たりとも、お金・使用データは入っていませんのでご安心ください。\n\nあくまで開発者が「n回の再撮影」と表示されずにBeReal.の撮影の練習をしたいという目的で開発したアプリです。'
  },
  {
    'title': '',
    'q': '機能の追加など、このアプリへの要望・感想を開発者に伝えたいです。',
    'a': '開発者のXのDMより教えていただければ幸いです。'
  },
  {
    'title': 'BeReal.運営者さまへ\n (For BeReal. developers)',
    'q': 'BeReal.の運営者からですが、至急、このアプリの配信の中止をしてください。\n（English translation by Google Translate: This is a message from the BeReal. developers to please stop distributing this rehearsal app as soon as possible.）',
    'a': 'この度は、勝手にリハーサルアプリの作成・配信を行い、大変申し訳ありません。まずは、BeReal.運営者であることを確認し、必要に応じ、即時、配信の中止を行います。そのため、お手数ですが、当アプリ開発者のX(@suupusoup)のDMまでお願いいたします。\n(English translation by Google Translate: I am very sorry for creating and distributing this rehearsal app without permission. First of all, I will confirm that you are the operator of BeReal., and if necessary, I will immediately stop the distribution. Therefore, I apologize for the inconvenience, but please send a DM to X (@suupusoup), the developer of this rehearsal app.)'
  },
];



class QAPage extends StatelessWidget {
  const QAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'よくある質問',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
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
            children: List.generate(qaData.length, (index) {
              return QaWidget(
                titleText: qaData[index]['title'] ?? '',
                qText: qaData[index]['q'],
                aText: qaData[index]['a'],
              );
            }),
          ),
        )
      )
    );
  }

}
