import 'package:berehearsal/components/comp_image_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'take_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:berehearsal/components/comp_title_appbar.dart';


// ConfirmPageの定義
class ConfirmPage extends StatefulWidget {
  final String mainImagePath;
  final String subImagePath;

  const ConfirmPage({super.key, required this.mainImagePath, required this.subImagePath});

  @override
  ConfirmPageState createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  bool isImageSwap = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
              Stack(
                children: [
                  // ------------------------------- メイン画像 ------------------------------
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedImageSwitcher(
                        imagePath: (isImageSwap) ? widget.subImagePath : widget.mainImagePath,
                      ),
                    ),
                  ),
                  // -----------------------------------------------------------------------
                  // --------------------------- 右上の閉じるボタン ---------------------------
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
                  // -----------------------------------------------------------------------

                  // ------------------------------- サブ画像 -------------------------------
                  Positioned(
                    top: 15,
                    left: 15,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        side: const BorderSide(color: Colors.black, width: 1.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();     // 触覚フィードバック
                        setState(() {
                          isImageSwap = !isImageSwap;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 120,
                          child: AnimatedImageSwitcher(
                            imagePath: (isImageSwap)
                              ? widget.mainImagePath
                              : widget.subImagePath,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // -----------------------------------------------------------------------
                ],
              ),
              // ==================================================================================================================
              const SizedBox(height: 20),
              TextButton(
                // onPressed: _launchBeReal,
                onPressed: () async {
                  HapticFeedback.lightImpact();     // 触覚フィードバック
                  final url = Uri.parse('bereal://');
                  launchUrl(url);
                },
                child: const Text(
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
        )),
    );
  }
}