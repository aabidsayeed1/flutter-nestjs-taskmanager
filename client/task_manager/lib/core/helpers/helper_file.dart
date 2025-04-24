import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_manager/app_imports.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:task_manager/route/global_navigator.dart';

class HelperFile {
  static Future<String> getTempFilePath({
    String strPrefixFileName = "",
    String? strFile,
    String? extension,
  }) async {
    String directory;
    String? fileExtension;

    if (extension != null) {
      fileExtension = extension;
    }
    var randomExtension = Random().nextInt(100000 - 10).toString();
    String fileName =
        "${strPrefixFileName}_${HelperUser.getUserId()}_$randomExtension.${fileExtension!}";

    if (Platform.isAndroid) {
      // Handle this part the way you want to save it in any directory you wish.
      final List<Directory>? dir = await path.getExternalCacheDirectories();
      directory = dir!.first.path;
      return File('$directory/$fileName').path;
    } else {
      final Directory dir = await path.getTemporaryDirectory();
      directory = dir.path;
      return File('$directory/$fileName').path;
    }
  }

  static Future<XFile?> compressFile(String strMediaType, String strInput, String strOutput) async {
    XFile? compressedResult;
    if (strMediaType == "video") {
    } else {
      compressedResult = await FlutterImageCompress.compressAndGetFile(
        strInput,
        strOutput,
        minWidth: 1080,
        minHeight: 720,
        quality: 30,
      );
    }
    return compressedResult;
  }

  static Future<void> deleteFile(String filePath) async {
    File fileToDelete = File(filePath);
    try {
      if (await fileToDelete.exists()) {
        await fileToDelete.delete();
        Utils.printLogs("file deleted at path: $filePath");
      }
    } catch (e) {
      Utils.printLogs("failed to delete file at path: $e");
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String tr({BuildContext? context, Map<String, String>? args}) {
    BuildContext? navigatorContext =
        context ?? sl<NavigationService>().navigatorKey.currentState?.context;

    if (navigatorContext == null) {
      debugPrint("Localization context is null for key: $this");
      return this;
    }
    return Utils.getLocalizedString(navigatorContext, this, args: args);
  }
}

extension ChartNumberFormatter on double {
  String formatNumberAbbreviation({bool noDecimal = false}) {
    String format(double value, String suffix) {
      return noDecimal ? "${value.toInt()}$suffix" : "${value.toStringAsFixed(1)}$suffix";
    }

    if (this >= 1000000000) {
      return format(this / 1000000000, "B"); // Billion
    } else if (this >= 1000000) {
      return format(this / 1000000, "M"); // Million
    } else if (this >= 1000) {
      return format(this / 1000, "K"); // Thousand
    } else if (this <= 1 && this != 0) {
      return toStringAsFixed(2); // Small values with 2 decimal places
    } else {
      return toInt().toString(); // Normal integers
    }
  }
}
