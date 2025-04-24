import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_styles.dart';
import 'package:task_manager/core/helpers/helper_file.dart';

class CustomDivider extends StatelessWidget {
  final bool withOr;
  final Color? color;

  const CustomDivider({super.key, this.withOr = false, this.color});

  const CustomDivider.withOR({super.key, this.color}) : withOr = true;

  @override
  Widget build(BuildContext context) {
    if (withOr) {
      return Row(
        children: [
          Expanded(child: Divider(height: 1.h, color: color ?? AppColors.neutral900)),
          Gap(9.5.w),
          Text("STRING_OR".tr(), style: AppStyles.bodySmallTextSmFontNormalNeutral100),
          Gap(9.5.w),
          Expanded(child: Divider(height: 1.h, color: color ?? AppColors.neutral900)),
        ],
      );
    }

    return Divider(height: 1.h, color: AppColors.neutral900);
  }
}
