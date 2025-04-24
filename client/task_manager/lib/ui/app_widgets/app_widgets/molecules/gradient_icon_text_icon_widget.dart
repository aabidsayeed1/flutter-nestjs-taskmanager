import 'package:flutter/material.dart';

class GradientIconTextIconWidget extends StatelessWidget {
  final String strText;
  final TextStyle? styleText;
  final Gradient gradient;
  final bool bIsBorder;
  final EdgeInsets? padding;
  final double? dRadius;
  final TextAlign? textAlign;
  final Widget wLeftIcon, wRightIcon;
  final bool bIsPadding;
  final MainAxisAlignment mainAxisAlignment;
  final double dBorderWidth;
  final Color colorBackground;

  const GradientIconTextIconWidget(
      {super.key,
      required this.strText,
      this.styleText,
      this.gradient =
          const LinearGradient(colors: [Color(0xFF0060EF), Color(0xFF150190), Color(0xFF8601F0)]),
      this.bIsBorder = false,
      this.padding,
      this.dRadius,
      this.textAlign,
      this.wLeftIcon = const SizedBox.shrink(),
      this.wRightIcon = const SizedBox.shrink(),
      this.bIsPadding = true,
      this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
      this.dBorderWidth = 2,
      this.colorBackground = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: bIsPadding ? EdgeInsets.all(dBorderWidth) : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: bIsBorder ? gradient : null,
        borderRadius: BorderRadius.circular(dRadius ?? 4),
      ),
      child: Container(
        padding: bIsPadding
            ? padding ?? const EdgeInsets.symmetric(vertical: 8)
            : const EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          color: colorBackground, //bIsBorder ? Colors.white : null,
          borderRadius: BorderRadius.circular(dRadius ?? 4),
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            wLeftIcon,
            ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => gradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: Text(textAlign: textAlign ?? TextAlign.center, strText, style: styleText)),
            wRightIcon,
          ],
        ),
      ),
    );
  }
}
