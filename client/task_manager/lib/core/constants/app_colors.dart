// All colors used in the app

// ignore_for_file: constant_identifier_names
//============================================================================
import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/hex_colors.dart';

import 'figma_colors.dart';

//============================================================================
class AppColors {
  // Pow-Dr figma colors start
  static final Color black = HexColor("#000000");
  static final Color basicWhite = HexColor("#fcfcfc");
  static final Color basicBlack = HexColor("#0c0c1e");
  static final Color grayBgContainer = HexColor("#0F141B");
  static final Color grayBgRewards = HexColor("#151F31");
  static final Color grayBgRewards1 = HexColor("#17243A").withOpacity(0.5);
  static final Color grayBgRewards2 = HexColor("#4163A0").withOpacity(0.5);
  static final Color grayBgDevices = HexColor("#11171F");
  static final Color pieChartEmpty = HexColor("#F9F9FB");
  static final Color grayBgDashboard = HexColor("#444348");
  static final Color grayBgChip = HexColor("#4258CA").withOpacity(0.5);
  static final Color grayBgChip1 = HexColor("#1D2229");
  static final Color grayBgSwitch = HexColor("#7BA6DF").withOpacity(0.16);
  static final Color grayBgBlueSwitch = HexColor("#226FFF");
  static final Color grayBgDropShadowSwitch = HexColor("#0000001A");
  static const Color grayBgDisabledSwitch = Color(0xFFBDBDBD);
  static final Color borderColor = HexColor("#202C41");
  static final Color selectedTileColor = HexColor("#0A0D11");
  static final Color deviceGradientColor1 = HexColor("#3F7BC0");
  static final Color deviceGradientColor2 = HexColor("#4BBABC");
  static final Color splashGradientColor1 = HexColor("#1B57E1");
  static final Color splashGradientColor2 = HexColor("#47A9C0");
  static final Color splashGradientColor3 = HexColor("#4ABABC");
  static final Color splashGradientColor4 = HexColor("#4ABABC");
  static final Color eventSaveUpto = HexColor("#76D3B8");
  static final Color neutral50 = HexColor("f9f9fb");
  static final Color neutral100 = HexColor("f3f3f6");
  static final Color neutral300 = HexColor("d1d1db");
  static final Color neutral400 = HexColor("9c9caf");
  static final Color neutral500 = HexColor("6b6b80");
  static final Color neutral600 = HexColor("4b4b63");
  static final Color neutral700 = HexColor("373751");
  static final Color neutral800 = HexColor("1f1f37");
  static final Color neutral900 = HexColor("14142b");
  static final Color primary50 = HexColor("b5cfff");
  static final Color primary100 = HexColor("9fc1ff");
  static final Color primary300 = HexColor("89b2ff");
  static final Color primary400 = HexColor("6098ff");
  static final Color primary800 = HexColor("3e82ff");
  static final Color primary900 = HexColor("226fff");
  static final Color secondary50 = HexColor("bfffed");
  static final Color secondary100 = HexColor("acf7e2");
  static final Color secondary300 = HexColor("a0efd9");
  static final Color secondary400 = HexColor("92e7cf");
  static final Color secondary800 = HexColor("86dec5");
  static final Color secondary900 = HexColor("76d3b8");
  static final Color semanticInfoLight = HexColor("e5f5fc");
  static final Color semanticInfoBase = HexColor("017aad");
  static final Color semanticSuccessLight = HexColor("eaf3eb");
  static final Color semanticSuccessBase = HexColor("29823b");
  static final Color semanticWarningLight = HexColor("fdf4e5");
  static final Color semanticWarningBase = HexColor("e99400");
  static final Color semanticErrorLight = HexColor("fceaea");
  // static final Color semanticErrorBase = HexColor("dc2020");
  static final Color semanticErrorBase = HexColor("#FF4747");
  static final Color semanticTextFeildError = HexColor("#FE4848");
  static final Color connectionLostError = HexColor("#FF4747");
  static final Color powerOffColor = HexColor("#323137");
  static final Color powerOffInnerColor = HexColor("#232228");
  static final Color chartColor1 = HexColor("#226FFF");
  static final Color chartColor2 = HexColor("#FF8585");
  static final Color chartColor3 = HexColor("#11CBB7");
  static final Color chartColor4 = HexColor("#FF7F50");
  static final Color chartColor5 = HexColor("#24C3FF");
  static final Color chartColor6 = HexColor("#FDAC85");
  static final Color chartColor7 = HexColor("#5BA8FF");
  static final Color chartColor8 = HexColor("#FFB347");
  static final Color chartColor9 = HexColor("#4ABABC");
  static final Color chartColor10 = HexColor("#FCD849");
  static final Color lineChartGradient1 = HexColor('#FF4747').withOpacity(0.05);
  static final Color lineChartGradient2 = HexColor('#FF4747').withOpacity(0.33);
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
  static const Color grey = Colors.grey;
  static Color grey800 = Colors.grey.shade800;
  static Color grey500 = Colors.grey.shade500;

