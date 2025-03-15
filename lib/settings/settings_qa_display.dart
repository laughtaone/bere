import 'package:flutter/material.dart';
import 'package:berehearsal/components/comp_qa.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




class QAPage extends StatelessWidget {
  const QAPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ------------------------------ Q&Aデータ(多言語対応でcontextが必要なのでここで定義) ------------------------------
    final List<Map<String, dynamic>> qaData = [
      {
        'title': AppLocalizations.of(context)!.qaTitle1,
        'q': AppLocalizations.of(context)!.q1,
        'a': AppLocalizations.of(context)!.a1
      },
      {
        'title': '',
        'q': AppLocalizations.of(context)!.q2,
        'a': AppLocalizations.of(context)!.a2
      },
      {
        'title': '',
        'q': AppLocalizations.of(context)!.q3,
        'a': AppLocalizations.of(context)!.a3
      },
      {
        'title': '',
        'q': AppLocalizations.of(context)!.q4,
        'a': AppLocalizations.of(context)!.a4,
        'url': 'https://forms.gle/kVS6BXarzvrNWxsK6',
        'customUrlOpenText': AppLocalizations.of(context)!.a4OpenText
      },
      {
        'title': AppLocalizations.of(context)!.qaTitle2,
        'q': AppLocalizations.of(context)!.q5,
        'a': AppLocalizations.of(context)!.a5,
      },
      {
        'title': '',
        'q': AppLocalizations.of(context)!.q6,
        'a': AppLocalizations.of(context)!.a6,
        'url': 'https://forms.gle/NERKzeJkrjysmysFA',
        'customUrlOpenText': AppLocalizations.of(context)!.a6OpenText
      },
      {
        'title': AppLocalizations.of(context)!.qaTitle3,
        'q': AppLocalizations.of(context)!.q7,
        'a': AppLocalizations.of(context)!.a7,
        'url': 'https://x.com/laughtaone',
        'customUrlOpenText': AppLocalizations.of(context)!.a7OpenText
      }
    ];
    // -----------------------------------------------------------------------------------------------------------

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.faq,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(qaData.length, (index) {
              return QaWidget(
                titleText: qaData[index]['title'] ?? '',
                qText: qaData[index]['q'],
                aText: qaData[index]['a'],
                url: qaData[index]['url'] ?? '',
                customUrlOpenText: qaData[index]['customUrlOpenText'] ?? '',
              );
            }),
          ),
        )
      )
    );
  }
}
