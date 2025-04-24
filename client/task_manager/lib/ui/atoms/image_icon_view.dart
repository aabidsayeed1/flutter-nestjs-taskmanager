import 'package:flutter/material.dart';

import '../automation_constants.dart';


class ImageIconView extends StatelessWidget {
  final String? assetPath ;
  final String? networkPath ;
  final double? dScale ;
  final double? dHeight;
  final double? dWidth;
  final Color? iconColor ;
  final double dBorderRadius ;

  const ImageIconView({
    Key? key,
    this.assetPath,
    this.dScale,
    this.iconColor,
    this.dWidth,
    this.dHeight,
    this.networkPath,
    this.dBorderRadius = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.ICON,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dBorderRadius),
        child: assetPath!=null ? Image.asset(
          assetPath??"",
          height: dHeight,
          width: dWidth,
          fit: BoxFit.cover,
          scale: dScale,
        )      :networkPath!=null ?
        Image.network(
          networkPath??"",
          color: iconColor,
          scale: dScale??0.1,
          height: dHeight,
          width: dWidth,
          fit: BoxFit.cover,
        ): Container(),
      ),

    );
  }
}