  // Pow-Dr figma colors end

  static const Color APP_THEME = Color(0xFFffffff);
  static const Color SPLASH_BG = Colors.grey;

  // Figma Primary colors

  static const Color PRIMARY_COLOR = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color SECONDARY_COLOR = Color(0xFF4BA2B5);

  // Primary button
  static const Color PRIMARY_BUTTON_FG = APP_THEME;
  static const Color PRIMARY_BUTTON_BG = APP_THEME;
  static const Color PRIMARY_BUTTON_BORDERCOLOR = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color PRIMARY_BUTTON_DISABLEDCOLOR = Color(0xFFE2DEF5);
  static const Color PRIMARY_BUTTON_LOADERDCOLOR = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color PRIMARY_BUTTON_TEXT = Colors.black;

  //IconTextIcon
  static const Color ICON_TEXT_ICON_BORDER = Color(0xFF676777);
  static const Color ICON_TEXT_ICON_LEFT_ICON = Color(0xFF676777);
  static const Color ICON_TEXT_ICON_RIGHT_ICON = Color(0xFF676777);
  static const Color ICON_TEXT_ICON_BASE = Colors.transparent;

  //Popup Dialog
  static const Color POPUP_DIALOG_BG_TWO_COLOR = Color(0xFFEB595F);
  static const Color POPUP_DIALOG_BG_ONE_COLOR = Color(0xFFE6E6E6);
  static const Color POPUP_DIALOG_TEXT_COLOR = BLACK_1A1A1A;
  static const Color POPUP_DIALOG_DIVIDER_COLOR = Color(0xFFE6E6E6);

  //Popup
  static const Color POPUP_INFO_BASE = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color POPUP_SUCCESS_BASE = FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B;
  static const Color POPUP_WARNING_BASE = FigmaColors.COLOR_SEMANTICWARNING_BASE_E99400;
  static const Color POPUP_ERROR_BASE = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;

  //Toast Message
  static const Color TOAST_MESSAGE_TEXT_COLOR = BLACK_1A1A1A;
  static const Color TOAST_MESSAGE_BG_COLOR = Color(0xFFEB595F);
  static const Color TOAST_MESSAGE_ICON_COLOR = BLACK_1A1A1A;
  static const Color TOAST_MESSAGE_STYLE = Color(0xFFF4F4F5);

  static const Color TOAST_SUCCESS = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color TOAST_ERROR = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color TOAST_ALERT = Color(0xFF4B4B63);
  static const Color TOAST_INFORMATION = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  static const Color TOAST_INFORMATION_BACKGROUND = Color(0xFF50A5F1);
  static const Color TOAST_SUCCESS_BACKGROUND = Color(0xFF34C38F);
  static const Color TOAST_ERROR_BACKGROUND = Color(0xFFF46A6A);
  static const Color TOAST_ALERT_BACKGROUND = Color(0xFFFCECD3);

