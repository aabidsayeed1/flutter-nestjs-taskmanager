import 'package:flutter/material.dart';

import '../../app_imports.dart';

class AvatarAltText extends StatelessWidget {
  const AvatarAltText(
      {required this.name, this.height = 43, this.fontSize = 24, Key? key})
      : super(key: key);

  final String name;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.ALT_AVATAR_BG,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style: AppStyles.altAvatarText.copyWith(fontSize: fontSize),
        ),
      ),
    );
  }
}
