import 'package:task_manager/app_imports.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportManager {
  static Future makePhoneCall(String phoneNo) async {
    String url = 'tel:$phoneNo';

    // Call was not working for IOS, the format for IOS is as below, if phone number has "+" symbol
    if (Utils.isPlatformAndroid() == false) {
      final Uri phoneUrl = Uri(scheme: 'tel', path: phoneNo);

      url = phoneUrl.toString();
    }

    Uri callURL = Uri.parse(url);
    if (await canLaunchUrl(callURL)) {
      await launchUrl(callURL);
    } else {
      HelperUI.showSnackBar(strTile: "", strMessage: "");
    }
  }

  static void sendEmail(String strRecepient, String strSubject, String strBody) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: strRecepient,
      queryParameters: {'subject': strSubject, 'body': strBody},
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    } catch (e) {
      Utils.printLogs('Error: $e');
    }
  }

  static void launcURL(String strURL) async {
    final Uri url = Uri.parse(strURL);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Utils.printLogs('Error: $e');
    }
  }
}
