// import 'dart:convert';
// import 'package:task_manager/core/helpers/utils.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/services.dart';

// String _key = 'hashes';

// class FirebaseRemoteAppConfig {
//   static String _data = '';
//   static initialise() async {
//     await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(seconds: 10),
//       minimumFetchInterval: Duration.zero,
//     ));
//     await FirebaseRemoteConfig.instance.fetchAndActivate();
//     if (getPublicCert().isEmpty) {
//       await FirebaseRemoteConfig.instance.setDefaults({
//         _key: jsonEncode(
//           [
//             "b64a42caa0fda623764a609b1853a4357f654c6ff0417a696b31a12ffcafd00f",
//           ],
//         )
//       });
//     }
//   }

//   static List<String> getPublicCert() {
//     if (_data.isEmpty) {
//       try {
//         _data = FirebaseRemoteConfig.instance.getString(_key);
//       } on PlatformException catch (exception) {
//         // Fetch exception.
//         Utils.printLogs(exception.toString());
//       } catch (exception) {
//         Utils.printLogs('Unable to listen to remote config. Cached or default values will be '
//             'used\n ${exception.toString()}');
//       }
//     }
//     Utils.printLogs("hashes ====== >$_data");
//     return _data.isNotEmpty ? List<String>.from(jsonDecode(_data).map((e) => e.toString())) : [];
//   }
// }
