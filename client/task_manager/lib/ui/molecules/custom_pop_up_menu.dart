import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/molecules/custom_pop_up_menu_item.dart';

// ignore: must_be_immutable
class CustomPopUpMenu extends StatelessWidget {
  CustomPopUpMenu({
    Key? key,
    required this.items,
    required this.onSelected,
    this.onTap,
    this.pRight = false,
  }) : super(key: key);

  final List<CustomPopUpMenuItem> items;
  final Function(int) onSelected;
  final Function()? onTap;
  bool? pRight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PopupMenuButton(
        elevation: 4,
        padding: EdgeInsets.zero,
        icon: Padding(
          padding: EdgeInsets.only(right: pRight! ? 4.w : 0),
          child: const Icon(Icons.more_vert_rounded, color: Colors.red),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        onSelected: (int index) {
          onSelected(index);
        },
        itemBuilder:
            (context) => [
              ...items.map(
                (popUpItem) => PopupMenuItem(
                  // onTap: () {
                  //   final index = items.indexOf(popUpItem);
                  //   // onSelected(index);
                  //   // CustomNavigator.pop(context);
                  // },
                  value: items.indexOf(popUpItem),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(popUpItem.assetname!),
                      CustomSpacers.width6,
                      Text(popUpItem.text, style: AppStyles.bodySmallTextSmFontNormal),
                    ],
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
