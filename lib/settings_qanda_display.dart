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
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF7d7d7d),
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
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0), // アイコンとテキストの間に余白を設定することができます
                              child: Text(
                                '質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 2,
                      // width: ,
                      color: Colors.white,
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
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0), // アイコンとテキストの間に余白を設定することができます
                              child: Text(
                                '回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文回答文',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TextButton.icon(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.help_outline),
                    //   label: Text('質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文質問文'),
                    //   style: TextButton.styleFrom(iconColor: Colors.black),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsTile QMethod(String qText) {
    return SettingsTile(
      leading: Icon(Icons.help),
      title: Text(qText),
      onPressed: null,
    );
  }

  SettingsTile AMethod(String aText) {
    return SettingsTile(
      leading: Icon(Icons.hdr_auto),
      title: Text(aText),
      onPressed: null,
    );
  }

}


class SettingTitleTextStyle {
  static final TextStyle myTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

class SettingValueTextStyle {
  static final TextStyle myTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}
