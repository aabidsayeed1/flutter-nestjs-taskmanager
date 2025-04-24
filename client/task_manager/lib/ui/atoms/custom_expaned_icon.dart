import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app_imports.dart';
import '../automation_constants.dart';

class CustomExpanedIcon extends StatefulWidget {
  const CustomExpanedIcon({
    Key? key,
    this.isExpand = false,
    this.iconColor = AppColors.CUSTOM_EXPANDED_ICON,
  }) : super(key: key);

  final bool isExpand;
  final Color iconColor;

  @override
  State<CustomExpanedIcon> createState() => _CustomExpanedIconState();
}

class _CustomExpanedIconState extends State<CustomExpanedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  static final Animatable<double> _iconTurnTween =
      Tween<double>(begin: 0.0, end: 0.5)
          .chain(CurveTween(curve: Curves.fastOutSlowIn));

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = _controller.drive(_iconTurnTween);

    if (widget.isExpand) {
      _controller.value = math.pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomExpanedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpand != oldWidget.isExpand) {
      if (widget.isExpand) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.CUSTOM_EXPANDED_ICON,
      child: RotationTransition(
        turns: _iconTurns,
        child: Icon(
          Icons.expand_more,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
