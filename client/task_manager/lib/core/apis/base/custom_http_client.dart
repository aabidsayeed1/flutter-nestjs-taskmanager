import 'dart:convert';
import 'dart:developer';

import 'package:task_manager/app_imports.dart';
// import 'package:task_manager/core/managers/firebase/firebase_remote_config.dart';
// import 'package:task_manager/core/managers/general/overlay_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class CustomHttpClient {
  http.Client _client = http.Client();
  static const Duration _requestTimeout = Duration(seconds: 30);

  initialise() async {
    if (F.appFlavor != Flavor.dev) {
      List<String> hashes = []; // FirebaseRemoteAppConfig.getPublicCert();
      if (hashes.isEmpty) {
        String localPublicCert =  F.getFallbackPublicCert;
        if (localPublicCert.isEmpty) {
          // HelperUI.showToast(msg: "Certificate pinning is not configured!", type: ToastType.error);
          Utils.printLogs(
            "Certificate pinning is not configured!, please check flavors.dart or configure firebase.",
          );
          return;
        } else {
          hashes = [localPublicCert];
        }
      } else {
        _client = _getClient(hashes);
      }
    }
    // Testing hashes
    // final response =
    //     await get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
    // Utils.printLogs(
    //     "hashes ======= data ${jsonDecode(response.body)['title']}");
  }

  SecureHttpClient _getClient(List<String> allowedSHAFingerprints) {
    final secureClient = SecureHttpClient.build(allowedSHAFingerprints);
    return secureClient;
  }

  static Map<String, int> customStatusCode = {"internet_failure": 600};

  Future refreshtoken({required Uri url, var bodyData, required String apiCalltype}) async {
    var requestBody = {
      'refresh_token': HelperUser.getRefreshToken(),
    };
    try {
      http.Response response = await post(
        Uri.parse(AppUrls.URL_GET_REFRESH_TOKEN),
        jsonEncode(requestBody),
      ).timeout(_requestTimeout);

      log(
        "Refresh Token API Call => ${AppUrls.URL_GET_REFRESH_TOKEN} \n Data sent in request => $requestBody \n Refresh Token API response => ${jsonEncode(response.body)}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);
        HelperUser.setAccessToken(jsonData["entity"]["access_token"]);
        HelperUser.setAuthToken(jsonData["entity"]["access_token"]);
        if (jsonData["entity"]["refresh_token"] != null) {
          HelperUser.setRefreshToken(jsonData["entity"]["refresh_token"]);
        }

        switch (apiCalltype) {
          case "post":
            return await post(url, bodyData);
          case "get":
            return await get(url);
          case "put":
            return await put(url, bodyData);
          case "patch":
            return await patch(url, bodyData);
          case "delete":
            return await delete(url, bodyData);
        }
      } else if (!jsonDecode(response.body)["status"]) {
        HelperUser.logout();
        throw Exception("Unauthorized");
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception("Bad Response Format!");
      } else {
        log("Refresh token request timed out: $e");
        rethrow;
      }
    }
  }

  Future<http.Response> get(Uri url, {bool showLogs = true}) async {
    try {
      var request =
          http.Request('GET', url)
            ..headers.addAll({
              AppStrings.STRING_CONTENT_TYPE: AppStrings.STRING_APPLICATION_JSON,
              AppStrings.STRING_ACCESS_TOKEN_KEY: HelperUser.getAccessToken(),
              AppStrings.STRING_HEADER_ACCEPT_LANGUAGE: HelperUser.getLocale(),
            });

      var streamedResponse = await _client.send(request).timeout(_requestTimeout);

      var response = await http.Response.fromStream(streamedResponse);
      if (showLogs) {
        log(
          "\nGET API Call => $url \nStatus Code => ${response.statusCode} \nAPI Response => ${response.body}",
        );
      }
      if (response.statusCode == 401) {
        return await refreshtoken(url: url, apiCalltype: 'get');
      }
      return response;
    } catch (e) {
      log("GET request timed out:\nGET API Call => $url \n $e");
      rethrow;
    }
  }

  Future<http.Response> post(Uri url, var bodyData, {bool showLogs = true}) async {
    if (url.toString() == AppUrls.SEND_LOGS) {
      var response = await _client.post(
        url,
        body: bodyData,
        headers: {
          AppStrings.STRING_CONTENT_TYPE: AppStrings.STRING_APPLICATION_JSON,
          AppStrings.STRING_ACCESS_TOKEN_KEY: HelperUser.getAccessToken(),
          AppStrings.STRING_HEADER_ACCEPT_LANGUAGE: HelperUser.getLocale(),
        },
      );
      if (showLogs) {
        log(
          "\nPOST API Call => $url \nStatus Code => ${response.statusCode} \nRequest Body => $bodyData \nAPI Response => ${response.body}",
        );
      }
      if (response.statusCode == 401) {
        return await refreshtoken(url: url, bodyData: bodyData, apiCalltype: 'post');
      }
      return response;
    } else {
      try {
        var response = await _client
            .post(
              url,
              body: bodyData,
              headers: {
                AppStrings.STRING_CONTENT_TYPE: AppStrings.STRING_APPLICATION_JSON,
                AppStrings.STRING_ACCESS_TOKEN_KEY: HelperUser.getAccessToken(),
                AppStrings.STRING_HEADER_ACCEPT_LANGUAGE: HelperUser.getLocale(),
              },
            )
            .timeout(_requestTimeout);

        if (showLogs) {
          log(
            "\nPOST API Call => $url \nStatus Code => ${response.statusCode} \nRequest Body => $bodyData \nAPI Response => ${response.body}",
          );
        }
        if (response.statusCode == 401) {
          return await refreshtoken(url: url, bodyData: bodyData, apiCalltype: 'post');
        }
        return response;
      } catch (e) {
        log("POST request timed out:\nPOST API Call => $url \n $e");
        rethrow;
      }
    }
  }

  Future<http.Response> patch(Uri url, var bodyData, {bool showLogs = true}) async {
    try {
      var response = await _client
          .patch(
            url,
            body: bodyData,
            headers: {
              AppStrings.STRING_CONTENT_TYPE: AppStrings.STRING_APPLICATION_JSON,
              AppStrings.STRING_ACCESS_TOKEN_KEY: HelperUser.getAccessToken(),
              AppStrings.STRING_HEADER_ACCEPT_LANGUAGE: HelperUser.getLocale(),
            },
          )
          .timeout(_requestTimeout);
      if (showLogs) {
        log(
          "\nPatch API Call => $url \nStatus Code => ${response.statusCode} \nRequest Body => $bodyData \nAPI Response => ${response.body}",
        );
      }
      if (response.statusCode == 401) {
        return await refreshtoken(url: url, bodyData: bodyData, apiCalltype: 'patch');
      }
      return response;
    } catch (e) {
      log("PATCH request timed out: \nPatch API Call => $url \n $e");
      rethrow;
    }
  }

  Future<http.Response> delete(Uri url, var bodyData, {bool showLogs = true}) async {
    try {
      var response = await _client
          .delete(
            url,
            body: bodyData,
            headers: {
              AppStrings.STRING_CONTENT_TYPE: AppStrings.STRING_APPLICATION_JSON,
              AppStrings.STRING_ACCESS_TOKEN_KEY: HelperUser.getAccessToken(),
              AppStrings.STRING_HEADER_ACCEPT_LANGUAGE: HelperUser.getLocale(),
            },
          )
          .timeout(_requestTimeout);
      if (showLogs) {
        log(
          "\nDelete API Call => $url \nStatus Code => ${response.statusCode} \nRequest Body => $bodyData \nAPI Response => ${response.body}",
        );
      }
      if (response.statusCode == 401) {
        return await refreshtoken(url: url, bodyData: bodyData, apiCalltype: 'delete');
      }
      return response;
    } catch (e) {
      log("DELETE request timed out: \nDelete API Call => $url \n $e");
      rethrow;
    }
  }

  Future<http.Response> put(Uri url, var bodyData, {bool showLogs = true}) async {
    try {
      var response = await _client
          .put(
            url,
            body: bodyData,
            headers: {
              AppStrings.STRING_CONTENT_TYPE: AppStrings.STRING_APPLICATION_JSON,
              AppStrings.STRING_ACCESS_TOKEN_KEY: HelperUser.getAccessToken(),
              AppStrings.STRING_HEADER_ACCEPT_LANGUAGE: HelperUser.getLocale(),
            },
          )
          .timeout(_requestTimeout);
      if (showLogs) {
        log(
          "\nUpdate API Call => $url \nStatus Code => ${response.statusCode} \nRequest Body => $bodyData \nAPI Response => ${response.body}",
        );
      }
      if (response.statusCode == 401) {
        return await refreshtoken(url: url, bodyData: bodyData, apiCalltype: 'put');
      }
      return response;
    } catch (e) {
      log("PUT request timed out: \nUpdate API Call => $url \n $e");
      rethrow;
    }
  }
}
