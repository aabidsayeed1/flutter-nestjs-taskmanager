import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/ui/automation_constants.dart';
import 'package:task_manager/ui/custom_spacers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class CustomRangeSlider extends StatefulWidget {
  final double dMaxValue;
  final double dStartValue;
  final double dEndValue;
  final bool isRangeSlider;
  final int? iDivisions;
  final Color? activeColor;
  final Color? inActivecolor;
  final Color? thumbColor;
  final bool bShowLabel;
  final String? strLabelText;
  final void Function(RangeValues)? onRangeSliderChanged;
  final void Function(RangeValues)? onRangeSliderChangeStart;
  final void Function(RangeValues)? onRangeSliderChangeEnd;
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangeStart;
  final void Function(double)? onSliderChangeEnd;

  const CustomRangeSlider({
    Key? key,
    required this.dMaxValue,
    required this.dStartValue,
    required this.dEndValue,
    this.isRangeSlider = true,
    this.iDivisions,
    this.inActivecolor = AppColors.RANGE_SLIDER_INACTIVE_COLOR,
    this.activeColor = AppColors.RANGE_SLIDER_ACTIVE_COLOR,
    this.thumbColor = AppColors.BASICWHITE,
    this.bShowLabel = false,
    this.strLabelText,
    this.onRangeSliderChanged,
    this.onRangeSliderChangeStart,
    this.onRangeSliderChangeEnd,
    this.onSliderChanged,
    this.onSliderChangeStart,
    this.onSliderChangeEnd,
  }) : super(key: key);

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late double _currentSliderValue;
  late RangeValues _currentRangeValues;
  ui.Image? customImage;

  @override
  void initState() {
    super.initState();
    loading();
    _currentRangeValues = RangeValues(widget.dStartValue, widget.dEndValue);
    _currentSliderValue = widget.dStartValue;
  }

  loading() async {
    ui.Image image = await load('assets/images/slider_thumb.png');

    if (mounted) {
      setState(() {
        customImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      value: AutomationConstants.RANGE_SLIDER,
      child:
          customImage == null
              ? const SizedBox.shrink()
              : SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.0,
                  trackShape: const RoundedRectSliderTrackShape(),
                  activeTrackColor: widget.activeColor,
                  inactiveTrackColor: widget.inActivecolor, // grey
                  thumbShape: _CustomSliderThumbImage(customImage!, context),
                  rangeThumbShape: _CustomRangeSliderThumbShape(customImage!, context),
                  thumbColor: widget.thumbColor,
                  overlayColor: Colors.black26,
                  // overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                  tickMarkShape: const RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isRangeSlider) ...[
                      _rangeSliderLabel(),
                      CustomSpacers.height4,
                      SizedBox(
                        height: 20,
                        child: RangeSlider(
                          values: _currentRangeValues,
                          max: widget.dMaxValue,
                          divisions: widget.iDivisions ?? widget.dMaxValue.round(),
                          labels: RangeLabels(
                            _currentRangeValues.start.round().toString(),
                            _currentRangeValues.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            if (widget.onRangeSliderChanged != null) {
                              widget.onRangeSliderChanged!(values);
                            }

                            setState(() {
                              _currentRangeValues = values;
                            });
                          },
                          onChangeStart: widget.onRangeSliderChangeStart,
                          onChangeEnd: widget.onRangeSliderChangeEnd,
                        ),
                      ),
                    ] else ...[
                      _sliderLabel(),
                      CustomSpacers.height4,
                      SizedBox(
                        height: 20,
                        child: Slider(
                          value: _currentSliderValue,
                          max: widget.dMaxValue,
                          divisions: widget.iDivisions ?? widget.dMaxValue.round(),
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            if (widget.onSliderChanged != null) {
                              widget.onSliderChanged!(value);
                            }
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                          onChangeStart: widget.onSliderChangeStart,
                          onChangeEnd: widget.onSliderChangeEnd,
                        ),
                      ),
                    ],
                    _sliderBottomIndicators(),
                  ],
                ),
              ),
    );
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Widget _sliderBottomIndicators() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 4, width: 2, color: AppColors.RANGE_SLIDER_DIVIDER_COLOR),
              Container(height: 4, width: 2, color: AppColors.RANGE_SLIDER_DIVIDER_COLOR),
            ],
          ),
        ),
        CustomSpacers.height2,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(widget.dStartValue.toString()), Text(widget.dMaxValue.toString())],
          ),
        ),
      ],
    );
  }

  Widget _sliderLabel() {
    return Row(
      children: [
        CustomSpacers.width24,
        Text("${_currentSliderValue.toString()} ${widget.strLabelText ?? 'Months'}"),
      ],
    );
  }

  Widget _rangeSliderLabel() {
    return Row(
      children: [
        CustomSpacers.width24,
        Text(_currentRangeValues.start.toString()),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 16,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.RANGE_SLIDER_GREY_DIVIDER_COLOR,
          ),
        ),
        Text("${_currentRangeValues.end.toString()} ${widget.strLabelText ?? 'Months'}"),
      ],
    );
  }
}

class _CustomSliderThumbImage extends SliderComponentShape {
  final ui.Image image;
  final BuildContext buildContext;

  _CustomSliderThumbImage(this.image, this.buildContext);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(
    PaintingContext context,
    ui.Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required ui.TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required ui.Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final imageWidth = image.width;
    final imageHeight = image.height;

    Offset imageOffset = Offset(center.dx - (imageWidth / 2), center.dy - (imageHeight / 2));

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(image, imageOffset, paint);
  }
}

class _CustomRangeSliderThumbShape extends RangeSliderThumbShape {
  final BuildContext buildContext;
  final ui.Image image;

  _CustomRangeSliderThumbShape(this.image, this.buildContext);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(1, 0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) async {
    final canvas = context.canvas;
    final imageWidth = image.width;
    final imageHeight = image.height;

    Offset imageOffset = Offset(center.dx - (imageWidth / 2), center.dy - (imageHeight / 2));

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(image, imageOffset, paint);
  }
}
