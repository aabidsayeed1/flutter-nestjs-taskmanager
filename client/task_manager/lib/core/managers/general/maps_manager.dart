import 'package:url_launcher/url_launcher.dart';

class MapsManager {
  static Future launchMaps(double dLat, double dLong) async {
    final Uri url =
        Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': '$dLat,$dLong'});
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
    throw 'Could not launch $url';
  }
}
