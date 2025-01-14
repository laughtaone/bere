import 'package:flutter/material.dart';
import 'dart:io';
import '../one/take_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:berehearsal/components/components.dart';


// ConfirmPageの定義
class ConfirmPage extends StatelessWidget {
  final String mainImagePath;
  final String subImagePath;

  const ConfirmPage(
      {super.key, required this.mainImagePath, required this.subImagePath});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const CompTitleAppBar(),
          automaticallyImplyLeading: false,
          actions: const <Widget>[Setting()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CautionEnableSukusho(),

              // ================================================= カメラ画像部分 始 =================================================
              // Stack(
              //   alignment: AlignmentDirectional.topEnd,
              //   children: [
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(16),
              //       child: Image.file(File(mainImagePath)),
              //     ),
              //     Container(
              //       margin: EdgeInsets.all(10),
              //       child: InkWell(
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //         child: Container(
              //           padding: EdgeInsets.all(4),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Colors.black.withOpacity(0.5),
              //           ),
              //           child: Icon(
              //             Icons.close,
              //             color: Colors.white,
              //             size: 30,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              Stack(
                children: [
                  // カメラ画像のClipRRect
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(mainImagePath)),
                  ),

                  // 右上の閉じるボタン
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.8),
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 15,
                    left: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 2.2
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 120,
                          child: Image.file(File(subImagePath)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ================================================= カメラ画像部分 終 =================================================
              const SizedBox(height: 20),
              TextButton(
                  onPressed: _launchBeReal,
                  child: const Text(
                    'BeReal.を開く>',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        )),
    );
  }

  Future _launchBeReal() async {
    final url = Uri.parse('bereal://');
    launchUrl(url);
  }
}