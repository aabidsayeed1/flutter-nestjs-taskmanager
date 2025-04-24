import 'package:gap/gap.dart';
import 'package:task_manager/app_imports.dart';
import 'package:flutter/material.dart';

class TryAgainWidget extends StatelessWidget {
  const TryAgainWidget({required this.onTap, required this.message, Key? key}) : super(key: key);

  final void Function() onTap;
  final String message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: AppStyles.textErrorStyle),
            Gap(4),
            const Icon(Icons.refresh, color: Colors.black),
          ],
        ),
      ),
    );
  }
}


