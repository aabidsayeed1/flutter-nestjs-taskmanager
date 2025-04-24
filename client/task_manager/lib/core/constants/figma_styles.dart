// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'figma_colors.dart';

///// NAMING STYLE ====   {TextStyleName}{COLORSTYLENAME}

class FigmaStyles {
  static TextStyle h2text4xlfontBoldneutral800 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h3text3xlfontBlackneutral50 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_NEUTRAL50_F9F9FB,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle bodytextbasefontNormalneutral600 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodytextbasefontSemiboldneutral600 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextbasefontNormalprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodytextbasefontNormalneutral500 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodytextbasefontMediumneutral600 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumneutral400 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumsecondary800 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_SECONDARY800_5B21B6,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h5textxlfontBoldneutral900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodytextbasefontMediumbasicwhite = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral400 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h3text3xlfontBoldneutral900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodytextbasefontBoldneutral600 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h6textlgfontSemiboldneutral600 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_mediumneutral600 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontThinprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle captiontextxsfontExtralightprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle captiontextxsfontLightprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle captiontextxsfontNormalprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontMediumprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontSemiboldprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle captiontextxsfontBoldprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle captiontextxsfontExtraboldprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle captiontextxsfontBlackprimary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle bodysmalltextSmfont_thinprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle bodysmalltextSmfont_extralightprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle bodysmalltextSmfont_lightprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle bodysmalltextSmfont_mediumprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_semiboldprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_boldprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodysmalltextSmfont_extraboldprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle bodytextbasefontBlackprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle bodytextbasefontThinprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle bodytextbasefontExtralightprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle bodytextbasefontLightprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle bodytextbasefontMediumprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontSemiboldprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextbasefontBoldprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodytextbasefontExtraboldprimary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h6textlgfontThinprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle h6textlgfontExtralightprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle h6textlgfontLightprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle h6textlgfontNormalprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h6textlgfontMediumprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h6textlgfontSemiboldprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h6textlgfontBoldprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h6textlgfontExtraboldprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h6textlgfontBlackprimary900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle h5textxlfontThinprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle h5textxlfontExtralightprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle h5textxlfontLightprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle h5textxlfontNormalprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h5textxlfontMediumprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h5textxlfontSemiboldprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h5textxlfontBoldprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h5textxlfontExtraboldprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h5textxlfontBlackprimary900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle h4text2xlfontThinprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle h4text2xlfontExtralightprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle h4text2xlfontLightprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle h4text2xlfontNormalprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h4text2xlfontMediumprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h4text2xlfontSemiboldprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h4text2xlfontBoldprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h4text2xlfontExtraboldprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h4text2xlfontBlackprimary900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle h3text3xlfontThinprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle h3text3xlfontExtralightprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle h3text3xlfontLightprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle h3text3xlfontNormalprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h3text3xlfontMediumprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h3text3xlfontSemiboldprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h3text3xlfontBoldprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h3text3xlfontExtraboldprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h3text3xlfontBlackprimary900 = TextStyle(
    fontSize: 30,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle h2text4xlfontThinprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle h2text4xlfontExtralightprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle h2text4xlfontLightprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle h2text4xlfontNormalprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h2text4xlfontMediumprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h2text4xlfontSemiboldprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h2text4xlfontBoldprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h2text4xlfontExtraboldprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h2text4xlfontBlackprimary900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle h1text5xlfontThinprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("thin"),
  );

