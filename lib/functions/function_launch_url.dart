import 'package:url_launcher/url_launcher.dart';


Future functionLaunchUrl(url) async {
  launchUrl(Uri.parse(url));
}