import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

import '../automation_constants.dart';

class Avatar extends StatelessWidget {
  final AvatarSize avatarSize;
  final AvatarType avatarType;
  final AvatarShape avatarShape;
  final AvatarBadge avatarBadge;
  final String? strAvatarText;
  final String strImageSrc;
  final String? strBadgeNumeric;
  final double? dHeight;
  final double? dWidth;
  final double? dBorderRadius;
  final Color bgColor;
  final TextStyle? avatarTextStyle;
  final TextStyle? badgeTextStyle;
  final Color badgeColor;
  final double dBadgeDotHeight;
  final double dBadgeDotWidth;
  final Widget? icon;
  final VoidCallback? clickAction;
  final bool cacheImage;
  final BoxFit? boxFit;
  const Avatar({
    Key? key,
    this.avatarShape = AvatarShape.circle,
    this.avatarBadge = AvatarBadge.none,
    this.avatarType = AvatarType.text,
    this.avatarSize = AvatarSize.medium,
    this.strAvatarText,
    required this.strImageSrc,
    this.strBadgeNumeric,
    this.dWidth,
    this.dHeight,
    this.bgColor = AppColors.AVATAR_TEXT_BG,
    this.avatarTextStyle,
    this.badgeColor = AppColors.AVATAR_BADGE_COLOR,
    this.dBadgeDotHeight = AppValues.AVATAR_BADGE_DOT_HEIGHT,
    this.dBadgeDotWidth = AppValues.AVATAR_BADGE_DOT_WIDTH,
    this.dBorderRadius,
    this.icon,
    this.clickAction,
    this.badgeTextStyle,
    this.cacheImage = true,
    this.boxFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.AVATAR,
      child: GestureDetector(
        onTap: () {
          if (clickAction != null) {
            clickAction!();
          }
        },
        child: SizedBox(
          height: dHeight ?? avatarHeight(avatarSize),
          width: dWidth ?? avatarWidth(avatarSize),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (avatarType == AvatarType.image) _imageWidget(),
              if (avatarType == AvatarType.icon) _iconWidget(),
              if (avatarType == AvatarType.text) _textWidget(),
              if (avatarBadge == AvatarBadge.dot)
                Positioned(
                  top:
                      avatarShape == AvatarShape.circle
                          ? avatarBadgeDotPosition(avatarSize)[0]
                          : -3,
                  right:
                      avatarShape == AvatarShape.circle
                          ? avatarBadgeDotPosition(avatarSize)[1]
                          : -3,
                  child: Container(
                    height: avatarBadge == AvatarBadge.numeric ? null : 6,
                    width: avatarBadge == AvatarBadge.numeric ? null : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.BASICWHITE),
                      color: badgeColor,
                    ),
                  ),
                ),
              if (avatarBadge == AvatarBadge.numeric)
                Positioned(
                  top: avatarBadgeNumericPosition(avatarSize, avatarShape)[0],
                  right: avatarBadgeNumericPosition(avatarSize, avatarShape)[1],
                  child: Container(
                    height: avatarBadgeHeight(avatarSize).height,
                    width: avatarBadgeHeight(avatarSize).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.BASICWHITE),
                      color: badgeColor,
                    ),
                    child: Center(
                      child: Text(strBadgeNumeric ?? "", style: AppStyles.badgeTextStyle),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconWidget() {
    return avatarShape == AvatarShape.square
        ? Container(
          color: bgColor,
          height: dHeight ?? avatarHeight(avatarSize),
          width: dWidth ?? avatarWidth(avatarSize),
          child: ClipRRect(
            child: Padding(padding: EdgeInsets.all(avatarIconPadding(avatarSize)), child: icon),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: avatarHeight(avatarSize) / 2,
            child: Padding(padding: EdgeInsets.all(avatarIconPadding(avatarSize)), child: icon),
          ),
        );
  }

  Widget _imageWidget() {
    return SizedBox(
      height: dHeight ?? avatarHeight(avatarSize),
      width: dWidth ?? avatarWidth(avatarSize),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          dBorderRadius ?? (avatarShape == AvatarShape.circle ? 100 : 2),
        ),
        child: _mapImageSrc(),
      ),
    );
  }

  Widget _textWidget() {
    return avatarShape == AvatarShape.square
        ? Container(
          color: bgColor,
          height: dHeight ?? avatarHeight(avatarSize),
          width: dWidth ?? avatarWidth(avatarSize),
          child: Center(
            child: ClipRRect(
              child: Text(
                strAvatarText != null && strAvatarText!.isNotEmpty ? strAvatarText![0] : "",
                style: avatarTextStyle ?? AppStyles.avatarTextStyle(avatarSize),
              ),
            ),
          ),
        )
        : CircleAvatar(
          backgroundColor: bgColor,
          radius: avatarHeight(avatarSize) / 2,
          child: Text(
            strAvatarText != null && strAvatarText!.isNotEmpty ? strAvatarText![0] : "",
            style: avatarTextStyle ?? AppStyles.avatarTextStyle(avatarSize),
          ),
        );
  }

  Widget _mapImageSrc() {
    if (strImageSrc.startsWith('assets/')) {
      return avatarSourceAsset();
    } else if (strImageSrc.startsWith('http') || strImageSrc.startsWith('https')) {
      return avatarSourceNetwork();
    } else if (strImageSrc.startsWith('file://')) {
      return avatarSourceFile();
    } else {
      return avatarImageSrcEmpty();
    }
  }

  Widget avatarSourceAsset() {
    return Image.asset(strImageSrc, fit: boxFit ?? BoxFit.cover);
  }

  Widget avatarSourceNetwork() {
    if (cacheImage) {
      return CachedNetworkImage(
        imageUrl: strImageSrc,
        fit: boxFit ?? BoxFit.cover,
        placeholder: (context, url) => Container(child: HelperUI.getProgressIndicator()),
      );
    } else {
      return Image.network(
        strImageSrc,
        fit: boxFit ?? BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress != null) {
            return Container(child: HelperUI.getProgressIndicator());
          }
          return child;
        },
      );
    }
  }

  Widget avatarSourceFile() {
    return Image.file(File(strImageSrc), fit: boxFit ?? BoxFit.cover);
  }

  Widget avatarImageSrcEmpty() {
    return const CircleAvatar(backgroundColor: Colors.transparent);
  }
}
