import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/custom_spacers.dart';

class CustomIconWithTextButton extends StatelessWidget {
  const CustomIconWithTextButton({
    Key? key,
    required this.svgAssetUrl,
    required this.text,
    required this.onTap,
    required this.onLongPress,
    required this.textStyle,
    this.divider,
  }) : super(key: key);

  final String svgAssetUrl;
  final String text;
  final Widget? divider;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.deferToChild,
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(svgAssetUrl),
          CustomSpacers.width6,
          if (divider != null) divider!,
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
