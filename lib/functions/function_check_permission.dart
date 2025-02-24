import 'package:permission_handler/permission_handler.dart';



// カメラの権限が許可されているか返す関数
Future<bool> functionCheckCameraPermission() async {
  // カメラの権限状態を取得
  PermissionStatus status = await Permission.camera.status;

  return status.isGranted;
}

Future<bool> functionCheckMicPermission() async {
  // マイクの権限状態を取得
  PermissionStatus status = await Permission.microphone.status;

  return status.isGranted;
}


// カメラorマイクの権限が拒否されていた場合に、許可を求めるために設定ページへ誘導する関数
// (許可されていた・新たに求め許可された場合：true、新たに求め拒否された場合：false を返す)
Future<bool> functionRequestCameraOrMicPermission() async {
  // 現在のカメラ・マイク権限を確認
  bool isCameraPermission = await Permission.camera.isGranted;
  bool isMicPermission = await Permission.microphone.isGranted;

  if (!isCameraPermission) {
    // 権限をリクエスト
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      return true; // 権限が許可された場合
    } else if (status.isPermanentlyDenied) {
      // 権限が永続的に拒否されている場合は設定画面に誘導
      await openAppSettings();
      return false; // 設定画面に誘導するだけで権限が許可されるわけではない
    }

    return false; // 権限が拒否された場合
  }
  else if (!isMicPermission) {
    // 権限をリクエスト
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      return true; // 権限が許可された場合
    } else if (status.isPermanentlyDenied) {
      // 権限が永続的に拒否されている場合は設定画面に誘導
      await openAppSettings();
      return false; // 設定画面に誘導するだけで権限が許可されるわけではない
    }

    return false; // 権限が拒否された場合
  }

  return true; // 権限がすでに許可されている場合
}