  //Custom Rounded TabBar
  static const Color SELECTED_TAB_CUSTOM_ROUNDED_TAB_BAR = Color(0xFFEB595F);
  static const Color SELECTED_TEXT_CUSTOM_ROUNDED_TAB_BAR = Color(0xFFE6E6E6);
  static const Color UNSELECTED_TAB_CUSTOM_ROUNDED_TAB_BAR = Color(0xFFDEDEDE);
  static const Color UNSELECTED_TEXT_CUSTOM_ROUNDED_TAB_BAR = BLACK_1A1A1A;

  //IconTitleSubtitle
  static const Color ICON_TITLE_SUBTITLE_BASE = Colors.transparent;
  static const Color ICON_TITLE_SUBTITLE_BORDER = Color(0xFFE6E6E6);
  static const Color ICON_TITLE_SUBTITLE_ICON_COLOR = Color(0xFFEB595F);
  static const Color ICON_TITLE_SUBTITLE_SUBTEXT = Color(0xFF666666);
  static const Color ICON_TITLE_SUBTITLE_TITLE_TEXT = BLACK_1A1A1A;

  //Input Field
  static const Color INPUT_FIELD_BORDER_COLOR = BLACK_1A1A1A;
  static const Color INPUT_FIELD_BG_COLOR = Color(0xFFFFFFFF);
  static const Color INPUT_FIELD_FOCUS_COLOR = BLACK_1A1A1A;
  static const Color INPUT_FIELD_HOVER_COLOR = Colors.transparent;
  static const Color INPUT_FIELD_ERROR_COLOR = Color(0xFFEB595F);
  static const Color INPUT_FIELD_CURSOR_COLOR = BLACK_1A1A1A;
  static const Color INPUT_FIELD_LABEL_STYLE_COLOR = BLACK_1A1A1A;
  static const Color INPUT_FIELD_HINT_STYLE_COLOR = BLACK_1A1A1A;
  static const Color INPUT_FIELD_TEXT_COLOR = BLACK_1A1A1A;

  //Expanding Card
  static const Color EXPANDING_CARD_BASE = Colors.transparent;
  static const Color EXPANDING_CARD_BORDER = Color(0xFFE6E6E6);
  static const Color EXPANDING_CARD_ICON = Color(0xFF676777);
  static const Color EXPANDING_CARD_DIVIDER_COLOR = Colors.transparent;
  static const Color EXPANDING_CARD_TEXT_COLOR = BLACK_1A1A1A;

  //RadioButton
  static const Color RADIO_BUTTON_SELECTED_COLOR = Color(0xFFEB595F);

  //RowIconTextAccessor
  static const Color ROW_ICON_TEXT_ACCESSOR_COLOR_BASE = Colors.white;
  static const Color ROW_ICON_TEXT_ACCESSOR_TEXT_COLOR = BLACK_1A1A1A;
  static const Color ROW_ICON_TEXT_ACCESSOR_SUBTEXT_COLOR = GREY_666666;

  //CountDownTimer
  static const Color COUNT_DOWN_TIMER_BORDER = Color(0xFFF8D7D4);
  static const Color COUNT_DOWN_TIMER_BOX = Color(0xFFFBEBEA);
  static const Color COUNT_DOWN_TIMER_GREY_BORDER = Color(0xFFE6E6E6);
  static const Color COUNT_DOWN_TIMER_ICON = Color(0xFFAF2D22);

  //RowKeyValue
  static const Color ROW_KEY_VALUE_SUBKEY_COLOR = GREY_666666;
  static const Color ROW_KEY_VALUE_KEY_COLOR = GREY_666666;
  static const Color ROW_KEY_VALUE_VALUE_COLOR = BLACK_1A1A1A;

  //CustomExpandedIcon
  static const Color CUSTOM_EXPANDED_ICON = Color(0xFFE6E6E6);

  //Custom Text Field //Expandable
  static const Color CUSTOM_TEXT_FIELD_FILL = Color(0xFFF5F4F8);
  static const Color CUSTOM_TEXT_FIELD_ERROR = Color(0xFFFD6A85);
  static const Color CUSTOM_TEXT_FIELD_FOCUSED = Color(0xFF6CD0B8);
  static const Color CUSTOM_TEXT_FIELD_UNFOCUSED = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color CUSTOM_TEXT_FIELD_TEXT = Color(0xFF34344C);
  static const Color CUSTOM_TEXT_FIELD_LABEL = Color(0xFF858594);
  static const Color CUSTOM_TEXT_FIELD_REQUIRED = Colors.red;