  static TextStyle h1text5xlfontExtralightprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-light"),
  );

  static TextStyle h1text5xlfontLightprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("light"),
  );

  static TextStyle h1text5xlfontNormalprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h1text5xlfontMediumprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h1text5xlfontSemiboldprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h1text5xlfontBoldprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h1text5xlfontExtraboldprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle h1text5xlfontBlackprimary900 = TextStyle(
    fontSize: 48,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle display2text6xlfont_mediumprimary900 = TextStyle(
    fontSize: 60,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle display2text6xlfont_semiboldprimary900 = TextStyle(
    fontSize: 60,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle display2text6xlfont_boldprimary900 = TextStyle(
    fontSize: 60,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle display2text6xlfont_extraboldprimary900 = TextStyle(
    fontSize: 60,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle display2text6xlfont_blackprimary900 = TextStyle(
    fontSize: 60,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle display1text7xlfont_mediumprimary900 = TextStyle(
    fontSize: 72,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle display1text7xlfont_semiboldprimary900 = TextStyle(
    fontSize: 72,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle display1text7xlfont_boldprimary900 = TextStyle(
    fontSize: 72,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle display1text7xlfont_extraboldprimary900 = TextStyle(
    fontSize: 72,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("extra-bold"),
  );

  static TextStyle display1text7xlfont_blackprimary900 = TextStyle(
    fontSize: 72,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("black"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalsemanticwarning_base = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SEMANTICWARNING_BASE_E99400,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalbasicwhite = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalsemanticsuccess_base = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalsemanticerror_base = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalsemanticinfo_base = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SEMANTICINFO_BASE_017AAD,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontNormalneutral600 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral300 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL300_D1D1DB,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral600 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h5textxlfontSemiboldbasicwhite = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h5textxlfontSemiboldprimary800 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY800_1E40AF,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h5textxlfontSemiboldprimary300 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_PRIMARY300_93C5FD,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextbasefontSemiboldbasicwhite = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextbasefontSemiboldprimary800 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY800_1E40AF,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextbasefontSemiboldprimary300 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_PRIMARY300_93C5FD,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldbasicwhite = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldprimary800 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY800_1E40AF,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldprimary300 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY300_93C5FD,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_normalprimary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_PRIMARY900_1E3A8A,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral800 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodytextbasefontNormalneutral900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontMediumneutral800 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumbasicwhite = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontNormalneutral400 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontNormalneutral900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontNormalneutral400 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontMediumsecondary900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SECONDARY900_4C1D95,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontNormalneutral800 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodytextbasefontNormalneutral300 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL300_D1D1DB,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_mediumneutral800 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h6textlgfontBoldneutral900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodytextbasefontBoldneutral800 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral700 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodysmalltextSmfont_mediumbasicwhite = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_normalneutral500 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontMediumneutral300 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL300_D1D1DB,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumneutral300 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL300_D1D1DB,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumneutral300 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL300_D1D1DB,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumneutral400 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumneutral400 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumneutral500 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumneutral500 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumneutral500 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL500_6B6B80,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumneutral600 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL600_4B4B63,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumneutral800 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL800_1F1F37,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumneutral900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumneutral900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumneutral900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumsemanticsuccess_base = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumsemanticsuccess_base = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumsemanticsuccess_base = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumsemanticwarning_base = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SEMANTICWARNING_BASE_E99400,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumsemanticwarning_base = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SEMANTICWARNING_BASE_E99400,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumsemanticwarning_base = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_SEMANTICWARNING_BASE_E99400,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle captiontextxsfontMediumsemanticerror_base = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumsemanticerror_base = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumsemanticerror_base = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodysmalltextSmfont_mediumsecondary900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_SECONDARY900_4C1D95,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumsecondary900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_SECONDARY900_4C1D95,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle bodytextbasefontMediumneutral700 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h5textxlfontSemiboldneutral900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h6textlgfontNormalneutral900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodytextbasefontSemiboldneutral900 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldneutral400 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL400_9C9CAF,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldneutral900 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h5textxlfontMediumneutral900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h2text4xlfontSemiboldneutral900 = TextStyle(
    fontSize: 36,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h5textxlfontSemiboldbasicblack = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_BASICBLACK_0C0C1E,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h6textlgfontMediumneutral900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h5textxlfontNormalneutral900 = TextStyle(
    fontSize: 20,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h4text2xlfontSemiboldneutral900 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextbasefontBoldneutral700 = TextStyle(
    fontSize: 16,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle captiontextxsfontBoldneutral700 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle captiontextxsfontSemiboldneutral900 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h4text2xlfontSemiboldneutral700 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldneutral700 = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle captiontextxsfontSemiboldneutral700 = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h4text2xlfontMediumneutral700 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h4text2xlfontBoldneutral700 = TextStyle(
    fontSize: 24,
    color: FigmaColors.COLOR_NEUTRAL700_373751,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle captiontextxsfontNormalbasicwhite = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_BASICWHITE_FCFCFC,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle captiontextxsfontNormalsemanticerror_base = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SEMANTICERROR_BASE_DC2020,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h6textlgfontSemiboldneutral900 = TextStyle(
    fontSize: 18,
    color: FigmaColors.COLOR_NEUTRAL900_14142B,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle captiontextxsfontBoldsemanticsuccess_base = TextStyle(
    fontSize: 12,
    color: FigmaColors.COLOR_SEMANTICSUCCESS_BASE_29823B,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle bodysmalltextSmfont_semiboldbasicblack = TextStyle(
    fontSize: 14,
    color: FigmaColors.COLOR_BASICBLACK_0C0C1E,
    fontWeight: getWeightFromString("semi-bold"),
  );

  /// TEXT STYLES WITHOUT COLOR DETAILS
  static TextStyle h5textXlfont_semibold = TextStyle(
    fontSize: 20,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextBasefont_semibold = TextStyle(
    fontSize: 16,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodySmalltext_smfont_semibold = TextStyle(
    fontSize: 14,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle h5textXlfont_medium = TextStyle(
    fontSize: 20,
    fontWeight: getWeightFromString("medium"),
  );

  static TextStyle h6textLgfont_bold = TextStyle(
    fontSize: 18,
    fontWeight: getWeightFromString("bold"),
  );

  static TextStyle h6textLgfont_semibold = TextStyle(
    fontSize: 18,
    fontWeight: getWeightFromString("semi-bold"),
  );

  static TextStyle bodytextBasefont_normal = TextStyle(
    fontSize: 16,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle h6textLgfont_normal = TextStyle(
    fontSize: 18,
    fontWeight: getWeightFromString("regular"),
  );

  static TextStyle bodySmalltext_smfont_normal = TextStyle(
    fontSize: 14,
    fontWeight: getWeightFromString("regular"),
  );

  ////// CHANGE YOUR FONT WEIGHT ACCORDINGLY
  static FontWeight getWeightFromString(String weight) {
    switch (weight) {
      case "thin":
      case "thin-italic":
        return FontWeight.w100;
      case "extra-light":
      case "extra-light-italic":
        return FontWeight.w200;
      case "light":
      case "light-italic":
        return FontWeight.w300;
      case "regular":
      case "regular-italic":
        return FontWeight.w400;
      case "medium":
      case "medium-italic":
        return FontWeight.w500;
      case "semi-bold":
      case "semi-bold-italic":
        return FontWeight.w600;
      case "bold":
      case "bold-italic":
        return FontWeight.w700;
      case "extra-bold":
      case "extra-bold-italic":
        return FontWeight.w800;
      case "black":
      case "black-italic":
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }
}
