class Validators {
  static bool isValidEmail(String strEmail) {
    bool bValid = false;

    strEmail = strEmail.trim();

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    bValid = RegExp(pattern).hasMatch(strEmail);

    return bValid;
  }
  
  static bool isValidURL(String strURL) {
    bool bValid = false;
    var urlPattern =
        r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    var match = RegExp(urlPattern, caseSensitive: false).firstMatch(strURL);
    if (match != null) {
      bValid = true;
    }

    return bValid;
  }

  static bool validatePhoneNumber(String phoneNumber, int length) {
    return phoneNumber.length == length;
  }
}