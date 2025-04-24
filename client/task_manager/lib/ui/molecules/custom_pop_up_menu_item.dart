import 'package:flutter/material.dart';
import 'package:task_manager/ui/molecules/custom_icon_text_button.dart';

// ignore: must_be_immutable
class CustomPopUpMenuItem extends StatelessWidget {
  CustomPopUpMenuItem({
    Key? key,
    required this.text,
    required this.assetname,
    this.onTap,
    this.value,
    required this.style,
    this.isRed = false,
  }) : super(key: key);

  final String text;
  final String? assetname;
  final VoidCallback? onTap;
  final int? value;
  TextStyle? style;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      child: CustomIconWithTextButton(
        onLongPress: () {},
        onTap: onTap!,
        svgAssetUrl: assetname!,
        text: text,
        textStyle: style!,
      ),
      value: value,
    );
  }
}
