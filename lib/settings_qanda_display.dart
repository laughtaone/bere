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
                QMethod('How old?'),
                AMethod('I am 20 years old!'),
              ],
            ),
            SettingsSection(
              // title: Text('General Questions'),
              title: Text(''),
              tiles: [
                QMethod('How old?'),
                AMethod('I am 20 years old!'),
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
