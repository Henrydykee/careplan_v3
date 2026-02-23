import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'confirm_new_pin_screen.dart';

class EnterNewPinScreen extends StatefulWidget {
  final String oldPin;

  const EnterNewPinScreen({super.key, required this.oldPin});

  @override
  State<EnterNewPinScreen> createState() => _EnterNewPinScreenState();
}

class _EnterNewPinScreenState extends State<EnterNewPinScreen> {
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  void _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _pinCodeController.text = '';
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _pinCodeController.text;
      if (currentText.isEmpty) return;
      _pinCodeController.text =
          currentText.length == 1 ? '' : currentText.substring(0, currentText.length - 1);
      return;
    }
    if (_pinCodeController.text.length < 4) {
      _pinCodeController.text += s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackIcon: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "Set a new 4-digit pin",
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                const Gap(10),
                TextHolder(
                  title:
                      "You are changing your current. Ensure to use a pin you can remember.",
                  size: 15,
                  fontWeight: FontWeight.w500,
                  color: CarePlanColor.grey,
                ),
              ],
            ),
            newprojectPinCode(
              controller: _pinCodeController,
              ignoreTouch: true,
              onCompleted: (code) {
                router.push(ConfirmNewPinScreen(
                  oldPin: widget.oldPin,
                  newPin: _pinCodeController.text,
                ));
                _pinCodeController.clear();
                setState(() {});
              },
            ),
            Column(
              children: [
                CarePlanKeyPad(onKeyPress: _valueEntered),
                const SizedBox(height: 20),
                const Gap(30),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
