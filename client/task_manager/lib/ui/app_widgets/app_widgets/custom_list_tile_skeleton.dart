import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/app_imports.dart';
import 'package:shimmer/shimmer.dart';

class CustomListTileSkeleton extends StatelessWidget {
  final int nlength;
  const CustomListTileSkeleton({super.key, this.nlength = 3});

  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(nlength, (index) => _buildShimmerWidget()));
  }

  Widget _buildShimmerWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Shimmer.fromColors(
        baseColor: AppColors.grey800,
        highlightColor: AppColors.grey500,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 160.w, height: 12.h, color: AppColors.grey),
                  SizedBox(height: 10.h),
                  Container(width: 120.w, height: 8.h, color: AppColors.grey),
                ],
              ),
              const Spacer(),
              Container(width: 8.w, height: 22.h, color: AppColors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
