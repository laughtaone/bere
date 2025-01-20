// 設定した値の読み込みを行う関数

import 'package:shared_preferences/shared_preferences.dart';



// -------------------------- スタート画面スキップ設定 --------------------------
// 読み込み
Future<bool?> loadSkipStartPagePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('skipStartPage');
}

// 書き込み
Future<void> setSkipStartPagePreference(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('skipStartPage', value);
}
// --------------------------------------------------------------------------



// ----------------------------- 左利きモード設定 -----------------------------
// 読み込み
Future<bool?> loadLeftHandedModePreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('leftHandedMode');
}

// 書き込み
Future<void> setLeftHandedModePreference(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('leftHandedMode', value);
}
// --------------------------------------------------------------------------