import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';

class CustomPreferenceTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback? onOption;
  const CustomPreferenceTile({
    super.key,
    required this.title,
    required this.subTitle,
    this.onOption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayBgContainer,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.bodySmallTextSmFontMedium),
              Gap(4.h),
              Text(subTitle, style: AppStyles.bodySmallTextSmFontNormalNeutral400),
            ],
          ),
          if (onOption != null) IconButton(onPressed: onOption, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
