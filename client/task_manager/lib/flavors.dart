enum Flavor {
  dev,
  qa,
  uat,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Task Manager DEV';
      case Flavor.qa:
        return 'Task Manager QA';
      case Flavor.uat:
        return 'Task Manager UAT';
      case Flavor.prod:
        return 'Task Manager PROD';
    }
  }
static String get getFallbackPublicCert {
    switch (appFlavor) {
      case Flavor.dev:
        return '';
      case Flavor.qa:
        return '';
      case Flavor.uat:
        return '';
      case Flavor.prod:
        return '';
    }
  }

  //openssl s_client -connect bloom-stage.svaas.com:443 |  openssl x509 -pubkey -noout -fingerprint -sha256
  // it will return something 1F:59:54:02:CF:28:F2:6D:72:37:86:10:41:99:48:FE:D5:07:BF:0A:12:E5:1A:16:13:D9:D4:39:6E:21:4E:CA
  static String get appBaseURL {
    switch (appFlavor) {
      case Flavor.dev:
        return 'http://192.168.238.54:3000/api';
      case Flavor.qa:
        return '';
      case Flavor.uat:
        return '';
      case Flavor.prod:
        return '';
    }
  }

  static String get s3BaseURL {
    switch (appFlavor) {
      case Flavor.dev:
        return '';
      case Flavor.qa:
        return '';
      case Flavor.uat:
        return '';
      case Flavor.prod:
        return '';
     
    }
  }
}
