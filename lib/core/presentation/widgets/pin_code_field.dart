import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../resources/color.dart';

/// PIN entry rendered as a row of dots: an empty slot is a soft grey dot, a
/// filled slot is a solid brand dot. Input is driven by [CarePlanKeyPad] on
/// every screen that uses this, so the field itself stays non-interactive by
/// default ([ignoreTouch]).
class newprojectPinCode extends StatelessWidget {
  final onCompleted;

  final Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? length;
  final bool ignoreTouch;

  static const double _dotSize = 18;

  newprojectPinCode(
      {this.onCompleted,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.length,
      this.ignoreTouch = true});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoreTouch,
      child: PinCodeTextField(
        obscureText: true,
        // The dot is drawn by the slot's fill colour, so the character slot
        // itself renders nothing.
        obscuringWidget: const SizedBox.shrink(),
        blinkWhenObscuring: false,
        controller: controller,
        focusNode: focusNode,
        autoFocus: false,
        onCompleted: onCompleted,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        mainAxisAlignment: MainAxisAlignment.center,
        length: length ?? 4,
        enableActiveFill: true,
        showCursor: false,
        animationType: AnimationType.scale,
        animationDuration: const Duration(milliseconds: 150),
        textStyle: const TextStyle(
          fontSize: 1,
          height: 1,
          color: Colors.transparent,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.circle,
          fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 9),
          fieldHeight: _dotSize,
          fieldWidth: _dotSize,
          borderWidth: 1.5,
          activeBorderWidth: 1.5,
          selectedBorderWidth: 1.5,
          inactiveBorderWidth: 1.5,
          disabledBorderWidth: 1.5,
          errorBorderWidth: 1.5,
          borderRadius: BorderRadius.circular(_dotSize / 2),
          activeColor: CarePlanColor.brown,
          activeFillColor: CarePlanColor.brown,
          selectedColor: CarePlanColor.brown,
          selectedFillColor: Colors.transparent,
          inactiveColor: CarePlanColor.grey_5,
          inactiveFillColor: CarePlanColor.grey_5,
          disabledColor: CarePlanColor.grey_5,
        ),
        onChanged: onChanged ?? (value) {},
        appContext: context,
      ),
    );
  }
}
