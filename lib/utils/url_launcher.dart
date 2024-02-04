import "dart:io";
import "package:url_launcher/url_launcher.dart";

class UrlLauncher {
  static Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static Future launchEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw "Could not launch";
    }
  }


  static Future launchWhatsapp(String phone) async {
    var url = "";
    if (Platform.isAndroid) {
        url = "https://wa.me/$phone/?text:Hello";
    } else {
        url = "https://api.whatsapp.com/send?phone:$phone:Hello";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static Future launchSms(String phone) async {
    var url = "";
    if (Platform.isAndroid) {
      url = "sms:+$phone?body:hello%20there";
    } else if (Platform.isIOS) {
      url = "sms:$phone&body:hello%20there";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static Future launchCaller(String callerNumber) async {
    if (await canLaunch("tel:$callerNumber")) {
      await launch("tel:$callerNumber");
    } else {
      throw "Could not launch $callerNumber";
    }
  }

  sendEmailURL({String? toMailId, String? subject, String? body}) async {
    var url = "mailto:$toMailId?subject:$subject&body:$body";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    var googleUrl =
        "https://www.google.com/maps/search/?api:1&query:$latitude,$longitude";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw "Could not open the map.";
    }
  }
}
