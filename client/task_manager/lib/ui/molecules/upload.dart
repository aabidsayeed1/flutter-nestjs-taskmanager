import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/generic/upload/models/upload_file_reponse_model.dart';
import '../../core/managers/general/custom_media_picker_manager.dart';
import '../app_widgets/media_view.dart';
import '../atoms/button.dart';
import 'package:shimmer/shimmer.dart';

class Upload extends StatefulWidget {
  final int maxFiles;
  final Function callBack;
  final List<UploadFileResponseModel> uploadFilesResponseList;
  final MediaSource? mediaSource;
  const Upload({
    Key? key,
    this.maxFiles = 10,
    required this.callBack,
    required this.uploadFilesResponseList,
    this.mediaSource,
  }) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  List<MediaPickerResult> mediaPickerResult = [];
  bool _showWarning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.OFF_WHITE_F4F4F5,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.BASICWHITE,
        leading: InkWell(
          onTap: () => CustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: AppColors.BLACK),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Button(
            strButtonText: 'Select Files',
            size: ButtonSize.medium,
            buttonAction: () async {
              List<MediaPickerResult>? result = [];
              result = await CustomMediaPickerManager.selectFile(
                context,
                maxFiles: widget.maxFiles,
                mediaSource: widget.mediaSource,
              );
              if (result != null) {
                if ((result.length + mediaPickerResult.length) > (widget.maxFiles)) {
                  setState(() {
                    _showWarning = true;
                  });
                } else {
                  setState(() {
                    mediaPickerResult = [...?result, ...mediaPickerResult];
                    _showWarning = false;
                  });
                  widget.callBack(mediaPickerResult);
                }
              }
            },
          ),
          CustomSpacers.height10,
          (_showWarning) ? _warningWidget() : Container(),
          CustomSpacers.height2,
          _filePreview(),
        ],
      ),
    );
  }

  Widget _warningWidget() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.error, color: Colors.redAccent),
              CustomSpacers.width6,
              Text(
                "Max File Selection is only ${widget.maxFiles}",
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showWarning = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _filePreview() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 6.h,
          crossAxisSpacing: 6.w,
        ),
        itemCount: mediaPickerResult.length,
        itemBuilder: (BuildContext context, int index) {
          UploadStatus uploadStatus = UploadStatus.none;
          try {
            UploadFileResponseModel responseModel = widget.uploadFilesResponseList.firstWhere(
              (file) => file.filepath == mediaPickerResult[index].selectedFile!.path,
            );
            uploadStatus = responseModel.uploadStatus;
          } catch (e) {
            Utils.printLogs(e.toString());
          }

          return (mediaPickerResult[index].selectedFile != null)
              ? GestureDetector(
                onTap: () {
                  if (uploadStatus == UploadStatus.none || uploadStatus == UploadStatus.uploaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MediaView(medias: mediaPickerResult, index: index),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    Container(height: 10.h),
                    Positioned(
                      top: 10.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            uploadStatus == UploadStatus.uploading
                                ? _shimmerWidget(
                                  file: mediaPickerResult[index].selectedFile!,
                                  uploadStatus: uploadStatus,
                                )
                                : _image(
                                  file: mediaPickerResult[index].selectedFile!,
                                  uploadStatus: uploadStatus,
                                ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child:
                          uploadStatus == UploadStatus.uploading
                              ? Container()
                              : GestureDetector(
                                onTap: () {
                                  if (uploadStatus == UploadStatus.none) {
                                    mediaPickerResult.removeAt(index);
                                    setState(() {
                                      mediaPickerResult = mediaPickerResult;
                                    });
                                    widget.callBack(mediaPickerResult);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        uploadStatus == UploadStatus.uploaded
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  child: Icon(
                                    (uploadStatus == UploadStatus.uploaded)
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              )
              : null;
        },
      ),
    );
  }

  Widget _image({required file, required uploadStatus}) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: EdgeInsets.all(uploadStatus == UploadStatus.failed ? 4 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: uploadStatus == UploadStatus.failed ? Colors.red : Colors.black45,
        ),
      ),
      child: Image.file(file, fit: BoxFit.cover, height: 150.h, width: 160.w),
    );
  }

  _shimmerWidget({required file, required uploadStatus}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: _image(file: file, uploadStatus: uploadStatus),
    );
  }
}
