import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class ChipView extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Function(String) selectedValue;

  const ChipView(
      {Key? key,
      required this.text,
      required this.isSelected,
      required this.selectedValue})
      : super(key: key);

  @override
  ChipViewState createState() => ChipViewState();
}

class ChipViewState extends State<ChipView> {
  @override
  Widget build(BuildContext context) {
    return _buildChoiceChip();
  }

  Widget _buildChoiceChip() {
    return Semantics(
        value: AutomationConstants.CHIP_VIEW,
        child: ChoiceChip(
          label: Text(
            widget.text,
            style: TextStyle(
                color: widget.isSelected
                    ? AppColors.SELECTED_CHIP
                    : AppColors.UNSELECTED_CHIP,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          selected: widget.isSelected,
          onSelected: (bool selected) {
            widget.selectedValue(widget.text);
          },
          shape: StadiumBorder(
            side: BorderSide(
              width: 1,
              color: widget.isSelected
                  ? AppColors.SELECTED_CHIP
                  : AppColors.CHIP_VIEW_BG,
            ),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ));
  }
}
