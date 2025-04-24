import 'dart:async';

import 'package:task_manager/app_imports.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:flutter/material.dart';

class LightBox extends StatefulWidget {
  const LightBox({
    required this.imagePaths,
    this.isAsset = false,
    this.allowZoom = true,
    this.initialIndex,
    this.onClose,
    this.backgroundColor = AppColors.LIGHTBOX_BACKGROUND,
    this.fit = BoxFit.contain,
    this.onPageChanged,
    this.showCloseButton = true,
    this.showControls = true,
    this.showIndexCount = true,
    this.viewHeight = AppValues.LIGHTBOX_HEIGHT,
    this.viewWidth = AppValues.LIGHTBOX_WIDTH,
    Key? key,
  }) : super(key: key);

  final List<String> imagePaths;
  final bool isAsset;

  ///Starts from 0 - should match the max length of passed images
  final int? initialIndex;
  final bool allowZoom;
  final bool showIndexCount;
  final bool showCloseButton;
  final bool showControls;
  final Function? onClose;
  final Function(int index)? onPageChanged;
  final Color backgroundColor;
  final BoxFit fit;
  final double viewHeight;
  final double viewWidth;

  @override
  LightBoxState createState() => LightBoxState();
}

class LightBoxState extends State<LightBox> {
  int _initialIndex = 0;
  late final PageController _controller;
  final StreamController<int> _indexStreamController = StreamController();

  @override
  void initState() {
    ///Check if initial index is in length of given image list
    if (widget.initialIndex != null &&
        widget.initialIndex! <= widget.imagePaths.length &&
        !widget.initialIndex!.isNegative) {
      _initialIndex = widget.imagePaths.length;
    }

    _controller = PageController(initialPage: _initialIndex);
    super.initState();
  }

  _getImageWidgetByPath({required String path, required bool isAsset}) {
    return isAsset ? Image.asset(path, fit: widget.fit) : Image.network(path, fit: widget.fit);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.LIGHTBOX,
      child: Container(
        color: widget.backgroundColor,
        height: widget.viewHeight,
        width: widget.viewWidth,
        child: StreamBuilder<int>(
          stream: _indexStreamController.stream,
          initialData: _controller.initialPage,
          builder: (context, snapshot) {
            int currentIndex = snapshot.data!;
            return Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PageView(
                    onPageChanged: (index) {
                      if (widget.onPageChanged != null) {
                        widget.onPageChanged!(index);
                      }
                      _indexStreamController.add(index);
                    },
                    controller: _controller,
                    children: [
                      for (String path in widget.imagePaths)
                        InteractiveViewer(
                          minScale: 1,
                          maxScale: 2.0,
                          panEnabled: widget.allowZoom,
                          scaleEnabled: widget.allowZoom,
                          child: _getImageWidgetByPath(path: path, isAsset: widget.isAsset),
                        ),
                    ],
                  ),
                ),
                if (widget.showIndexCount)
                  Positioned(
                    top: AppValues.LIGHTBOX_POSITION_PADDING,
                    left: AppValues.LIGHTBOX_POSITION_PADDING,
                    child: Text(
                      '${currentIndex + 1} / ${widget.imagePaths.length}',
                      style: AppStyles.lightboxIndexCountText,
                    ),
                  ),
                if (widget.showCloseButton)
                  Positioned(
                    top: AppValues.LIGHTBOX_POSITION_PADDING,
                    right: AppValues.LIGHTBOX_POSITION_PADDING,
                    child: GestureDetector(
                      onTapUp: (t) {
                        if (widget.onClose != null) widget.onClose!();
                      },
                      child: Image.asset(
                        AppImages.LIGHTBOX_CROSS_ICON,
                        width: AppValues.LIGHTBOX_CONTROL_ICON_WIDTH,
                        height: AppValues.LIGHTBOX_CONTROL_ICON_HEIGHT,
                      ),
                    ),
                  ),
                if (widget.showControls && currentIndex != widget.imagePaths.length - 1)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: AppValues.LIGHTBOX_POSITION_PADDING,
                    child: GestureDetector(
                      onTapUp: (t) {
                        _controller.animateToPage(
                          currentIndex + 1,
                          duration: const Duration(
                            milliseconds: AppValues.LIGHTBOX_SLIDE_ANIM_DURATION_MS,
                          ),
                          curve: Curves.linear,
                        );
                      },
                      child: Align(
                        child: Container(
                          width: AppValues.LIGHTBOX_CONTROL_WIDTH,
                          height: AppValues.LIGHTBOX_CONTROL_HEIGHT,
                          color: AppColors.LIGHTBOX_CONTROL_BOX,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.LIGHTBOX_RIGHT_ARROW,
                              width: AppValues.LIGHTBOX_CONTROL_ICON_WIDTH,
                              height: AppValues.LIGHTBOX_CONTROL_ICON_HEIGHT,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.showControls && currentIndex != 0)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: AppValues.LIGHTBOX_POSITION_PADDING,
                    child: GestureDetector(
                      onTapUp: (t) {
                        _controller.animateToPage(
                          currentIndex - 1,
                          duration: const Duration(
                            milliseconds: AppValues.LIGHTBOX_SLIDE_ANIM_DURATION_MS,
                          ),
                          curve: Curves.linear,
                        );
                      },
                      child: Align(
                        child: Container(
                          width: AppValues.LIGHTBOX_CONTROL_WIDTH,
                          height: AppValues.LIGHTBOX_CONTROL_HEIGHT,
                          color: AppColors.LIGHTBOX_CONTROL_BOX,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.LIGHTBOX_LEFT_ARROW,
                              width: AppValues.LIGHTBOX_CONTROL_ICON_WIDTH,
                              height: AppValues.LIGHTBOX_CONTROL_ICON_HEIGHT,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
