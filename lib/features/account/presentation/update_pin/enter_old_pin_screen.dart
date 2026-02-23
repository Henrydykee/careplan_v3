import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'enter_new_pin_screen.dart';

class EnterOldPinScreen extends StatefulWidget {
  const EnterOldPinScreen({super.key});

  @override
  State<EnterOldPinScreen> createState() => _EnterOldPinScreenState();
}

class _EnterOldPinScreenState extends State<EnterOldPinScreen> {
  final TextEditingController _oldPinController = TextEditingController();

  @override
  void dispose() {
    _oldPinController.dispose();
    super.dispose();
  }

  void _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _oldPinController.text = '';
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _oldPinController.text;
      if (currentText.isEmpty) return;
      _oldPinController.text =
          currentText.length == 1 ? '' : currentText.substring(0, currentText.length - 1);
      return;
    }
    if (_oldPinController.text.length < 4) {
      _oldPinController.text += s;
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
                  title: "Enter your old pin",
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                const Gap(10),
                TextHolder(
                  title: "You are changing your current. Please enter old pin",
                  size: 15,
                  fontWeight: FontWeight.w500,
                  color: CarePlanColor.grey,
                ),
              ],
            ),
            newprojectPinCode(
              controller: _oldPinController,
              ignoreTouch: true,
              onCompleted: (code) {
                router.push(EnterNewPinScreen(oldPin: _oldPinController.text));
                _oldPinController.clear();
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
