enum UploadStatus {
  none,
  uploading,
  uploaded,
  failed
}
class UploadFileResponseModel {
  String mediaUrl;
  String mediaType;
  String mediaId;
  bool fileUploaded;
  bool isNewMedia;
  bool shouldDelete;
  String mediaFileUrl;
  String filepath;
  UploadStatus uploadStatus ;


  UploadFileResponseModel({
    required this.mediaUrl,
    required this.mediaType,
    required this.mediaId,
    this.fileUploaded = false,
    this.shouldDelete = false,
    this.isNewMedia = true,
    this.mediaFileUrl = '',
    required this.filepath,
    required this.uploadStatus,
  });

  factory UploadFileResponseModel.empty() {
    return UploadFileResponseModel(
        mediaUrl: '',
        mediaType: '',
        mediaId: '',
        fileUploaded: false,
        uploadStatus: UploadStatus.none,
        filepath: "",
        mediaFileUrl: '');
  }
}
