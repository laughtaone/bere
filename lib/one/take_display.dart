import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../two/confirm_page.dart';
import '../settings/settings_display.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:berehearsal/custom/custom.dart';


class TakePage extends StatefulWidget {
  @override
  _TakePageState createState() => _TakePageState();
}

class _TakePageState extends State<TakePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  int _cameraIndex = 0;
  String? outCameraImagePath;
  String? inCameraImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[_cameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();

      if (!mounted) return;

      if (_cameraIndex == 0) {
        outCameraImagePath = image.path;
        // カメラを切り替えてもう一度撮影
        _cameraIndex = 1;
        await _initializeCamera();
        await _takePicture(); // 切り替え後に再度撮影
      } else if (_cameraIndex == 1) {
        inCameraImagePath = image.path;

        // 両方のカメラで撮影完了後にConfirmPageに遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPage(
                outCameraImagePath: outCameraImagePath ?? '',
                inCameraImagePath: inCameraImagePath ?? ''),
          ),
        );

        // カメラを切り替える (再度片方のカメラから始める)
        _cameraIndex = 0;
        await _initializeCamera();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: allBackgroundColor(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'BeRehearsal.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'To supprt enjoying BeReal.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[Setting()],
          backgroundColor: allBackgroundColor(),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CautionEnableSukusho(),
                  // ================================================= カメラ画像部分 始 =================================================
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(16.0),
                  //   ),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(16.0),
                  //     child: AspectRatio(
                  //       aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                  //       child: CameraPreview(_controller!),
                  //     ),
                  //   ),
                  // ),

                  Stack(
                    // alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      // カメラ画像のContainer
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: AspectRatio(
                            aspectRatio: 3 / 4, // 3:4のアスペクト比を設定
                            child: CameraPreview(_controller!),
                          ),
                        ),
                      ),
                      // アイコン配置
                      Positioned(
                        bottom: 1,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: IconButton(
                                icon: cameraImageFieldIconButton(Icons.electric_bolt_outlined),
                                onPressed: null,
                              ),
                            ),
                            IconButton(
                              icon: cameraImageFieldIconButton(Icons.circle_outlined),
                              onPressed: null,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: IconButton(
                                icon: cameraImageFieldIconButton(Icons.cached_outlined),
                                onPressed: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ================================================= カメラ画像部分 終 =================================================
                  IconButton(
                    onPressed: _takePicture, // 写真を撮る関数を呼び出し
                    icon: Icon(Icons.radio_button_unchecked),
                    color: Colors.white,
                    iconSize: 100,
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class CautionEnableSukusho extends StatelessWidget {
  const CautionEnableSukusho({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 15), // 余白を設定
      child: Text(
        '撮影した画像の保存・スクショは一切できません',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// 設定ボタンの内容
class Setting extends StatelessWidget {
  const Setting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
            fullscreenDialog: true,
          ),
        );
      },
      icon: Icon(Icons.settings),
      color: Colors.white,
      iconSize: 27,
    );
  }
}




// カメラ画像部分の上のIconButtonのスタイル
Icon cameraImageFieldIconButton(IconData receivedIcon) {
  return Icon(
    receivedIcon,
    color: Colors.white.withOpacity(0.85),
    size: 27,
  );
}