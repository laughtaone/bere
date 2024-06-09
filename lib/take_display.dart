import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'confirm_page.dart';

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
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium, // 3:4に近い解像度を選択
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

      // ConfirmPageに遷移し、撮影した画像を渡す
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
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
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
            color: Colors.white,
            iconSize: 24,
          ),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 15), // 余白を設定
                    child: Text(
                      '撮影した画像の保存・スクショは一切できません',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
