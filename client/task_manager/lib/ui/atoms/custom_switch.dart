import 'package:task_manager/app_imports.dart';
import 'package:flutter/cupertino.dart';

import '../automation_constants.dart';

class CustomSwitch extends StatefulWidget {
  final Function(bool)? onChange;
  final bool bInitialValue;
  final Color activeColor;
  final bool bDisable;
  final Color defaultIconColor;
  final Color defaultBgColor;
  final Color disabledIconColor;
  final Color disabledBgColor;

  const CustomSwitch({
    Key? key,
    this.onChange,
    this.bInitialValue = false,
    this.activeColor = AppColors.SWITCH_ACTIVE_BG_COLOR,
    this.defaultIconColor = AppColors.SWITCH_DEFAULT_ICON_COLOR,
    this.defaultBgColor = AppColors.SWITCH_DEFAULT_BG_COLOR,
    this.disabledIconColor = AppColors.SWITCH_DISABLED_ICON_COLOR,
    this.disabledBgColor = AppColors.SWITCH_DISABLED_BG_COLOR,
    this.bDisable = false,
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.bInitialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.SWITCH,
      child: CupertinoSwitch(
        value: value,
        activeColor: widget.bDisable ? widget.disabledBgColor : widget.activeColor,
        trackColor: widget.bDisable ? widget.disabledBgColor : widget.defaultBgColor,
        thumbColor: widget.bDisable ? widget.disabledIconColor : widget.defaultIconColor,
        onChanged:
            widget.bDisable
                ? (bool val) {}
                : (bool val) {
                  setState(() {
                    value = val;
                  });
                  if (widget.onChange != null) {
                    widget.onChange!(val);
                  }
                },
      ),
    );
  }
}
