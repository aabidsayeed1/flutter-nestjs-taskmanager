import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dPadding;

  const DottedLine(
      {Key? key,
      this.dPadding = 16,
      this.height = 1,
      this.color = AppColors.DOTTED_LINE})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.DOTTED_LINE,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final boxWidth = constraints.constrainWidth();
            const dashWidth = 5.0;
            final dashHeight = height;
            final dashCount = (boxWidth / (2 * dashWidth)).floor();
            return Flex(
              children: List.generate(dashCount, (_) {
                return SizedBox(
                  width: dashWidth,
                  height: dashHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: color),
                  ),
                );
              }),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
            );
          },
        ),
      ),
    );
  }
}
