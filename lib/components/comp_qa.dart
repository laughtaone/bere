import 'package:flutter/material.dart';

// Q＆A用のウィジェット
class QaWidget extends StatelessWidget {
  final String qText;
  final String aText;
  final String titleText;

  const QaWidget({
    super.key,
    required this.qText,
    required this.aText,
    required this.titleText
  });


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
          child: Column(
            children: [
              necessityQATitle(titleText),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: qaBackgroundColor(),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: qaWidgetContainerPadding(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1.5),
                            child: Icon(
                              Icons.help_outline,
                              color: qaContentsColor(),
                              size: qaIconSize(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                qText,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: qaTextSize(),
                                  color: qaContentsColor(),
                                  fontFamily: qaTextFont(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: qaLineColor(),
                    ),
                    Container(
                      padding: qaWidgetContainerPadding(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: qaContentsColor(),
                              size: qaIconSize(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                aText,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: qaTextSize(),
                                  color: qaContentsColor(),
                                  fontFamily: qaTextFont(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }




  // QA部分の余白を一括指定
  EdgeInsets qaWidgetContainerPadding() {
    return const EdgeInsets.all(15);
  }

  // QA部分のタイトルサイズを一括指定
  double qaTitleSize() {
    const qaIconSize = 21.0;
    return qaIconSize;
  }

  // QA部分のアイコンサイズを一括指定
  double qaIconSize() {
    const qaIconSize = 24.0;
    return qaIconSize;
  }

  // QA部分の文字サイズを一括指定
  double qaTextSize() {
    const qaTextSize = 15.5;
    return qaTextSize;
  }

  // QA部分の文字フォントを一括指定
  String qaTextFont() {
    const qaTextFont = 'NotoSansJP-Regular';
    return qaTextFont;
  }

  // QA部分のタイトルの文字フォントを一括指定
  String qaTitleTextFont() {
    const qaTitleTextFont = 'NotoSansJP-SemiBold';
    return qaTitleTextFont;
  }

  // アイコン・文字の色を指定
  Color qaContentsColor() {
    const qaContentsColor = Colors.white;
    return qaContentsColor;
  }

  // アイコン・文字・仕切り線の背景色を指定
  Color qaBackgroundColor() {
    const qaBackgroundColor = Color(0xFF2e2e2e);
    return qaBackgroundColor;
  }

  // 仕切り線の色を指定
  Color qaLineColor() {
    const qaLineColor = Color(0xFFbbbbbb);
    return qaLineColor;
  }


  Widget necessityQATitle(String valutitleText) {
    if (titleText != '') {
      return Container(
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          titleText,
          style: TextStyle(
            color: Colors.white,
            fontSize: qaTitleSize(),
            fontFamily: qaTitleTextFont(),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

