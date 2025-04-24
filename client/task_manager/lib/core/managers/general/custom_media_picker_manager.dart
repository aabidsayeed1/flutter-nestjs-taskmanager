// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../ui/app_widgets/svg_icon_button.dart';

enum MediaSource { camera, gallery, pdf }

enum MediaPickerResultType { picked, removed, cancelled, remoteRemoved }

class MediaPickerResult {
  MediaPickerResultType resultType;
  File? selectedFile;
  CustomMediaType? mediaType;
  String? networkUrl;
  Uint8List? imageBytes;
  MediaPickerResult({
    required this.resultType,
    this.selectedFile,
    this.mediaType,
    this.networkUrl,
    this.imageBytes,
  });
}

class CustomMediaPickerManager {
  static Future<List<File?>?> getMedia({
    required MediaSource mediaSource,
    required CustomMediaType mediaType,
    int? maxFiles,
  }) async {
    File? file;
    //will not be used so often so keeping it func instead of making it static
    ImagePicker picker = ImagePicker();

    if (mediaType == CustomMediaType.image) {
      if (mediaSource == MediaSource.gallery) {
        if (maxFiles == null || maxFiles == 1) {
          return _validateXFile(file: await picker.pickImage(source: ImageSource.gallery));
        } else {
          return _validateXFile(files: await picker.pickMultiImage());
        }
      } else if (mediaSource == MediaSource.camera) {
        return _validateXFile(file: await picker.pickImage(source: ImageSource.camera));
      } else if (mediaSource == MediaSource.pdf) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          List<File> filesList = [File(result.files.first.path!)];
          return filesList;
        }
        return null;
      }
    } else if (mediaType == CustomMediaType.video) {
      if (mediaSource == MediaSource.gallery) {
        return _validateXFile(file: await picker.pickVideo(source: ImageSource.gallery));
      } else {
        return _validateXFile(file: await picker.pickVideo(source: ImageSource.camera));
      }
    }

    return <File?>[file];
  }

  static List<File>? _validateXFile({XFile? file, List<XFile>? files}) {
    List<File> filesList = [];
    if (file != null && file.path.isNotEmpty) {
      filesList.add(File(file.path));
      return filesList;
    } else if (files != null) {
      for (var element in files) {
        filesList.add(File(element.path));
      }
      return filesList;
    }
    return null;
  }

  static Future<List<MediaPickerResult>?> selectFile(
    BuildContext context, {
    bool allowPDF = false,
    isFileSelected = false,
    bool isRemoteImageRemovable = false,
    int? maxFiles,
    MediaSource? mediaSource,
  }) async {
    List<MediaPickerResult> mediaPickerResult = [];
    if (mediaSource == MediaSource.gallery) {
      List<File?>? files = await getMedia(
        mediaSource: MediaSource.gallery,
        mediaType: CustomMediaType.image,
        maxFiles: maxFiles,
      );
      if (files != null) {
        for (var file in files) {
          MediaPickerResult result = MediaPickerResult(resultType: MediaPickerResultType.cancelled);
          result.selectedFile = file;
          result.resultType = MediaPickerResultType.picked;
          result.mediaType = CustomMediaType.image;
          mediaPickerResult.add(result);
        }
      }
    } else {
      List<File?>? files = await getMedia(
        mediaSource: MediaSource.camera,
        mediaType: CustomMediaType.image,
        maxFiles: maxFiles,
      );
      if (files != null) {
        for (var file in files) {
          MediaPickerResult result = MediaPickerResult(resultType: MediaPickerResultType.cancelled);
          result.selectedFile = file;
          result.resultType = MediaPickerResultType.picked;
          result.mediaType = CustomMediaType.image;
          mediaPickerResult.add(result);
        }
      }
    }
    return mediaPickerResult;
    // return await showModalBottomSheet(
    //     context: context,
    //     builder: (modelContext) {
    //       return createModalSheet(context, "",
    //           allowPDF: allowPDF,
    //           maxFiles: maxFiles,
    //           isFileSelected: isFileSelected,
    //           mediaSource: mediaSource,
    //           isRemoteImageRemovable: isRemoteImageRemovable);
    //     });
  }

  static Widget createModalSheet(
    BuildContext context,
    String strTitle, {
    bool isFileSelected = false,
    bool allowPDF = false,
    bool isRemoteImageRemovable = false,
    MediaSource? mediaSource,
    int? maxFiles,
  }) {
    List<MediaPickerResult> mediaPickerResult = [];
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 24, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomSpacers.height12,
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Add media', style: TextStyle(color: Colors.black)),
            ),
            CustomSpacers.height12,
            if (mediaSource == null || mediaSource == MediaSource.gallery)
              ListTile(
                leading: const SvgIconButton(
                  assetString: AppImages.STRING_ICON_GALLERY,
                  color: AppColors.PRIMARY_COLOR,
                ),
                title: const Text(
                  "Gallery",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () async {
                  List<File?>? files = await getMedia(
                    mediaSource: MediaSource.gallery,
                    mediaType: CustomMediaType.image,
                    maxFiles: maxFiles,
                  );
                  if (files != null) {
                    for (var file in files) {
                      MediaPickerResult result = MediaPickerResult(
                        resultType: MediaPickerResultType.cancelled,
                      );
                      result.selectedFile = file;
                      result.resultType = MediaPickerResultType.picked;
                      result.mediaType = CustomMediaType.image;
                      mediaPickerResult.add(result);
                    }
                  }
                  CustomNavigator.pop(context, result: mediaPickerResult);
                },
              ),
            if (mediaSource == null || mediaSource == MediaSource.camera)
              ListTile(
                leading: const SvgIconButton(
                  assetString: AppImages.STRING_ICON_CAMERA,
                  color: AppColors.PRIMARY_COLOR,
                ),
                title: const Text(
                  "Camera",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () async {
                  List<File?>? files = await getMedia(
                    mediaSource: MediaSource.camera,
                    mediaType: CustomMediaType.image,
                    maxFiles: maxFiles,
                  );
                  if (files != null) {
                    for (var file in files) {
                      MediaPickerResult result = MediaPickerResult(
                        resultType: MediaPickerResultType.cancelled,
                      );
                      result.selectedFile = file;
                      result.resultType = MediaPickerResultType.picked;
                      result.mediaType = CustomMediaType.image;
                      mediaPickerResult.add(result);
                    }
                  }
                  CustomNavigator.pop(context, result: mediaPickerResult);
                },
              ),
          ],
        ),
      ),
    );
  }

  // static Widget _createModalSheet(BuildContext context, String strTitle,
  //     {bool isFileSelected = false,
  //     bool allowPDF = false,
  //     bool isRemoteImageRemovable = false,
  //     int? maxFiles}) {
  //   List<MediaPickerResult> mediaPickerResult = [];
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8, right: 8, bottom: 24, top: 16),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Container(
  //             width: double.infinity,
  //             padding: const EdgeInsets.only(left: 20.0),
  //             child: Text(
  //               strTitle,
  //               style: const TextStyle(fontSize: 16),
  //               textAlign: TextAlign.left,
  //             )),
  //         ListTile(
  //           leading: const Icon(Icons.photo),
  //           title: const Text('Gallery'),
  //           onTap: () async {
  //             List<File?>? files = await getMedia(
  //                 mediaSource: MediaSource.gallery,
  //                 mediaType: CustomMediaType.image,
  //                 maxFiles: maxFiles);
  //             if (files != null) {
  //               for (var file in files) {
  //                 MediaPickerResult result = MediaPickerResult(
  //                     resultType: MediaPickerResultType.cancelled);
  //                 result.selectedFile = file;
  //                 result.resultType = MediaPickerResultType.picked;
  //                 result.mediaType = CustomMediaType.image;
  //                 mediaPickerResult.add(result);
  //               }
  //             }
  //             CustomNavigator.pop(context, result: mediaPickerResult);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt_outlined),
  //           title: const Text('Camera'),
  //           onTap: () async {
  //             List<File?>? files = await getMedia(
  //                 mediaSource: MediaSource.camera,
  //                 mediaType: CustomMediaType.image,
  //                 maxFiles: maxFiles);
  //             if (files != null) {
  //               files.forEach((file) {
  //                 MediaPickerResult result = MediaPickerResult(
  //                     resultType: MediaPickerResultType.cancelled);
  //                 result.selectedFile = file;
  //                 result.resultType = MediaPickerResultType.picked;
  //                 result.mediaType = CustomMediaType.image;
  //                 mediaPickerResult.add(result);
  //               });
  //             }
  //             CustomNavigator.pop(context, result: mediaPickerResult);
  //           },
  //         ),
  //         if (allowPDF)
  //           ListTile(
  //             leading: const Icon(Icons.picture_as_pdf_rounded),
  //             title: const Text('PDF'),
  //             onTap: () async {
  //               List<File?>? files = await getMedia(
  //                   mediaSource: MediaSource.pdf,
  //                   mediaType: CustomMediaType.image,
  //                   maxFiles: maxFiles);
  //               if (files != null) {
  //                 files.forEach((file) {
  //                   MediaPickerResult result = MediaPickerResult(
  //                       resultType: MediaPickerResultType.cancelled);
  //                   result.selectedFile = file;
  //                   result.resultType = MediaPickerResultType.picked;
  //                   result.mediaType = CustomMediaType.image;
  //                   mediaPickerResult.add(result);
  //                 });
  //               }
  //               CustomNavigator.pop(context, result: mediaPickerResult);
  //             },
  //           ),
  //         // if (isFileSelected || isRemoteImageRemovable)
  //         //   ListTile(
  //         //     leading: const Icon(Icons.delete_forever_outlined),
  //         //     title: const Text('Remove Selected'),
  //         //     onTap: () {
  //         //       if (isFileSelected) {
  //         //         mediaPickerResult.resultType = MediaPickerResultType.removed;
  //         //       } else {
  //         //         mediaPickerResult.resultType =
  //         //             MediaPickerResultType.remoteRemoved;
  //         //       }
  //         //       CustomNavigator.pop(context, result: mediaPickerResult);
  //         //     },
  //         //   ),
  //       ],
  //     ),
  //   );
  // }
}
