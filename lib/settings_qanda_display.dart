import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'take_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_display.dart';




class QandAPage extends StatelessWidget {
  // const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              // title: Text('General Questions'),
              title: Text(''),
              tiles: [
                QMethod('撮影した画像をどうしても保存したいです。どうすればいいですか？'),
                AMethod('撮影した画像を保存する方法は、現地点ではありません。\nこのアプリのユーザー数が増加し、かつ撮影した画像を保存したいという方が増えたら、保存の対応を検討します。'),
              ],
            ),
            SettingsSection(
              // title: Text('General Questions'),
              title: Text(''),
              tiles: [
                QMethod('なぜそんなに保存を禁止するのでしょうか？'),
                AMethod('本アプリはBeReal.の撮影を楽しむことのみを目的として作ったため、本アプリで撮影したBeReal.を忠実に再現した画像がインターネット上に出回り、BeReal.の画像と見分けがつかなくなるとBeReal.が発明した革新的なアイデアを台無しにしてしまう恐れがあると考えているからです。'),
              ],
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
