import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum MediaSource { camera, gallery, pdf }

enum MediaType { image, video }

enum MediaPickerResultType { picked, removed, cancelled, remoteRemoved }

class MediaPickerResult {
  MediaPickerResultType resultType;
  File? selectedFile;
  MediaPickerResult({required this.resultType, this.selectedFile});
}

class MediaPickerManager {
  static Future<File?> getMedia({
    required MediaSource mediaSource,
    required MediaType mediaType,
  }) async {
    File? _file;
    //will not be used so often so keeping it func instead of making it static
    ImagePicker _picker = ImagePicker();

    if (mediaType == MediaType.image) {
      if (mediaSource == MediaSource.gallery) {
        return _validateXFile(await _picker.pickImage(source: ImageSource.gallery));
      } else if (mediaSource == MediaSource.camera) {
        return _validateXFile(await _picker.pickImage(source: ImageSource.camera));
      } else if (mediaSource == MediaSource.pdf) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          return File(result.files.first.path!);
        }
        return null;
      }
    } else if (mediaType == MediaType.video) {
      if (mediaSource == MediaSource.gallery) {
        return _validateXFile(await _picker.pickVideo(source: ImageSource.gallery));
      } else {
        return _validateXFile(await _picker.pickVideo(source: ImageSource.camera));
      }
    }

    return _file;
  }

  static File? _validateXFile(XFile? file) {
    if (file != null && file.path.isNotEmpty) {
      return File(file.path);
    }
    return null;
  }

  static Future<MediaPickerResult?> selectFile(
    BuildContext context, {
    bool allowPDF = false,
    isFileSelected = false,
    bool isRemoteImageRemovable = false,
  }) async {
    return await showModalBottomSheet(
      context: context,
      builder: (modelContext) {
        return _createModalSheet(
          context,
          "",
          allowPDF: allowPDF,
          isFileSelected: isFileSelected,
          isRemoteImageRemovable: isRemoteImageRemovable,
        );
      },
    );
  }

  static Widget _createModalSheet(
    BuildContext context,
    String strTitle, {
    bool isFileSelected = false,
    bool allowPDF = false,
    bool isRemoteImageRemovable = false,
    // Function? onRemoteRemoveSelected,
  }) {
    MediaPickerResult mediaPickerResult = MediaPickerResult(
      resultType: MediaPickerResultType.cancelled,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 24, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(strTitle, style: const TextStyle(fontSize: 16), textAlign: TextAlign.left),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () async {
              File? file = await getMedia(
                mediaSource: MediaSource.gallery,
                mediaType: MediaType.image,
              );
              if (file != null) {
                mediaPickerResult.selectedFile = file;
                mediaPickerResult.resultType = MediaPickerResultType.picked;
              }
              CustomNavigator.pop(context, result: mediaPickerResult);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Camera'),
            onTap: () async {
              File? file = await getMedia(
                mediaSource: MediaSource.camera,
                mediaType: MediaType.image,
              );
              if (file != null) {
                mediaPickerResult.selectedFile = file;
                mediaPickerResult.resultType = MediaPickerResultType.picked;
              }
              CustomNavigator.pop(context, result: mediaPickerResult);
            },
          ),
          if (allowPDF)
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded),
              title: const Text('PDF'),
              onTap: () async {
                File? file = await getMedia(
                  mediaSource: MediaSource.pdf,
                  mediaType: MediaType.image,
                );
                if (file != null) {
                  mediaPickerResult.selectedFile = file;
                  mediaPickerResult.resultType = MediaPickerResultType.picked;
                }
                CustomNavigator.pop(context, result: mediaPickerResult);
              },
            ),
          if (isFileSelected || isRemoteImageRemovable)
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: const Text('Remove Selected'),
              onTap: () {
                if (isFileSelected) {
                  mediaPickerResult.resultType = MediaPickerResultType.removed;
                } else {
                  mediaPickerResult.resultType = MediaPickerResultType.remoteRemoved;
                }
                CustomNavigator.pop(context, result: mediaPickerResult);
              },
            ),
        ],
      ),
    );
  }
}
