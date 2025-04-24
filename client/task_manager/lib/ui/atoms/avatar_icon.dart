import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app_imports.dart';

class AvatarIcon extends StatelessWidget {
  final AvatarShapes shape;
  final AvatarSource source;
  final String? imageURL;
  final double dTextFontSize;
  final double height;
  final double width;
  final double dBorderRadius;
  final VoidCallback? clickAction;
  final Color borderColor;
  final Color backGroundColor;

  const AvatarIcon(
      {Key? key,
      this.shape = AvatarShapes.Square, // Default
      required this.imageURL,
      this.dBorderRadius = AppValues.AVATAR_ICON_CORNER_RADIUS,
      this.clickAction = _defaultFunction,
      this.borderColor = Colors.white,
      this.backGroundColor = Colors.transparent,
      this.width = 100,
      this.height = 100,
      this.dTextFontSize = 44,
      this.source = AvatarSource.Network})
      : super(key: key);

  static _defaultFunction() {
    // Does nothing
  }

  @override
  Widget build(BuildContext context) {
    if (shape == AvatarShapes.Square) {
      return createAvatarIconForStandardOrSquareView();
    } else {
      return createAvatarIconForCircularView();
    }
  }

  Widget createAvatarIconForStandardOrSquareView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(dBorderRadius),
      child: (imageURL != null && imageURL!.isNotEmpty)
          ? source == AvatarSource.File
              ? Image.file(
                  File(imageURL!),
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                )
              : source == AvatarSource.Asset
                  ? Image.asset(
                      imageURL!,
                      height: height,
                      width: width,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageURL!,
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                      placeholder: (context, url) =>
                          Container(child: HelperUI.getProgressIndicator()),
                    )
          : Image.asset(
              AppImages.STRING_ICON_PLACEHOLDER,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget createAvatarIconForCircularView() {
    return InkWell(
        onTap: clickAction,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: (imageURL != null && imageURL!.isNotEmpty)
                  ? borderColor
                  : Colors.transparent,
            ),
          ),
          child: (imageURL != null && imageURL!.isNotEmpty)
              ? CircleAvatar(
                  minRadius: 20,
                  maxRadius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: (source == AvatarSource.File
                          ? FileImage(
                              File(imageURL!),
                            )
                          : source == AvatarSource.Asset
                              ? AssetImage(
                                  imageURL!,
                                )
                              : CachedNetworkImageProvider(imageURL!))
                      as ImageProvider)
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset(AppImages.STRING_ICON_PLACEHOLDER),
                ),
        ));
  }
}

//
// factory AvatarIcon.circular(
//     {required String strPicInfo, VoidCallback? clickAction}) {
//   return AvatarIcon(
//       strPicInfo: strPicInfo,
//       shape: AvatarShapes.Circular,
//       clickAction: clickAction);
// }
//
// factory AvatarIcon.square({
//   required String strPicInfo,
//   VoidCallback? clickAction,
//   AvatarSource source = AvatarSource.Network,
//   double? height,
//   double? width,
// }) {
//   return AvatarIcon(
//     strPicInfo: strPicInfo,
//     source: source,
//     height: height,
//     width: width,
//     clickAction: clickAction,
//     shape: AvatarShapes.Square,
//   );
// }
//
// factory AvatarIcon.profile(
//     {required String strPicInfo,
//     Color backGroundColor = Colors.transparent,
//     VoidCallback? clickAction,
//     double dTextFontSize = 44}) {
//   return AvatarIcon(
//     strPicInfo: strPicInfo,
//     shape: AvatarShapes.Profile,
//     clickAction: clickAction,
//     backGroundColor: backGroundColor,
//     dTextFontSize: dTextFontSize,
//   );
// }
//
// factory AvatarIcon.file(
//     {required String strPath, VoidCallback? clickAction}) {
//   return AvatarIcon(
//       strPicInfo: strPath,
//       shape: AvatarShapes.File,
//       clickAction: clickAction);
// }
//
// factory AvatarIcon.asset(
//     {required String strPath, VoidCallback? clickAction}) {
//   return AvatarIcon(
//       strPicInfo: strPath,
//       shape: AvatarShapes.Asset,
//       clickAction: clickAction);
// }

// Widget createAvatarIconForFile() {
//   return InkWell(
//       onTap: clickAction,
//       child: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: imageURL.isNotEmpty ? borderColor : Colors.transparent,
//             ),
//           ),
//           child: CircleAvatar(
//             backgroundColor: Colors.grey, // TBD
//             backgroundImage:
//                 Image.file(File(imageURL), fit: BoxFit.contain).image,
//           )));
// }

// Widget createAvatarIconForAsset() {
//   return InkWell(
//       onTap: clickAction,
//       child: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: (imageURL!= null && imageURL!.isNotEmpty) ? borderColor : Colors.transparent,
//             ),
//           ),
//           child: CircleAvatar(
//             backgroundColor: Colors.grey, // TBD
//             backgroundImage:
//                 Image.asset(imageURL, fit: BoxFit.contain).image,
//           )));
// }

// Widget createAvatarIconForProfileView() {
//   return InkWell(
//       onTap: clickAction,
//       child: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: backGroundColor,
//             border: Border.all(
//               color: imageURL.isNotEmpty ? borderColor : Colors.transparent,
//             ),
//           ),
//           child: Center(
//               child: Text(
//             imageURL,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: dTextFontSize,
//                 fontStyle: FontStyle.normal),
//           ))));
// }
