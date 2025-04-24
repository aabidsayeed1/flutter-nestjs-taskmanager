import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/constants/app_colors.dart';

class OTPTextField extends StatefulWidget {
  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// margin around the text fields
  final EdgeInsetsGeometry margin;

  /// Manage the type of keyboard that shows up
  final TextInputType keyboardType;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// The style to use for the text being edited.
  final double outlineBorderRadius;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Text Field Style
  final OtpFieldStyle? otpFieldStyle;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String>? onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  /// [TextEditingController] to control the text manually. Sets a default [TextEditingController()] object if none given
  final TextEditingController? controller;

  const OTPTextField({
    super.key,
    this.controller,
    this.length = 4,
    this.width = 10,
    this.fieldWidth = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 3),
    this.otpFieldStyle,
    this.keyboardType = TextInputType.number,
    this.style = const TextStyle(),
    this.outlineBorderRadius = 10,
    this.textFieldAlignment = MainAxisAlignment.spaceBetween,
    this.obscureText = false,
    this.fieldStyle = FieldStyle.underline,
    this.onChanged,
    this.onCompleted,
  }) : assert(length > 1);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late OtpFieldStyle _otpFieldStyle;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  late List<Widget> _textFields;
  late List<String> _pin;

  @override
  void initState() {
    if (widget.otpFieldStyle == null) {
      _otpFieldStyle = OtpFieldStyle();
    } else {
      _otpFieldStyle = widget.otpFieldStyle!;
    }
    _focusNodes = List<FocusNode?>.filled(widget.length, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.length, null, growable: false);

    _textFields = List.generate(widget.length, (int i) {
      return buildTextField(context, i);
    });

    if (widget.controller == null || widget.controller!.text.toString() == "") {
      _pin = List.generate(widget.length, (int i) {
        return '';
      });
    } else {
      _pin = List.generate(widget.length, (int i) {
        return widget.controller!.text.toString().substring(i, i + 1);
      });

      _textControllers[0]!.text = widget.controller!.text.toString().substring(0, 1);
      _textControllers[1]!.text = widget.controller!.text.toString().substring(1, 2);
      _textControllers[2]!.text = widget.controller!.text.toString().substring(2, 3);
      _textControllers[3]!.text = widget.controller!.text.toString().substring(3, 4);
    }

    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _textFields,
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int i) {
    if (_focusNodes[i] == null) _focusNodes[i] = FocusNode();

    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
    }

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.backspace ||
              event.logicalKey == LogicalKeyboardKey.delete) {
            if (i == 0) return;
            _focusNodes[i]!.unfocus();
            _focusNodes[i - 1]!.requestFocus();
            return;
          }
        }
      },
      autofocus: true,
      child: Container(
        width: widget.fieldWidth,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: _otpFieldStyle.backgroundColor,
          borderRadius: BorderRadius.circular(widget.outlineBorderRadius),
        ),
        child: TextField(
          cursorColor: AppColors.basicWhite,
          controller: _textControllers[i],
          maxLength: 1,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.center,
          style: widget.style,
          focusNode: _focusNodes[i],
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            counterText: "",
            border: _getBorder(_otpFieldStyle.borderColor),
            focusedBorder: _getBorder(_otpFieldStyle.focusBorderColor),
            enabledBorder: _getBorder(_otpFieldStyle.enabledBorderColor),
            disabledBorder: _getBorder(_otpFieldStyle.disabledBorderColor),
            errorBorder: _getBorder(_otpFieldStyle.errorBorderColor),
          ),
          onChanged: (String str) async {
            if (str.length > 1) {
              _handlePaste(str);
              return;
            }

            // Check if the current value at this position is empty
            // If it is move focus to previous text field.
            if (str.isEmpty) {
              if (i == 0) return;
              _focusNodes[i]!.unfocus();
              _focusNodes[i - 1]!.requestFocus();
            }

            // Update the current pin
            setState(() {
              _pin[i] = str;
            });

            // Remove focus
            if (str.isNotEmpty) _focusNodes[i]!.unfocus();
            // Set focus to the next field if available
            if (i + 1 != widget.length && str.isNotEmpty) {
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            }

            String currentPin = _getCurrentPin();

            // if there are no null values that means otp is completed
            // Call the `onCompleted` callback function provided
            if (!_pin.contains(null) && !_pin.contains('') && currentPin.length == widget.length) {
              widget.onCompleted!(currentPin);
              widget.controller!.text = currentPin;
            }

            // Call the `onChanged` callback function
            widget.onChanged!(currentPin);
          },
        ),
      ),
    );
  }

  InputBorder _getBorder(Color color) {
    return widget.fieldStyle == FieldStyle.box
        ? OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(widget.outlineBorderRadius),
        )
        : UnderlineInputBorder(borderSide: BorderSide(color: color));
  }

  String _getCurrentPin() {
    String currentPin = "";
    for (var value in _pin) {
      currentPin += value;
    }
    return currentPin;
  }

  void _handlePaste(String str) {
    if (str.length > widget.length) {
      str = str.substring(0, widget.length);
    }

    for (int i = 0; i < str.length; i++) {
      String digit = str.substring(i, i + 1);
      _textControllers[i]!.text = digit;
      _pin[i] = digit;
    }

    FocusScope.of(context).requestFocus(_focusNodes[widget.length - 1]);

    String currentPin = _getCurrentPin();

    // if there are no null values that means otp is completed
    // Call the `onCompleted` callback function provided
    if (!_pin.contains(null) && !_pin.contains('') && currentPin.length == widget.length) {
      widget.onCompleted!(currentPin);
    }

    // Call the `onChanged` callback function
    if (widget.onChanged != null) {
      widget.onChanged!(currentPin);
    }
  }
}

enum FieldStyle { underline, box }

class OtpFieldStyle {
  /// The background color for outlined box.
  final Color backgroundColor;

  /// The border color text field.
  final Color borderColor;

  /// The border color of text field when in focus.
  final Color focusBorderColor;

  /// The border color of text field when disabled.
  final Color disabledBorderColor;

  /// The border color of text field when in focus.
  final Color enabledBorderColor;

  /// The border color of text field when disabled.
  final Color errorBorderColor;

  OtpFieldStyle({
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.black26,
    this.focusBorderColor = Colors.black26,
    this.disabledBorderColor = Colors.grey,
    this.enabledBorderColor = Colors.black26,
    this.errorBorderColor = Colors.red,
  });
}
