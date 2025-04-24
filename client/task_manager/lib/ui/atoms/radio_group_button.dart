import 'package:flutter/material.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class RadioGroupButton extends StatefulWidget {
  final List<String> arrayOfTexts;
  final Color colorSelected;
  final bool isHorizontal;
  final String? initiallySelected;
  final void Function(int) clickAction;
  final CrossAxisAlignment crossAxisAlignment;

  const RadioGroupButton(
      {Key? key,
      required this.arrayOfTexts,
      this.initiallySelected,
      this.colorSelected = AppColors.HORIZONTAL_RADIO_SELECTED,
      this.clickAction = _defaultFunction,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.isHorizontal = false})
      : super(key: key);

  @override
  State<RadioGroupButton> createState() => _RadioGroupButtonState();

  static _defaultFunction(int nIndex) {
    // Does nothing
  }
}

class _RadioGroupButtonState extends State<RadioGroupButton> {
  int nSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initiallySelected != null) {
      nSelectedIndex = widget.arrayOfTexts.indexOf(widget.initiallySelected!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.HORIZONTAL_RADIO_GROUP,
      child: Container(
        color: Colors.transparent,
        child: widget.isHorizontal
            ? createListOfHorizontalRadioButtons(context)
            : createListOfVerticalRadioButtons(context),
      ),
    );
  }

  Widget createListOfHorizontalRadioButtons(BuildContext context) {
    Row listOfRadioButtons = const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [],
    );

    for (int nLoop = 0; nLoop < widget.arrayOfTexts.length; nLoop++) {
      listOfRadioButtons.children.add(Expanded(
        child: Container(
            color: Colors.transparent,
            child: Row(children: [
              Radio(
                activeColor: widget.colorSelected,
                value: nLoop,
                groupValue: nSelectedIndex,
                onChanged: (value) {
                  if (nSelectedIndex != value) {
                    setState(() {
                      nSelectedIndex = value as int;
                    });

                    widget.clickAction(nSelectedIndex);
                  }
                },
              ),
              Expanded(
                child: Text(
                  widget.arrayOfTexts[nLoop],
                  style: nSelectedIndex == nLoop
                      ? AppStyles.selectedText
                      : AppStyles.unselectedText,
                ),
              )
            ])),
      ));
    }

    return listOfRadioButtons;
  }

  Widget createListOfVerticalRadioButtons(BuildContext context) {
    Column listOfRadioButtons = Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: const [],
    );

    for (int nLoop = 0; nLoop < widget.arrayOfTexts.length; nLoop++) {
      listOfRadioButtons.children.add(SizedBox(
        child: ListTile(
          title: Text(
            widget.arrayOfTexts[nLoop],
            style: Theme.of(context).textTheme.bodySmall,
          ),
          leading: Radio(
            activeColor: widget.colorSelected,
            value: nLoop,
            groupValue: nSelectedIndex,
            onChanged: (value) {
              if (nSelectedIndex != value) {
                setState(() {
                  nSelectedIndex = value as int;
                });

                widget.clickAction(nSelectedIndex);
              }
            },
          ),
        ),
      ));
    }

    return listOfRadioButtons;
  }
}
