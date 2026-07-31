import 'package:url_launcher/url_launcher.dart';

Future<void> openWeatherInBrowser(String cityName) async {
  final Uri url = Uri.parse(
    'https://www.google.com/search?q=weather+$cityName',
  );

  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}