import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Rating extends StatelessWidget {
  final Function(double)? onRatingUpdate;
  final Color glowColor;
  final Color unRatedColor;
  final double dInitialRating;
  final bool bHorizontalDirection;
  final bool bAllowHalfRating;
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final bool bSmileyIcon;
  final double iconSize;

  const Rating({
    Key? key,
    this.onRatingUpdate,
    this.glowColor = AppColors.RATING_GLOW_COLOR,
    this.unRatedColor = AppColors.RATING_UNRATED_COLOR,
    this.dInitialRating = 0,
    this.bHorizontalDirection = true,
    this.bAllowHalfRating = false,
    this.itemCount = 5,
    this.padding = AppValues.RATING_PADDING,
    this.icon,
    this.bSmileyIcon = false,
    this.iconSize = AppValues.RATING_ICON_SIZE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.RATING,
      child: RatingBar.builder(
        initialRating: dInitialRating,
        // minRating: 1,
        direction: bHorizontalDirection ? Axis.horizontal : Axis.vertical,
        allowHalfRating: bAllowHalfRating,
        itemCount: itemCount,
        glowColor: glowColor,
        unratedColor: unRatedColor,
        itemPadding: padding,
        itemBuilder:
            (context, _) =>
                icon ??
                SvgPicture.asset(
                  bSmileyIcon ? AppImages.RATING_SMILE_ICON : AppImages.RATING_STAR_ICON,
                  colorFilter: HelperUI.getSVGCOlor(glowColor),
                  // color: glowColor,
                  height: iconSize,
                  width: iconSize,
                ),
        onRatingUpdate: (rating) {
          if (onRatingUpdate != null) {
            onRatingUpdate!(rating);
          }
        },
      ),
    );
  }
}