  //Horizontal Radio Group
  static const Color HORIZONTAL_RADIO_SELECTED = Color(0xFF23AA8B);
  static const Color HORIZONTAL_RADIO_TEXT_UNSELECTED = Color(0xFF858594);
  static const Color HORIZONTAL_RADIO_TEXT_SELECTED = Color(0xFF34344C);

  //Box Button
  static const Color BOX_BUTTON_TEXT = BLACK_1A1A1A;

  // Button Underlined
  static const Color BUTTON_UNDERLINED_TEXT = BLACK_1A1A1A;

  //chip view
  static const Color SELECTED_CHIP = Color(0XFFEC5f65);
  static const Color UNSELECTED_CHIP = BLACK_1A1A1A;
  static const Color CHIP_VIEW_BG = Color(0xFFCCCCCC);

  //Dotted Line
  static const Color DOTTED_LINE = Color(0xFFCCCCCC);

  //Primary Elevated button
  static const Color PRIMARY_ELEVATED_BUTTON_BG = APP_THEME;

  //Icon Rating Card
  static const Color ICON_RATING_1 = Color(0xFF666666);
  static const Color ICON_RATING_2 = Color(0xFFCCCCCC);
  static const Color CARD_BG = Color(0xFFF2F2F2);

  //Number Text Field
  static const Color NUMBER_TEXT_FIELD_TEXT = BLACK_1A1A1A;

  //AVATAR ALT TEXt
  static const Color ALT_AVATAR_BG = Color(0xFF4BA2B5);

  // General
  static const Color WHITE = Color(0xFFFFFFFF);
  static const Color BLACK = Color(0xFF000000);
  static const Color GREY = Color(0xFF676777);
  static const Color ERROR = Color(0xFFA20B00);
  static const Color OFF_WHITE_F4F4F5 = Color(0xFFF4F4F5);
  static const Color GREY_666666 = Color(0xFF666666);
  static const Color BLACK_1A1A1A = Color(0xFF1A1A1A);
  static const Color BASICWHITE = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color BASICBLACK = FigmaColors.COLOR_BASICBLACK_0C0C1E;

  //Alert
  static const Color ALERT_INFO_LIGHT = FigmaColors.COLOR_SEMANTICINFO_LIGHT_E5F5FC;
  static const Color ALERT_INFO_BASE = FigmaColors.COLOR_SEMANTICINFO_BASE_017AAD;
  static const Color ALERT_SUCCESS_LIGHT = FigmaColors.COLOR_SEMANTICSUCCESS_LIGHT_EAF3EB;
  static const Color ALERT_SUCCESS_BASE = FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B;
  static const Color ALERT_WARNING_LIGHT = FigmaColors.COLOR_SEMANTICWARNING_LIGHT_FDF4E5;
  static const Color ALERT_WARNING_BASE = FigmaColors.COLOR_SEMANTICWARNING_BASE_E99400;
  static const Color ALERT_ERROR_LIGHT = FigmaColors.COLOR_SEMANTICERROR_LIGHT_FCEAEA;
  static const Color ALERT_ERROR_BASE = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;

  static const Color gray900 = Color(0xff14142b);

  //accodion
  static const Color ACCORDION_TITLE = FigmaColors.COLOR_NEUTRAL900_14142B;
  static const Color ACCORDION_CONTENT = FigmaColors.COLOR_NEUTRAL700_373751;

  //Checkbox
  static const Color CHECKBOX_DEFAULT_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color CHECKBOX_DISABLE_COLOR = FigmaColors.COLOR_NEUTRAL400_9C9CAF;
  static const Color CHECKBOX_SELECTED_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color CHECKBOX_ERROR_BASE = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;
  static const Color CHECKBOX_SELECTED_DISABLED_COLOR = FigmaColors.COLOR_NEUTRAL100_F3F3F6;
  static const Color CHECKBOX_DISABLED_BORDER_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;

