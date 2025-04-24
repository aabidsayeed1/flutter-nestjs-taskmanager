import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final ProgressBarSizes progressBarSize;
  final ProgressBarStyles progressBarStyle;
  final double? dValue;
  final Color? bgColor;
  final Color? color;
  final bool bShowLabel;
  final String? strLabelText;
  final double? dHeight;
  final double? dBorderRadius;
  final TextStyle? labelTextStyle;

  const ProgressBar({
    Key? key,
    this.progressBarSize = ProgressBarSizes.Default,
    this.progressBarStyle = ProgressBarStyles.rounded,
    this.dValue,
    this.bgColor = AppColors.PROGRESS_BAR_BG_COLOR,
    this.color = AppColors.PROGRESS_BAR_COLOR,
    this.bShowLabel = false,
    this.strLabelText,
    this.dHeight,
    this.dBorderRadius,
    this.labelTextStyle,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.PROGRESS_BAR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.bShowLabel)
            Container(
              margin:
                  widget.progressBarSize == ProgressBarSizes.Default
                      ? const EdgeInsets.only(left: 8, right: 8, bottom: 9)
                      : const EdgeInsets.only(left: 12, right: 12, bottom: 9),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.strLabelText ?? "",
                      style: widget.labelTextStyle ?? AppStyles.progressBarLabelTextStyle,
                    ),
                  ),
                  Text(
                    "${(widget.dValue ?? 0) * 100}%",
                    style: widget.labelTextStyle ?? AppStyles.progressBarLabelTextStyle,
                  ),
                ],
              ),
            ),
          if (widget.bShowLabel && widget.progressBarSize == ProgressBarSizes.Default)
            Gap(8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomPaint(
              painter: CustomLinearProgress(
                (widget.dValue ?? 0) * 100,
                //  widget.dValue! * _animationController.value,
                strokeWidth: widget.dHeight ?? MapProgressBarSizes(widget.progressBarSize),
                borderRadius:
                    widget.dBorderRadius ?? MapProgressBarRadiusSizes(widget.progressBarStyle),
                progressBarStyles: widget.progressBarStyle,
              ),
              child: Container(
                alignment: Alignment.center,
                height: widget.dHeight ?? MapProgressBarSizes(widget.progressBarSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLinearProgress extends CustomPainter {
  double progress;
  double? borderRadius;
  double? strokeWidth;
  Color progressColor;
  Color backgroundColor;
  ProgressBarStyles progressBarStyles;

  CustomLinearProgress(
    this.progress, {
    this.borderRadius,
    this.strokeWidth,
    this.progressColor = AppColors.PROGRESS_BAR_COLOR,
    this.backgroundColor = AppColors.PROGRESS_BAR_BG_COLOR,
    this.progressBarStyles = ProgressBarStyles.rounded,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth!
          ..strokeCap = selectedProBarStyles()
          ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, strokeWidth!),
        Radius.circular(borderRadius!),
      ),
      paint,
    );

    Paint progressPaint =
        Paint()
          ..color = progressColor
          ..strokeWidth = strokeWidth!
          ..strokeCap = selectedProBarStyles()
          ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progress / 100 * size.width, strokeWidth!),
        Radius.circular(borderRadius!),
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  StrokeCap selectedProBarStyles() {
    if (progressBarStyles == ProgressBarStyles.rounded) {
      return StrokeCap.round;
    }
    if (progressBarStyles == ProgressBarStyles.soft) {
      return StrokeCap.round;
    } else {
      return StrokeCap.square;
    }
  }
}
