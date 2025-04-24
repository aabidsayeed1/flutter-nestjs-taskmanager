import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_styles.dart';
import 'package:task_manager/core/helpers/helper_file.dart';
import 'package:task_manager/ui/app_widgets/app_widgets/molecules/gradient_icon_text_icon_widget.dart';
import 'package:task_manager/ui/custom_spacers.dart';

class AppIndicatorWidget extends StatelessWidget {
  final String message;
  final IconData iconData;
  final Color color;
  final VoidCallback? onRetry;
  final String? strButtonTxt;

  const AppIndicatorWidget({
    super.key,
    this.message = 'No data available',
    this.iconData = Icons.info_outline,
    this.color = AppColors.COLOR_NEUTRAL300_D1D1DB,
    this.onRetry,
    this.strButtonTxt,
  });
  factory AppIndicatorWidget.error({
    String message = 'Error occurred',
    IconData iconData = Icons.error_outline,
    Color color = AppColors.ERROR,
    VoidCallback? onRetry,
    String? strButtonTxt,
  }) {
    return AppIndicatorWidget(
      message: message,
      iconData: iconData,
      color: color,
      onRetry: onRetry,
      strButtonTxt: strButtonTxt,
    );
  }
  factory AppIndicatorWidget.empty({
    String message = 'No data available',
    IconData iconData = Icons.info_outline,
  }) {
    return AppIndicatorWidget(message: message, iconData: iconData);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 40.r, color: color),
            CustomSpacers.height16,
            Text(
              message,
              style: AppStyles.textErrorStyle.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              CustomSpacers.height10,
              strButtonTxt != null
                  ? Padding(
                    padding: EdgeInsets.only(top: 30.h, left: 50.w, right: 50.w),
                    child: GestureDetector(
                      onTap: onRetry,
                      child: GradientIconTextIconWidget(
                        strText: strButtonTxt!,
                        styleText: AppStyles.buttonGhostDefaultExtraSmall,
                        bIsBorder: true,
                      ),
                    ),
                  )
                  : TextButton.icon(
                    icon: Icon(Icons.refresh, color: AppColors.primary100),
                    onPressed: onRetry,
                    label: Text(
                      strButtonTxt ?? "STRING_RETRY".tr(),
                      style: AppStyles.buttonGhostDefaultExtraSmall,
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
