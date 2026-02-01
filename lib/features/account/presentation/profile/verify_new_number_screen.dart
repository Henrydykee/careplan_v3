import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VerifyNewNumberScreen extends StatefulWidget {
  final String? number;

  const VerifyNewNumberScreen({super.key, required this.number});

  @override
  State<VerifyNewNumberScreen> createState() => _VerifyNewNumberScreenState();
}

class _VerifyNewNumberScreenState extends State<VerifyNewNumberScreen> {
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  void _onCodeVerified() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Number verified successfully")),
    );
    router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "Verify Number",
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                TextHolder(
                  title:
                      "Please enter the 4-digit code sent to ${widget.number}.",
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
                _onCodeVerified();
              },
            ),
            Column(
              children: [
                newprojectKeyPad(onKeyPress: _valueEntered),
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