  static const Color CHECKBOX_BG_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  // DropDown
  static const Color DROP_DOWN_SEARCH_BORADER_COLOR = FigmaColors.COLOR_NEUTRAL500_6B6B80;
  static const Color DROP_DOWN_DISABLED_COLOR = FigmaColors.COLOR_NEUTRAL100_F3F3F6;
  static const Color DROP_DOWN_BORADER = FigmaColors.COLOR_NEUTRAL500_6B6B80;
  static const Color DROP_DOWN_ACTIVE_BORADER = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color DROP_DOWN_DISABLE_BORADER = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color DROP_DOWN_ERROR_BORADER = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;
  static const Color DROP_DOWN_SELECTED_ITEM_BG = FigmaColors.COLOR_NEUTRAL100_F3F3F6;

  //new figma colors
  //
  // static const Color white = Color(0xFFFFFFFF);
  // static const Color box_shadow = Color(0xffDDDDDD) ;

  // figma button colors
  static const Color PRIMARY_DEFAULT = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color PRIMARY_FOCUSED = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color PRIMARY_ACTIVE = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color PRIMARY_CLICK = FigmaColors.COLOR_PRIMARY900_226FFF;
  static const Color PRIMARY_DISABLED = FigmaColors.COLOR_PRIMARY100_DBEAFE;

  static const Color GHOST_DEFAULT = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color GHOST_FOCUSED = FigmaColors.COLOR_PRIMARY50_EFF6FF;
  static const Color GHOST_ACTIVE = Colors.transparent;
  static const Color GHOST_CLICK = FigmaColors.COLOR_PRIMARY300_93C5FD;
  static const Color GHOST_DISABLED = FigmaColors.COLOR_PRIMARY100_DBEAFE;

  static const Color BORDERLESS_DEFAULT = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color BORDERLESS_FOCUSED = FigmaColors.COLOR_PRIMARY50_EFF6FF;
  static const Color BORDERLESS_ACTIVE = FigmaColors.COLOR_PRIMARY300_93C5FD;
  static const Color BORDERLESS_CLICK = FigmaColors.COLOR_PRIMARY300_93C5FD;
  static const Color BORDERLESS_DISABLED = FigmaColors.COLOR_PRIMARY100_DBEAFE;

  static const Color DISABLED_BUTTON_ICON = FigmaColors.COLOR_PRIMARY300_93C5FD;
  static Map<String, Map<String, Color>> button = {
    "primary": {
      "Default": PRIMARY_DEFAULT,
      "focused": PRIMARY_FOCUSED,
      "active": PRIMARY_ACTIVE,
      "click": PRIMARY_CLICK,
      "disabled": PRIMARY_DISABLED,
    },
    "ghost": {
      "Default": GHOST_DEFAULT,
      "focused": GHOST_FOCUSED,
      "active": GHOST_ACTIVE,
      "click": GHOST_CLICK,
      "disabled": GHOST_DISABLED,
    },
    "borderless": {
      "Default": BORDERLESS_DEFAULT,
      "focused": BORDERLESS_FOCUSED,
      "active": BORDERLESS_ACTIVE,
      "click": BORDERLESS_CLICK,
      "disabled": BORDERLESS_DISABLED,
    },
  };
  static Color buttonIconColorFun(String buttonType, String buttonState) {
    if (buttonState == (ButtonState.disabled.toString().split('.').last)) {
      return AppColors.DISABLED_BUTTON_ICON;
    }
    if (buttonType == (ButtonType.primary.toString().split('.').last)) {
      return AppColors.BASICWHITE;
    }
    return AppColors.PRIMARY_COLOR;
  }

  static Color bgColorForAlert(AlertTypes alertTypes) {
    switch (alertTypes) {
      case AlertTypes.Error:
        return ALERT_ERROR_BASE;
      case AlertTypes.ErrorLight:
        return ALERT_ERROR_LIGHT;
      case AlertTypes.Info:
        return ALERT_INFO_BASE;
      case AlertTypes.InfoLight:
        return ALERT_INFO_LIGHT;
      case AlertTypes.Success:
        return ALERT_SUCCESS_BASE;
      case AlertTypes.SuccessLight:
        return ALERT_SUCCESS_LIGHT;
      case AlertTypes.Warning:
        return ALERT_WARNING_BASE;
      case AlertTypes.WarningLight:
        return ALERT_WARNING_LIGHT;
    }
  }

