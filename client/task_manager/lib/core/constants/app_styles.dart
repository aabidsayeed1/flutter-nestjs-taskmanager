// Styles to be picked from whatever is mentioned in Themes.
// If we need styles beyond themes, only then use this file
//==========================================================
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/constants/figma_styles.dart';
import 'package:flutter/material.dart';

import '../../app_imports.dart';
import 'figma_colors.dart';

class AppStyles {
  //pow-dr figma font styles start

  static const String _fontFamily = 'Inter';

  static final TextStyle _baseTextStyle = TextStyle(
    fontFamily: _fontFamily,
    height: 1.33.h,
    color: AppColors.basicWhite,
  );
  static final TextStyle captionTextXssFontThin = _baseTextStyle.copyWith(
    fontSize: 6.sp,
    fontWeight: FontWeight.w600,
  );
  // Caption Text Styles (12.sp)
  static final TextStyle captionTextXsFontThin = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w100,
  );
  static final TextStyle captionTextXsFontExtralight = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w200,
  );
  static final TextStyle captionTextXsFontLight = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle captionTextXsFontNormal = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle captionTextXsFontNormalBlack = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static final TextStyle captionTextXsFontNormalNeutral300 = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );
  static final TextStyle captionTextXsFontNormalSemanticTextFeildError = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.semanticTextFeildError,
  );
  static final TextStyle captionTextXsFontMedium = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle captionTextXsFontSemibold = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle captionTextXsFontBold = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle captionTextXsFontExtrabold = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle captionTextXsFontBlack = _baseTextStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w900,
  );

  // Body Small Text Styles (14.sp)
  static final TextStyle bodySmallTextSmFontThin = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w100,
  );
  static final TextStyle bodySmallTextSmFontExtralight = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w200,
  );
  static final TextStyle bodySmallTextSmFontLight = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle bodySmallTextSmFontLightNeutral400 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w300,
    color: AppColors.neutral400,
  );
  static final TextStyle bodySmallTextSmFontNormal = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle bodySmallTextSmFontNormalSemanticErrorBase = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    color: AppColors.semanticErrorBase,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle bodySmallTextSmFontNormalUnderline = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static final TextStyle bodySmallTextSmFontNormalneutral400 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral400,
  );

  static final TextStyle bodySmallTextSmFontNormalneutral300 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );

  static final TextStyle bodySmallTextSmFontNormalOrange = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.chartColor4,
  );

  static final TextStyle bodySmallTextSmFontNormalRed = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.semanticErrorBase,
  );

  static final TextStyle bodySmallTextSmFontNormalEventSaveUpto = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.eventSaveUpto,
  );
  static final TextStyle bodySmallTextSmFontNormalConnectionLostError = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.connectionLostError,
  );
  static final TextStyle bodySmallTextSmFontNormalNeutral50 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral50,
  );
  static final TextStyle bodySmallTextSmFontNormalNeutral100 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral100,
  );
  static final TextStyle bodySmallTextSmFontNormalNeutral300 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );
  static final TextStyle bodySmallTextSmFontNormalNeutral400 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral400,
  );
  static final TextStyle bodySmallTextSmFontNormalNeutral500 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral500,
  );
  static final TextStyle bodySmallTextSmFontNormalPrimary800 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.primary800,
  );

  static final TextStyle bodySmallTextSmFontNormalPrimary400 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.primary400,
  );

  static final TextStyle bodySmallTextSmFontNormalPrimary900 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.primary900,
  );
  static final TextStyle bodySmallTextSmFontNormalPrimary900UnderLine = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w400,
    color: AppColors.primary900,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary900,
    decorationThickness: 1,
  );
  static final TextStyle bodySmallTextSmFontMedium = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodySmallTextSmFontMediumNeutral300 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral300,
  );

  static final TextStyle bodySmallTextSmFontMediumNeutral50 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral50,
  );

  static final TextStyle bodySmallTextSmFontMediumPrimary800 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w500,
    color: AppColors.primary800,
  );
  static final TextStyle bodySmallTextSmFontSemibold = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle bodySmallTextSmFontSemiboldPrimary800 = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w600,
    color: AppColors.primary800,
  );
  static final TextStyle bodySmallTextSmFontBold = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle bodySmallTextSmFontExtrabold = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle bodySmallTextSmFontBlack = _baseTextStyle.copyWith(
    fontSize: 14.sp,
    height: 1.43.h,
    fontWeight: FontWeight.w900,
    color: AppColors.black,
  );

  // Body Text Styles (16.sp)
  static final TextStyle bodyTextBaseFontThin = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w100,
  );
  static final TextStyle bodyTextBaseFontExtralight = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w200,
  );
  static final TextStyle bodyTextBaseFontLight = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle bodyTextBaseFontNormal = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle bodyTextBaseFontNormalNeutral100 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral100,
  );
  static final TextStyle bodyTextBaseFontNormalNeutral300 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral300,
  );

  static final TextStyle bodyTextBaseFontNormalNeutral400 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral400,
  );

  static final TextStyle bodyTextBaseFontNormalNeutral400BasicWhite = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w400,
    color: AppColors.BASICWHITE,
  );

  static final TextStyle bodyTextBaseFontNormalNeutral500 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w400,
    color: AppColors.neutral500,
  );
  static final TextStyle bodyTextBaseFontMedium = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle bodyTextBaseFontMediumNeutral400 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral400,
  );
  static final TextStyle bodyTextBaseFontMediumNeutral300 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral300,
  );
  static final TextStyle bodyTextBaseFontSemibold = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle bodyTextBaseFontSemiboldRed = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w600,
    color: AppColors.semanticErrorBase,
  );

  static final TextStyle bodyTextBaseFontSemiboldNeutral100 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral100,
  );
  static final TextStyle bodyTextBaseFontSemiboldPrimary900 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w600,
    color: AppColors.primary900,
  );
  static final TextStyle bodyTextBaseFontBold = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle bodyTextBaseFontBoldNeutral100 = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral100,
  );
  static final TextStyle bodyTextBaseFontExtrabold = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle bodyTextBaseFontBlack = _baseTextStyle.copyWith(
    fontSize: 16.sp,
    height: 1.5.h,
    fontWeight: FontWeight.w900,
  );

  // Headline 6 Text Styles (18.sp)
  static final TextStyle h6TextLgFontThin = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w100,
  );
  static final TextStyle h6TextLgFontExtralight = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w200,
  );
  static final TextStyle h6TextLgFontLight = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle h6TextLgFontNormal = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle h6TextLgFontMedium = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle h6TextLgFontSemibold = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle h6TextLgFontSemiboldNeutral100 = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral100,
  );
  static final TextStyle h6TextLgFontBold = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle h6TextLgFontExtrabold = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle h6TextLgFontBlack = _baseTextStyle.copyWith(
    fontSize: 18.sp,
    height: 1.56.h,
    fontWeight: FontWeight.w900,
  );

  // Headline 5 Text Styles (20.sp)
  static final TextStyle h5TextXlFontThin = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w100,
  );
  static final TextStyle h5TextXlFontExtralight = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w200,
  );
  static final TextStyle h5TextXlFontLight = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle h5TextXlFontNormal = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle h5TextXlFontMedium = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle h5TextXlFontSemibold = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle h5TextXlFontBold = _baseTextStyle.copyWith(
    fontSize: 20.sp,
    height: 1.4.h,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle h4Text2xlFontNormal = _baseTextStyle.copyWith(
    fontSize: 24.sp,
    height: 1.33,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle h4Text2xlFontMedium = _baseTextStyle.copyWith(
    fontSize: 24.sp,
    height: 1.33.h,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle h4Text2xlFontSemibold = _baseTextStyle.copyWith(
    fontSize: 24.sp,
    height: 1.33.h,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle h4Text2xlFontBold = _baseTextStyle.copyWith(
    fontSize: 24.sp,
    height: 1.33.h,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle h3Text3xlFontNormal = _baseTextStyle.copyWith(
    fontSize: 28.sp,
    height: 1.2.h,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle h3Text3xlFontBold = _baseTextStyle.copyWith(
    fontSize: 28.sp,
    height: 1.2.h,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle h2Text4xlFontNormal = _baseTextStyle.copyWith(
    fontSize: 32.sp,
    height: 1.125.h,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle h2Text4xlFontBold = _baseTextStyle.copyWith(
    fontSize: 32.sp,
    height: 1.125.h,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle h1Text5xlFontNormal = _baseTextStyle.copyWith(
    fontSize: 40.sp,
    height: 1.2.h,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle h1Text5xlFontBold = _baseTextStyle.copyWith(
    fontSize: 40.sp,
    height: 1.2.h,
    fontWeight: FontWeight.w700,
  );
  //pow-dr font styles end
  static const TextStyle styleForAppName = TextStyle(fontSize: 25, color: Colors.white);
  static const TextStyle whiteBold16 = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle whiteBold12 = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle stylePrimaryButton = TextStyle(fontSize: 20, color: Colors.black);

  static const TextStyle styleSecondaryButton = TextStyle(fontSize: 20, color: Colors.black);

  static const TextStyle styleText = TextStyle(fontSize: 20, color: Colors.black);
  static const textErrorStyle = TextStyle(
    fontSize: 12,
    color: AppColors.ERROR,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.7,
    decoration: TextDecoration.none,
    height: 1,
  );

  //PopupDialog Message Style
  static const messageStyle = TextStyle(
    fontSize: 14,
    color: AppColors.POPUP_DIALOG_TEXT_COLOR,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.7,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  //PopupDialog
  static const TextStyle titleStyle = TextStyle(
    fontSize: 16,
    color: AppColors.POPUP_DIALOG_TEXT_COLOR,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  static const toastMessageStyle = TextStyle(
    fontSize: 12,
    color: AppColors.TOAST_MESSAGE_STYLE,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.4,
  );

  //IconTitleSubtitle
  static const styleTitle = TextStyle(
    fontSize: 14,
    color: AppColors.ICON_TITLE_SUBTITLE_TITLE_TEXT,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.7,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  static const styleSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.ICON_TITLE_SUBTITLE_SUBTEXT,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    decoration: TextDecoration.none,
    height: 2,
  );

  static const TextStyle inputFieldTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.INPUT_FIELD_TEXT_COLOR,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.5,
    decoration: TextDecoration.none,
  );

  //Expanding card
  static const expandingCardTitleStyle = TextStyle(
    fontSize: 16,
    color: AppColors.EXPANDING_CARD_TEXT_COLOR,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontFamily: 'Gilroy',
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const expandingCardSubtitleStyle = TextStyle(
    fontSize: 14,
    color: AppColors.EXPANDING_CARD_TEXT_COLOR,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: "SF-Pro-Text-Regular",
    letterSpacing: 0.7,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  //RowIconTextAccessor
  static const rowIconTextAccessortextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.ROW_ICON_TEXT_ACCESSOR_TEXT_COLOR,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.7,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  //RowKeyValue
  static const rowKeyValueStyleSubKey = TextStyle(
    fontSize: 12,
    color: AppColors.ROW_KEY_VALUE_SUBKEY_COLOR,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.4,
  );

  static const rowKeyValueStyleKey = TextStyle(
    fontSize: 14,
    color: AppColors.ROW_KEY_VALUE_KEY_COLOR,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.4,
    height: 1.5,
  );

  static const rowKeyValueStyleValue = TextStyle(
    fontSize: 14,
    color: AppColors.ROW_KEY_VALUE_VALUE_COLOR,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.7,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  //Custom Text Field
  static TextStyle textFieldInputStyle = const TextStyle(
    color: AppColors.CUSTOM_TEXT_FIELD_TEXT,
    fontSize: 14.0,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textFieldErrorStyle = const TextStyle(
    color: AppColors.CUSTOM_TEXT_FIELD_ERROR,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );

  static TextStyle customTextFieldLabel = const TextStyle(
    color: AppColors.CUSTOM_TEXT_FIELD_LABEL,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  //Horizontal Radio Group
  static TextStyle unselectedText = const TextStyle(
    color: AppColors.HORIZONTAL_RADIO_TEXT_UNSELECTED,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static TextStyle selectedText = const TextStyle(
    color: AppColors.HORIZONTAL_RADIO_TEXT_SELECTED,
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
  );

  //Box Button
  static const TextStyle styleBoxButtonText = TextStyle(
    fontSize: 14,
    color: AppColors.BOX_BUTTON_TEXT,
    fontStyle: FontStyle.normal,
  );

  //Button Underlined
  static const TextStyle buttonUnderlinedText = TextStyle(
    fontSize: 14,
    color: AppColors.BUTTON_UNDERLINED_TEXT,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.5,
    decoration: TextDecoration.none,
  );

  //Number Text Field
  static const TextStyle numberFieldInputStyle = TextStyle(
    fontSize: 14,
    color: AppColors.BLACK_1A1A1A,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    height: 1.5,
    decoration: TextDecoration.none,
  );

  static const TextStyle numberFieldSubHeading = TextStyle(
    fontSize: 12,
    color: AppColors.GREY,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static TextStyle altAvatarText = const TextStyle(
    color: AppColors.WHITE,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  );

  //Checkbox
  static TextStyle checkboxTextStyle = const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    color: AppColors.BLACK,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );
  static TextStyle checkboxErrorTextStyle =
      FigmaStyles.bodysmalltextSmfont_normalsemanticerror_base;

  // DropDown
  static TextStyle dropDownItemTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral800;
  static TextStyle searchTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral600;
  static TextStyle labelTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral700;
  static TextStyle dropDownErrorTextStyle =
      FigmaStyles.bodysmalltextSmfont_normalsemanticerror_base;
  static TextStyle dropDownPlaceHolderTextStyle = FigmaStyles.bodytextbasefontNormalneutral800;

  //figma new  styles

  // static TextStyle bodySmallTextSmallFontSemiBold = FigmaTextStyles.bodysmalltextsmfontsemibold ;
  // static TextStyle bodySmallTextSmallFontNormal = FigmaTextStyles.bodysmalltextsmfontnormal.copyWith(color: FigmaColors.neutral500);
  //

  //style for button primary

  static TextStyle buttonPrimaryDefaultNormal = AppStyles.bodyTextBaseFontSemibold;
  static TextStyle buttonPrimaryDefaultMedium = FigmaStyles.bodytextbasefontSemiboldbasicwhite;
  static TextStyle buttonPrimaryDefaultSmall = FigmaStyles.bodysmalltextSmfont_semiboldbasicwhite;
  static TextStyle buttonPrimaryDefaultExtraSmall =
      FigmaStyles.bodysmalltextSmfont_semiboldbasicwhite;

  static TextStyle buttonPrimaryDisabledNormal = FigmaStyles.h5textxlfontSemiboldprimary300;
  static TextStyle buttonPrimaryDisabledMedium = FigmaStyles.bodytextbasefontSemiboldprimary300;
  static TextStyle buttonPrimaryDisabledSmall = FigmaStyles.bodysmalltextSmfont_semiboldprimary300;
  static TextStyle buttonPrimaryDisabledExtraSmall =
      FigmaStyles.bodysmalltextSmfont_semiboldprimary300;
  //Accordion
  static TextStyle accordionTitleText = FigmaStyles.h6textlgfontNormalneutral900;
  static TextStyle accordionSubHeading = FigmaStyles.h6textlgfontMediumneutral900;
  //static TextStyle accordionContent =
  //  FigmaStyles.bodysmalltextSmfont_normalneutral700;

  static TextStyle accordionContentTextStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.ACCORDION_TEXT_CONTENT_COLOR,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  // style for button ghost

  static TextStyle buttonGhostDefaultNormal = FigmaStyles.h5textxlfontSemiboldprimary900;
  static TextStyle buttonGhostDefaultMedium = FigmaStyles.bodytextbasefontSemiboldprimary900;
  static TextStyle buttonGhostDefaultSmall = FigmaStyles.bodysmalltextSmfont_semiboldprimary900;
  static TextStyle buttonGhostDefaultExtraSmall =
      FigmaStyles.bodysmalltextSmfont_semiboldprimary900;

  static TextStyle buttonGhostFocusedNormal = FigmaStyles.h5textxlfontSemiboldprimary800;
  static TextStyle buttonGhostFocusedMedium = FigmaStyles.bodytextbasefontSemiboldprimary800;
  static TextStyle buttonGhostFocusedSmall = FigmaStyles.bodysmalltextSmfont_semiboldprimary800;
  static TextStyle buttonGhostFocusedExtraSmall =
      FigmaStyles.bodysmalltextSmfont_semiboldprimary800;

  static TextStyle alertTextStyle({required Color cAlertTextColor}) {
    return TextStyle(
      fontSize: 14,
      color: cAlertTextColor,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
      letterSpacing: 0,
    );
  }
  // mapping for button textstyle

  static TextStyle buttonTextStyle({
    required String style,
    required String size,
    required String state,
  }) {
    if (size == (ButtonSize.normal.toString().split('.').last)) {
      return buttonNormalTextColor(style: style, state: state);
    } else if (size == (ButtonSize.medium.toString().split('.').last)) {
      return buttonMediumTextColor(style: style, state: state);
    } else if (size == (ButtonSize.small.toString().split('.').last)) {
      return buttonSmallTextColor(style: style, state: state);
    } else {
      return buttonExtraSmallTextColor(style: style, state: state);
    }
  }

  static TextStyle buttonNormalTextColor({required style, required String state}) {
    if (style == ButtonType.primary.toString().split('.').last) {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledNormal;
      }
      if (state == ButtonState.active.toString().split('.').last) {
        return buttonPrimaryDefaultNormal;
      }
      return buttonPrimaryDefaultNormal;
    } else {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledNormal;
      } else if (state == ButtonState.Default.toString().split('.').last) {
        return buttonGhostDefaultNormal;
      }
      return buttonGhostFocusedNormal;
    }
  }

  static TextStyle buttonMediumTextColor({required style, required String state}) {
    if (style == ButtonType.primary.toString().split('.').last) {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledMedium;
      }
      return buttonPrimaryDefaultMedium;
    } else {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledMedium;
      } else if (state == ButtonState.Default.toString().split('.').last) {
        return buttonGhostDefaultMedium;
      }
      return buttonGhostFocusedMedium;
    }
  }

  static TextStyle buttonSmallTextColor({required style, required String state}) {
    if (style == ButtonType.primary.toString().split('.').last) {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledSmall;
      }
      return buttonPrimaryDefaultSmall;
    } else {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledSmall;
      } else if (state == ButtonState.Default.toString().split('.').last) {
        return buttonGhostDefaultSmall;
      }
      return buttonGhostFocusedSmall;
    }
  }

  static TextStyle buttonExtraSmallTextColor({required style, required String state}) {
    if (style == ButtonType.primary.toString().split('.').last) {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledExtraSmall;
      }
      return buttonPrimaryDefaultExtraSmall;
    } else {
      if (state == ButtonState.disabled.toString().split('.').last) {
        return buttonPrimaryDisabledExtraSmall;
      } else if (state == ButtonState.Default.toString().split('.').last) {
        return buttonGhostDefaultExtraSmall;
      }
      return buttonGhostFocusedExtraSmall;
    }
  }

  // figma styles for heading

  static Map<String, TextStyle> headingStyle = {
    "h1": FigmaStyles.h1text5xlfontBlackprimary900,
    "h2": FigmaStyles.h2text4xlfontBlackprimary900,
    "h3": FigmaStyles.h3text3xlfontBlackprimary900,
    "h4": FigmaStyles.h4text2xlfontBlackprimary900,
    "h5": FigmaStyles.h5textxlfontBlackprimary900,
    "h6": FigmaStyles.h6textlgfontBlackprimary900,
  };

  // figma styles for input box
  static TextStyle inputBoxFocusedTextStyle = FigmaStyles.bodytextbasefontNormalneutral900;
  static TextStyle inputBoxDisabledTextStyle = FigmaStyles.bodytextbasefontNormalneutral500;
  static TextStyle inputBoxLabelStyle = FigmaStyles.bodytextbasefontNormalneutral900;
  static TextStyle inputBoxPlaceHolderStyle = FigmaStyles.bodytextbasefontNormalneutral400;

  // figma styles for animated input labe

  static TextStyle animatedInputLabelStyle = FigmaStyles.bodysmalltextSmfont_normalneutral600;
  static TextStyle animatedInputLabelDisabledStyle =
      FigmaStyles.bodysmalltextSmfont_normalneutral300;
  static TextStyle animatedInputLabelFocusedTextStyle =
      FigmaStyles.bodysmalltextSmfont_normalneutral900;

  static TextStyle hintInputLabelStyle = FigmaStyles.captiontextxsfontNormalneutral600;

  // figma styles for Progress bar

  static TextStyle progressBarLabelTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral800;

  // figma styles for breadcrumb

  static TextStyle breadCrumbActiveTextStyle = FigmaStyles.h6textLgfont_normal.copyWith(
    color: FigmaColors.COLOR_BASICBLACK_0C0C1E,
  );
  static TextStyle breadCrumbInActiveTextStyle = FigmaStyles.h6textLgfont_normal.copyWith(
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
  );
  static TextStyle breadCrumbSeparatorStyle = FigmaStyles.h6textLgfont_normal.copyWith(
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
  );

  //H6/text-lg/font-normal

  //figma styles for radio button

  static TextStyle radioButtonUnActiveTextStyle = FigmaStyles.bodySmalltext_smfont_normal;
  static TextStyle radioButtonActiveTextStyle = FigmaStyles.bodySmalltext_smfont_normal;
  static TextStyle radioButtonErrorTextStyle =
      FigmaStyles.bodysmalltextSmfont_normalsemanticerror_base;

  //figma styles for input number

  static TextStyle inputNumberTextStyle(bool disabled, bool isFocused, InputNumberSizes size) {
    TextStyle textStyle;
    if (size == InputNumberSizes.small || size == InputNumberSizes.medium) {
      textStyle = FigmaStyles.bodysmalltextSmfont_normalneutral800;
    } else {
      textStyle = FigmaStyles.bodytextbasefontNormalneutral800;
    }

    return disabled
        ? textStyle.copyWith(color: FigmaColors.COLOR_NEUTRAL400_9C9CAF)
        : isFocused
        ? textStyle
        : textStyle.copyWith(color: FigmaColors.COLOR_NEUTRAL300_D1D1DB);
  }

  //figma styles for timeline
  static TextStyle timelineDateStyle = FigmaStyles.bodysmalltextSmfont_normalneutral500;
  static TextStyle timelineItemStyle = FigmaStyles.bodysmalltextSmfont_mediumneutral900;
  static TextStyle timelineDescriptionStyle = FigmaStyles.bodysmalltextSmfont_normalneutral500;

  //figma styles for tag
  static TextStyle tagMediumTextStyle = FigmaStyles.bodytextbasefontMediumbasicwhite;
  static TextStyle tagDefaultTextStyle = FigmaStyles.bodysmalltextSmfont_mediumbasicwhite;
  static TextStyle tagSmallTextStyle = FigmaStyles.captiontextxsfontMediumbasicwhite;

  //figma styles for tabs
  static TextStyle tabsActiveTextStyle = FigmaStyles.bodysmalltextSmfont_mediumneutral800;
  static TextStyle tabsInActiveTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral500;

  //figma styles for chart
  static TextStyle chartTitleStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 22,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
  );
  static TextStyle chartAxisTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
  );

  //Sub Menu
  static TextStyle subMenuTitle = FigmaStyles.bodysmalltextSmfont_normalneutral900;
  static TextStyle subTitle = FigmaStyles.captiontextxsfontNormalneutral400;
  static TextStyle menuTitle = FigmaStyles.bodysmalltextSmfont_normalneutral900;
  static TextStyle expandedMenuTitle = FigmaStyles.bodysmalltextSmfont_normalprimary900;

  //lightbox
  static TextStyle lightboxIndexCountText = FigmaStyles.bodysmalltextSmfont_normalbasicwhite;
  //pagination

  static TextStyle paginationTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral900;

  //figma styles for datePicker
  static TextStyle datePickerDisabledDatesStyle = FigmaStyles.bodysmalltextSmfont_normalneutral600
      .copyWith(decoration: TextDecoration.lineThrough);
  static TextStyle datePickerHeaderStyle = FigmaStyles.bodysmalltextSmfont_normalprimary900;
  static TextStyle datePickerHeaderWeeksStyle = FigmaStyles.bodysmalltextSmfont_normalneutral600;
  static TextStyle datePickerSelectedDayStyle = FigmaStyles.bodysmalltextSmfont_normalbasicwhite;
  static TextStyle datePickerTodayDateStyle = FigmaStyles.bodysmalltextSmfont_normalneutral900;
  static TextStyle datePickerLabelStyle = FigmaStyles.bodysmalltextSmfont_normalneutral700;
  static TextStyle datePickerInputTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral900;
  static TextStyle datePickerNormalDateTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral900;

  //figma styles for avatar
  static TextStyle badgeTextStyle = FigmaStyles.captiontextxsfontNormalbasicwhite;
  static TextStyle avatarTextStyle(AvatarSize size) {
    if (size == AvatarSize.medium) {
      return FigmaStyles.bodytextbasefontBlackprimary900;
    } else if (size == AvatarSize.large) {
      return FigmaStyles.h5textxlfontMediumprimary900;
    } else if (size == AvatarSize.extraLarge) {
      return FigmaStyles.h4text2xlfontMediumprimary900;
    } else {
      return FigmaStyles.bodysmalltextSmfont_normalprimary900;
    }
  }

  //styles for steps

  static TextStyle stepsPastStyle = FigmaStyles.bodysmalltextSmfont_normalneutral900;
  static TextStyle stepsActiveStyle = FigmaStyles.bodysmalltextSmfont_normalprimary900;
  static TextStyle stepsNextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral600;

  static TextStyle stepsPastIndicatorStyle = FigmaStyles.bodysmalltextSmfont_normalbasicwhite;

  // styles for card
  static TextStyle cardHeadingTextStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    color: Color(0xff000000),
  );
  static TextStyle cardSecondaryTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Color(0xff999CA0),
  );

  // Table
  static TextStyle columnHeadingStyle = FigmaStyles.bodysmalltextSmfont_mediumneutral800;

  // popup styles
  static TextStyle popupTitleTextStyle = FigmaStyles.bodytextbasefontBoldneutral800;
  static TextStyle popupContentTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral800;

  //popover styles
  static TextStyle popoverTitleTextStyle = FigmaStyles.h6textLgfont_bold;
  static TextStyle popoverContentTextStyle = FigmaStyles.bodysmalltextSmfont_normalneutral800;
}
