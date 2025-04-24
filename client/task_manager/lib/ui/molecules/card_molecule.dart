import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/atoms/heading.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/custom_spacers.dart';

class CardMolecule extends StatelessWidget {
  final String strHeadingText;
  final String? strSecondaryText;
  final TextStyle? headingTextStyle;
  final TextStyle? secondaryTextStyle;
  final Widget? icon;
  final Widget? footerWidget;
  final CardVariants cardVariant;
  final BoxDecoration? cardBoxDecoration;
  final EdgeInsets? padding;
  final double dBorderRadius;
  final Widget? headerWidget;
  final Color? bgColor;

  const CardMolecule({
    Key? key,
    required this.strHeadingText,
    this.strSecondaryText,
    this.headingTextStyle,
    this.secondaryTextStyle,
    this.icon,
    this.footerWidget,
    this.cardVariant = CardVariants.defaultCard,
    this.cardBoxDecoration,
    this.padding,
    this.dBorderRadius = AppValues.CARD_MOLECULE_BORDER_RADIUS,
    this.headerWidget,
    this.bgColor = AppColors.CARD_MOLECULE_BG,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CARD_MOLECULE,
      child: Container(
        decoration:
            cardBoxDecoration ??
            BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(dBorderRadius),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.CARD_MOLECULE_SHADOW,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0.0, 8.0),
                ),
              ],
            ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (cardVariant == CardVariants.cardWithIcon && icon != null) icon!,
                  if (cardVariant == CardVariants.cardWithIcon && icon != null)
                    Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (headerWidget != null &&
                            (cardVariant == CardVariants.cardWithImage ||
                                cardVariant == CardVariants.detailCard))
                          headerWidget ?? Container(),
                        if (headerWidget != null &&
                            (cardVariant == CardVariants.cardWithImage ||
                                cardVariant == CardVariants.detailCard))
                          CustomSpacers.height32,
                        Heading(
                          strHeaderText: strHeadingText,
                          textStyle: headingTextStyle ?? AppStyles.cardHeadingTextStyle,
                        ),
                        if (strSecondaryText != null && strSecondaryText!.isNotEmpty)
                          CustomSpacers.height4,
                        if (strSecondaryText != null && strSecondaryText!.isNotEmpty)
                          Heading(
                            strHeaderText: strSecondaryText ?? "",
                            textStyle: secondaryTextStyle ?? AppStyles.cardSecondaryTextStyle,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (cardVariant == CardVariants.detailCard && footerWidget != null)
                CustomSpacers.height16,
              if (cardVariant == CardVariants.detailCard && footerWidget != null) footerWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
