import 'package:flutter/material.dart';
import 'one/take_display.dart';
import 'package:berehearsal/custom/custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:berehearsal/settings/settings_display.dart';
import 'package:provider/provider.dart';
import 'package:berehearsal/settings/settings_display.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsPageModel(),
      child: StartPageHome(),
    ),
  );
}

class StartPageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    final settingsPageModel = Provider.of<SettingsPageModel>(context, listen: false);
    if (settingsPageModel.skipStartPage == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TakePage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsPageModel = Provider.of<SettingsPageModel>(context);
    if (settingsPageModel.skipStartPage == true) {
      return Container(); // 空のコンテナを返す
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: allBackgroundColor(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'BeRehearsal.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'To support enjoying BeReal.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 230),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakePage()), // 画面遷移
                    );
                  },
                  child: Text(
                    'はじめる>',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'このアプリはあくまでリハーサル用です',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '撮影した画像の保存・スクショは一切できません',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}