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
              qaWidget(
                qText: '質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文',
                aText: '回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文',
              ),
            ]
          ),
        )
      )
    );
  }

}


// class SettingTitleTextStyle {
//   static final TextStyle myTextStyle = TextStyle(
//     fontSize: 17,
//     color: Colors.white,
//     fontWeight: FontWeight.bold,
//   );
// }

// class SettingValueTextStyle {
//   static final TextStyle myTextStyle = TextStyle(
//     color: Colors.white,
//     fontSize: 17,
//   );
// }




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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: qaBackgroundColor(),
          ),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(25),
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
    );
  }



  // QA部分の文字サイズを一括指定
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
