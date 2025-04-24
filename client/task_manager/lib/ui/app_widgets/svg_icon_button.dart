import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app_imports.dart';

class SvgIconButton extends StatelessWidget {
  final VoidCallback? onClick;
  final Color color;
  final String assetString;
  final BoxFit fit;
  final double? height;
  final double? width;

  const SvgIconButton({
    Key? key,
    required this.assetString,
    this.fit = BoxFit.scaleDown,
    this.onClick,
    this.color = AppColors.PRIMARY_COLOR,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: SvgPicture.asset(
        assetString,
        colorFilter: HelperUI.getSVGCOlor(color),
        // color: color,
        fit: fit,
        height: height,
        width: width,
      ),
    );
  }
}
