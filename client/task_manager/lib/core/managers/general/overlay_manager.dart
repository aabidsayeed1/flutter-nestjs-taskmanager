import 'dart:async';

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/molecules/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class OverlayManager {
  Widget? _widget;

  LoaderOverlayEntry? overlayEntry;
  Widget? get w => _widget;

  factory OverlayManager() => _instance;
  static final OverlayManager _instance = OverlayManager._internal();

  OverlayManager._internal();

  static OverlayManager get instance => _instance;

  static bool get onScreen => _instance.w != null;

  static TransitionBuilder init({TransitionBuilder? builder}) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoaderOverlay(child: child));
      } else {
        return LoaderOverlay(child: child);
      }
    };
  }

  static Future<void> showToast({
    required ToastType type,
    required msg,
    ToastDuration duration = ToastDuration.medium,
  }) async {
    Widget w = Semantics(
      value: "showToast$type",
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 80),
        child: ToastWidget(type: type, title: msg),
      ),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) => _instance._show(widget: w));
    _instance._show(widget: w);
    await Future.delayed(Duration(seconds: _toastEnumToDuration(duration)));
    hideOverlay();
  }

  static int _toastEnumToDuration(ToastDuration toastDuration) {
    switch (toastDuration) {
      case ToastDuration.short:
        return 2;
      case ToastDuration.medium:
        return 3;
      case ToastDuration.long:
        return 5;
    }
  }

  // Brute code remove later
  static showLoaderWText({
    required double opacity,
    required Color color,
    String text = "Initializing",
  }) {
    Widget w = Material(
      elevation: 0.0,
      color: color.withOpacity(opacity),
      child: Container(
        alignment: Alignment.center,
        color: AppColors.WHITE.withOpacity(opacity),
        child: Center(
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const CircularProgressIndicator(), Text(text, style: AppStyles.subTitle)],
            ),
          ),
        ),
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) => _instance._show(widget: w));

    _instance._show(widget: w);
  }

  ///Duration in milliseconds
  static showLoader({
    required double opacity,
    Color color = AppColors.PRIMARY_BUTTON_LOADERDCOLOR,
  }) {
    Widget w = Material(
      elevation: 0.0,
      color: color.withOpacity(opacity),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          color: color.withOpacity(opacity),
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) => _instance._show(widget: w));

    _instance._show(widget: w);
  }

  static Future<void> hideOverlay() {
    return _instance._dismiss();
  }

  _show({Widget? widget}) async {
    _widget = widget;
    _markNeedsBuild();
  }

  Future<void> _dismiss() async {
    _widget = null;
    _markNeedsBuild();
  }

  void _markNeedsBuild() {
    overlayEntry?.markNeedsBuild();
  }

  static TransitionBuilder transitionBuilder({TransitionBuilder? builder}) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(
          context,
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: LoaderOverlay(child: child),
          ),
        );
      } else {
        // return LoaderOverlay(child: child);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: LoaderOverlay(child: child),
        );
      }
    };
  }
}

class LoaderOverlayEntry extends OverlayEntry {
  @override
  // ignore: overridden_fields
  final WidgetBuilder builder;

  LoaderOverlayEntry({required this.builder}) : super(builder: builder);

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {});
      super.markNeedsBuild();
    } else {
      super.markNeedsBuild();
    }
  }
}

class LoaderOverlay extends StatefulWidget {
  final Widget? child;

  const LoaderOverlay({Key? key, required this.child}) : assert(child != null), super(key: key);

  @override
  LoaderOverlayState createState() => LoaderOverlayState();
}

class LoaderOverlayState extends State<LoaderOverlay> {
  late LoaderOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = LoaderOverlayEntry(
      builder: (BuildContext context) => OverlayManager.instance.w ?? Container(),
    );
    OverlayManager.instance.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          LoaderOverlayEntry(
            builder: (BuildContext context) {
              if (widget.child != null) {
                return widget.child!;
              } else {
                return Container();
              }
            },
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}

// ignore: constant_identifier_names
enum ToastType { information, alert, error, success }

enum ToastDuration { short, medium, long }
