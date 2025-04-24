// ignore_for_file: constant_identifier_names

// All strings used local to the app, not what is seen on the uI
//==========================================================
class AppStrings {
  // App version
  static const BUNDLE_ANDROID_APP = "com.task_manager.appio";
  static const BUNDLE_IOSAPP = "";

  // Date Formats
  static const STRING_DATE_MONTH_YEAR = "dd MMM yyyy";
  static const STRING_YEAR_MONTH_DATE = "yyyy-MM-dd";

  // Shared Prefs
  static const STRING_KEY_FCMTOKEN = "fcmToken";
  static const String USER_TOKEN = "token";
  static const String USER_ID = "id";
  static const String USER_NAME = "username";
  static const String USER_LOCALE = "locale";
  static const String USER_SETUP_ID = "setupID";
  static const String USER_USER_SETUP_ID = "userSetupID";
  static const String USER_IS_SKIPPED = "isSkipped";
  static const String USER_COUNTRY_CODE = "+91 ";
  // Face id
  static const String FACE_ID_LOGIN_SELECTED = "faceIdLogin";
  static const String USER_MOBILE = "mobile";
  static const String STRING_KEY_FACEID_TOKEN = 'faceidToken';

  //UserRole
  static const String USER_ROLE = "userRole";

  //
  static const String STRING_KEY_REFRESH_TOKEN = 'refreshToken';
  static const String STRING_KEY_ACCESS_TOKEN = 'accessToken';

  // Language
  static const String STRING_LANGUAGE = 'language';
  static const String STRING_HEADER_ACCEPT_LANGUAGE = "Accept-Language";

  // HTTP keys
  static const String STRING_CONTENT_TYPE = "Content-Type";
  static const String STRING_APPLICATION_JSON = "application/json";
  // static const String STRING_ACCESS_TOKEN_KEY = "x-access-token";
  static const String STRING_ACCESS_TOKEN_KEY = "Authorization";
  static const String STRING_HTTP_METHOD_POST = "POST";

  static const String CONTENT_TYPE = "Content-Type";

  // Upload to S3
  static const KEY_FILE = "file";
  static const KEY_ACL = "acl";
  static const ACL_PUBLIC_READ = "public-read";

  // Debounce strings
  static const String STRING_DEBOUNCE_PRIMARY_BUTTON = "primaryButton";

  //Drop Down
  static const String STRING_HINT_MESSAGE = "Select";

  //Prefixes
  static const String PREFIX_FOR_UPLOAD = "upload";

  // Errors
  static const String ERROR_GENERAL_FAILURE = 'Something went wrong. Please try after sometime';
  static const String ERROR_SERVER_FAILURE = 'Server Failure';
  static const String ERROR_INTERNAL_SERVER_FAILURE = 'Server Failure';
  static const String ERROR_NOT_IMPLEMENTED = 'Not Implemented';
  static const String ERROR_NOT_FOUND = 'End point not found';
  static const String ERROR_BAD_REQUEST = 'Bad Request';
  static const String ERROR_INTERNET_FAILURE = "Please check your connectivity and try again later";
  static const String ERROR_LOCATION_FAILURE =
      "Location is disabled, please turn on location and try again";
  static const String ERROR_SOME_THING_WENT_WRONG = 'Something went wrong';
  static const String ERROR_TIME_OUT =
      'The request took too long to respond. Please check your internet connection and try again.';
  static const String ERROR_HTTP_EXCEPTION =
      'Could not fetch data from the server. Please try again.';
  static const String ERROR_UNAUTHORIZED =
      'Your session has expired. Please log in again to continue.';

  static const String ERROR_NO_ACCESS = "Access denied";

  // Pairing modes
  static const String STRING_PAIRING_MODE_AP = "AP Mode";
  static const String STRING_PAIRING_MODE_EZ = "EZ Mode";

  // Invite types
  static const String STRING_ADMIN = "Admin";
  static const String STRING_USER = "User";
  static const String STRING_OWNER = "Owner";

  // Status types
  static const String STRING_PENDING = "Pending";
  static const String STRING_REVOKED = "Revoked";

  // Cash out history status types
  static const String STRING_CASHOUT_FAILED = "Failed";
  static const String STRING_CASHOUT_PROCESSING = "Processing";
  static const String STRING_CASHOUT_REJECTED = "Rejected";
  static const String STRING_CASHOUT_COMPLETED = "Completed";
  static const String STRING_CASHOUT_INITIATED = "Initiated";

  // Deep link types
  static const String STRING_DEEPLINK_INVITE = "invite";
  static const String STRING_DEEPLINK_DISCOM_LINK = "discom_link";

  // Devices supported
  static const String STRING_DEVICE_TUYA = "TUYA";
  static const String STRING_DEVICE_SMARTTHINGS = "SMARTTHINGS";
  static const String STRING_DEVICE_TATA = "TATA";
}
