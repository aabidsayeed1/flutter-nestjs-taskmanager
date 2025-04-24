import 'package:flutter/material.dart';

class AbsorbOverScroll extends StatelessWidget {
  const AbsorbOverScroll({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: child,
    );
  }
}
