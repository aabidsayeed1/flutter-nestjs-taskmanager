// All urls and its endpoints used in the app

// ignore_for_file: non_constant_identifier_names, constant_identifier_names
//============================================================================
import 'package:task_manager/app_imports.dart';
//============================================================================

class AppUrls {
  static String BASE_URL = F.appBaseURL;
  static String S3_BASE_URL = F.s3BaseURL;

  static String URL_SEND_FCM_TOKEN = "$BASE_URL/users/device-token";
  static String GET_APP_UPDATE = "$BASE_URL/app-update";
  static String LOGIN = "$BASE_URL/auth/login/phone-number";
  static String VERIFY_OTP = "$BASE_URL/auth/verify-otp";
  static String SEND_LOGS = "$BASE_URL/logs";
  static String URL_GET_REFRESH_TOKEN = "$BASE_URL/auth/refresh-token";
  static String USER_DETAILS = "$BASE_URL/users/profile";
  static String TASKS({String id = ''}) => "$BASE_URL/tasks${id.isEmpty ? '' : "/$id"}";
  static String SEARCH({String query = '',String type=''}) => "$BASE_URL/tasks/search?query=$query&type=$type";
  static String TASKS_BATCH = "$BASE_URL/tasks/batch";
  static String TASKS_BATCH_DELETE = "$BASE_URL/tasks/batch-delete";
}
