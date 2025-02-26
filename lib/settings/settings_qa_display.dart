import 'package:flutter/material.dart';
import 'package:berehearsal/components/comp_qa.dart';


// 質問データをリスト管理
const List<Map<String, dynamic>> qaData = [
  {
    'title': 'このアプリについて',
    'q': 'BeReal.と機能は同じですか？',
    'a': '本アプリはBeReal.を再現したため、写真撮影の機能は同じですが、本家様にあるビデオ撮影には対応していません。\n\n加えて、外/内カメラの切り替えにかける時間や画像処理など細かい部分には、多少の差がある可能性があります。\n\nまた本アプリは、Flutterという開発フレームワークを用いていますが、本家様はSwiftなどのFlutter以外を用いている可能性が高いため、開発手法による差も生じている可能性はあります。'
  },
  {
    'title': '',
    'q': 'このアプリのプログラムを見たいです。',
    'a': '今後、GitHubへの公開を検討しています。'
  },
  {
    'title': '',
    'q': 'このアプリでバグを見つけました！',
    'a': 'お手数ですが、下記のフォームより報告していただけたら幸いです',
    'url': 'https://forms.gle/kVS6BXarzvrNWxsK6',
    'customUrlOpenText': 'フォームを開く'
  },
  {
    'title': '開発者について',
    'q': 'このアプリを通して、アプリ開発者にお金は入っていますか？',
    'a': '本アプリでは、アプリ内においてインターネット通信機能や撮影データ保存機能を実装していません。\nそのため、プログラム的にそもそも広告を掲載できない上、データや使用状況の収集も不可能であるため、本アプリを通して、本アプリ開発者には1円たりとも、お金・使用分析データは入っていませんのでご安心ください。\n\nあくまで、本アプリ開発者が「n回の再撮影」と表示されずにBeReal.の撮影の練習をしたいという目的で開発したアプリです。\n\nまた、BeReal.様を支えるこのアプリから収益を得るのは、本アプリ開発者の自分の中のポリシーに反するため、今後も同様に広告を掲載せず、使用データの収集・分析もいたしません。'
  },
  {
    'title': '',
    'q': '機能の追加など、このアプリへの要望・感想を開発者に伝えたいです。',
    'a': '開発者の X(Twitter) のDMより教えていただければ幸いです。',
    'url': 'https://x.com/laughtaone',
    'customUrlOpenText': 'X(Twitter) を開く'
  },
  {
    'title': 'BeReal.運営者さまへ\n (For BeReal. developers)',
    'q': 'BeReal.の運営者からですが、至急、このアプリの配信の中止をしてください。\n（English translation by Google Translate: This is a message from the BeReal. developers to please stop distributing this rehearsal app as soon as possible.）',
    'a': 'この度は、勝手にリハーサルアプリの作成・配信を行い、大変申し訳ありません。まずは、BeReal.運営者であることを確認し、必要に応じ、即時、配信の中止を行います。そのため、お手数ですが、当アプリ開発者のX(@laughtaone)のDMまでお願いいたします。\n(English translation by Google Translate: I am very sorry for creating and distributing this rehearsal app without permission. First of all, I will confirm that you are the operator of BeReal., and if necessary, I will immediately stop the distribution. Therefore, I apologize for the inconvenience, but please send a DM to X (@laughtaone), the developer of this rehearsal app.)',
    'url': 'https://x.com/laughtaone',
    'customUrlOpenText': 'Xを開く (Open X)'
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
                url: qaData[index]['url'] ?? '',
                customUrlOpenText: qaData[index]['customUrlOpenText'] ?? '',
              );
            }),
          ),
        )
      )
    );
  }

}
