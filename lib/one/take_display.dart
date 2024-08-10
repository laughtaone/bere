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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final outCamera = cameras[0];
    final inCamera = cameras[1];

    _controller = CameraController(
      outCamera,
      ResolutionPreset.medium, // 3:4に近い解像度を選択
    );

    await _controller!.initialize(); // 外カメラの初期化を待つ

    _controller = CameraController(
      inCamera,
      ResolutionPreset.medium, // 3:4に近い解像度を選択
    );

    _initializeControllerFuture = _controller!.initialize(); // 内カメラの初期化を待つ
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
      final outCameraImage = await _controller!.takePicture();

      // 内カメラに切り替え
      final cameras = await availableCameras();
      final inCamera = cameras[1];
      _controller = CameraController(
        inCamera,
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      final inCameraImage = await _controller!.takePicture();

      if (!mounted) return;

      // ConfirmPageに遷移し、撮影した画像を渡す
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPage(outCameraImagePath: outCameraImage.path, inCameraImagePath: inCameraImage.path),
        ),
      );
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