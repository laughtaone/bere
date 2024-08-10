import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io';
import '../main.dart';
import '../one/take_display.dart';
import 'package:url_launcher/url_launcher.dart';



// ConfirmPageの定義
class ConfirmPage extends StatelessWidget {
  final String imagePath;
  ConfirmPage({required this.imagePath});


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
          actions: <Widget>[
            Setting()
          ],
          backgroundColor: Colors.black,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              CautionEnableSukusho(),
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(imagePath)),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _launchBeReal,
                child: Text(
                  'BeReal.を開く>',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
  }

  Future _launchBeReal() async {
    final url = Uri.parse('bereal://');
    launchUrl(url);
  }

}


