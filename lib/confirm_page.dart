import 'package:flutter/material.dart';
import 'dart:io';
import 'main.dart';
import 'take_display.dart';



// ConfirmPageの定義
class ConfirmPage extends StatelessWidget {
  final String imagePath;
  ConfirmPage({required this.imagePath});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      // body: Center(
      //   child: Image.file(File(imagePath)),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            Text(
              '撮影した画像の保存・スクショは一切できません。',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.file(File(imagePath)),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.radio_button_unchecked),
              color: Colors.white,
              iconSize: 80,
            ),
          ],
        )
      ),
    );
  }
}


