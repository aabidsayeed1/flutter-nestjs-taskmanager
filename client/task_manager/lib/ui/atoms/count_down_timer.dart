import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../app_imports.dart';
import '../automation_constants.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key? key,
    required this.timeDuration,
    required this.callback,
    this.prefixText,
    this.suffixText,
    this.countdownDuration = 10,
  }) : super(key: key);

  final Duration timeDuration;
  final VoidCallback callback;
  final String? prefixText;
  final String? suffixText;
  final int countdownDuration;

  @override
  State createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration duration = Duration.zero;

  String formatHHMMSS(int seconds) {
    if ((seconds != 0) && seconds > 0) {
      int hours = (seconds / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      int minutes = (seconds / 60).truncate();

      String hoursStr = (hours).toString().padLeft(2, '0');
      String minutesStr = (minutes).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      if (hours == 0) {
        return "${widget.prefixText ?? ""} $minutesStr:$secondsStr ${widget.suffixText ?? "mins"}";
      }

      return "${widget.prefixText ?? ""} $hoursStr:$minutesStr:$secondsStr ${widget.suffixText ?? "hrs"}";
    }
    return "${widget.prefixText ?? ""} 00:00 ${widget.suffixText ?? "mins"}";
  }

  @override
  void initState() {
    super.initState();
    duration = widget.timeDuration;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.COUNT_DOWN_TIMER,
      child: TweenAnimationBuilder<Duration>(
          duration: duration,
          tween: Tween(begin: duration, end: Duration.zero),
          onEnd: widget.callback,
          builder: (BuildContext context, Duration value, Widget? child) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: value < Duration(seconds: widget.countdownDuration)
                          ? AppColors.COUNT_DOWN_TIMER_BOX
                          : AppColors.WHITE,
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: value <
                                  Duration(seconds: widget.countdownDuration)
                              ? AppColors.COUNT_DOWN_TIMER_BORDER
                              : AppColors.COUNT_DOWN_TIMER_GREY_BORDER),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color:
                            value < Duration(seconds: widget.countdownDuration)
                                ? AppColors.COUNT_DOWN_TIMER_ICON
                                : null,
                      ),
                      Gap(8),
                      Text(formatHHMMSS(value.inSeconds),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400))
                    ],
                  ),
                ));
          }),
    );
  }
}