  static Color alertTextColor(AlertTypes alertTypes) {
    switch (alertTypes) {
      case AlertTypes.Error:
        return BASICWHITE;
      case AlertTypes.ErrorLight:
        return ALERT_ERROR_BASE;
      case AlertTypes.Info:
        return BASICWHITE;
      case AlertTypes.InfoLight:
        return ALERT_INFO_BASE;
      case AlertTypes.Success:
        return BASICWHITE;
      case AlertTypes.SuccessLight:
        return ALERT_SUCCESS_BASE;
      case AlertTypes.Warning:
        return BASICBLACK;
      case AlertTypes.WarningLight:
        return ALERT_WARNING_BASE;
    }
  }

  //  figma colors for card molecule

  static const Color CARD_MOLECULE_BG = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color CARD_MOLECULE_SHADOW = Color(0xffDDDDDD);

  // figma colors for input box
  static const Color INPUT_BOX_DISABLED_BG = FigmaColors.COLOR_NEUTRAL100_F3F3F6;
  static const Color INPUT_BOX_DISABLED_BORDER = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color INPUT_BOX_FOCUSED_BORDER = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color INPUT_BOX_ERROR_BORDER = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;
  static const Color INPUT_BOX_ICON_COLOR = FigmaColors.COLOR_NEUTRAL400_9C9CAF;

  //figma colors for progress bar
  static const Color PROGRESS_BAR_BG_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color PROGRESS_BAR_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color PROGRESS_BAR_UPCOMING_COLOR = FigmaColors.COLOR_NEUTRAL100_F3F3F6;

  // figma for breadcrumb

  static const Color BREADCRUMB_ACTIVE_COLOR = FigmaColors.COLOR_BASICBLACK_0C0C1E;
  static const Color BREADCRUMB_INACTIVE_COLOR = FigmaColors.COLOR_NEUTRAL500_6B6B80;

  // figma colors for switch

  static const Color SWITCH_ACTIVE_BG_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color SWITCH_DEFAULT_ICON_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color SWITCH_DEFAULT_BG_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color SWITCH_DISABLED_ICON_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color SWITCH_DISABLED_BG_COLOR = FigmaColors.COLOR_NEUTRAL100_F3F3F6;

  // figma styles for Rating

  static const Color RATING_GLOW_COLOR = Color(0xffFADB14);
  static const Color RATING_UNRATED_COLOR = Color(0xffE5E5EB);

  // figma colors for radio button

  static const Color RADIO_BUTTON_SELECTED_COLOUR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color RADIO_BUTTON_SELECTED_DISABLED_COLOR = FigmaColors.COLOR_NEUTRAL100_F3F3F6;
  static const Color RADIO_BUTTON_DISABLED_COLOUR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color RADIO_BUTTON_ERROR_COLOUR = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;
  static const Color RADIO_BUTTON_DEFAULT_COLOR = FigmaColors.COLOR_NEUTRAL400_9C9CAF;
  static const Color RADIO_BUTTON_BG_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  // icon badge

  static const Color ICON_BADGE_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color ICON_BADGE_TEXT_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  //Accordion
  static const Color ACCORDION_DIVIDER_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color ACCORDION_BOARDER_COLOR = Color(0xffCED4DA);
  static const Color ACCORDION_TEXT_CONTENT_COLOR = FigmaColors.COLOR_NEUTRAL700_373751;
  static const Color DIVIDER_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color BOARDER_COLOR = Color(0xffCED4DA);

  // figma colors for input number
  static const Color INPUT_NUMBER_DISABLED_BORDER_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color INPUT_NUMBER_FOCUSED_BORDER_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color INPUT_NUMBER_DISABLED_FILL_COLOR = Color(0xffE5E5EB);

  static const Color INPUT_NUMBER_ICONS_COLOR = FigmaColors.COLOR_NEUTRAL500_6B6B80;

  static const Color INPUT_NUMBER_ICON_BORDER_COLOR = FigmaColors.COLOR_NEUTRAL100_F3F3F6;
  static const Color INPUT_NUMBER_CURSOR_COLOR = FigmaColors.COLOR_NEUTRAL900_14142B;

  //figma colors for timeline
  static const Color TIMELINE_ICON_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color TIMELINE_BORDER_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color TIMELINE_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;

  //figma colors for tag
  static const Color TAG_BACKGROUND_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color TAG_ICON_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  //figma colors for range slider
  static const Color RANGE_SLIDER_INACTIVE_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color RANGE_SLIDER_ACTIVE_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;

  static const Color RANGE_SLIDER_DIVIDER_COLOR = FigmaColors.COLOR_NEUTRAL500_6B6B80;

  static const Color RANGE_SLIDER_GREY_DIVIDER_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;

  //figma colors for Tabs
  static const Color TABS_FILL_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color TABS_ACTIVE_BORDER_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color TABS_IN_ACTIVE_BORDER_COLOR = Color(0xffD1D1DB);
  static const Color TABS_ACTIVE_LABEL_COLOR = FigmaColors.COLOR_NEUTRAL800_1F1F37;
  static const Color TABS_IN_ACTIVE_LABEL_COLOR = FigmaColors.COLOR_NEUTRAL500_6B6B80;
  static const Color TABS_TEXT_COLOR_FILLED = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  //Submenu
  static const Color SUBMENU_BG = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color SUBMENU_HIGHLIGHT = FigmaColors.COLOR_PRIMARY900_1E3A8A;

  //Pagination

  static const Color PAGINATION_BUTTON_BG = FigmaColors.COLOR_BASICWHITE_FCFCFC;
  static const Color PAGINATION_INACTIVE_ICON = FigmaColors.COLOR_NEUTRAL400_9C9CAF;
  static const Color PAGINATION_INACTIVE_BUTTON_BORDER = FigmaColors.COLOR_NEUTRAL400_9C9CAF;
  static const Color PAGINATION_ACTIVE_BUTTON_BORDER = FigmaColors.COLOR_PRIMARY900_1E3A8A;

  //LightBox
  static const Color LIGHTBOX_BACKGROUND = FigmaColors.COLOR_BASICBLACK_0C0C1E;
  static const Color LIGHTBOX_CONTROL_BOX = Color(0x33101213);

  //Table
  static const Color TABLE_ROW_BG = FigmaColors.COLOR_NEUTRAL50_F9F9FB;
  static const Color TABLE_BOARDER_COLOR = Color(0xffCED4DA);

  //figma colors for DatePicker
  static const Color DATE_PICKER_SELECTED_BG_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color DATE_PICKER_TODAY_DATE_BG_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color DATE_PICKER_FOOTER_TODAY_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color DATE_PICKER_YEAR_CELL_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color DATE_PICKER_RANGE_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color DATE_PICKER_INPUT_BORDER_COLOR = FigmaColors.COLOR_NEUTRAL400_9C9CAF;
  static const Color DATE_PICKER_EVENT_DOT_COLOR = FigmaColors.COLOR_PRIMARY900_1E3A8A;
  static const Color DATE_PICKER_SELECTED_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  // figma colors for avatar

  static const Color AVATAR_TEXT_BG = FigmaColors.COLOR_PRIMARY300_93C5FD;
  static const Color AVATAR_ICON_BG = FigmaColors.COLOR_NEUTRAL300_D1D1DB;
  static const Color AVATAR_BADGE_COLOR = FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020;

  static const Color STEPS_INACTIVE_COLOR = FigmaColors.COLOR_NEUTRAL300_D1D1DB;

  // figma colors for chart
  static const Color CHART_STROKE_COLOR = FigmaColors.COLOR_BASICWHITE_FCFCFC;

  static const Color COLOR_NEUTRAL300_D1D1DB = FigmaColors.COLOR_NEUTRAL300_D1D1DB;

  static const Color color303337 = Color(0xFF303337);
}
