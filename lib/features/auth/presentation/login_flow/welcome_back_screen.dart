import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/getting_started/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WelcomeBackScreen extends StatefulWidget {
  @override
  _WelcomeBackScreenState createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  TextEditingController? _pinCodeController;
  String? _firstname = "User";

  @override
  void initState() {
    super.initState();
    _pinCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "Welcome back, $_firstname! 👋",
                  size: 18,
                  fontWeight: FontWeight.w800,
                ),
                Gap(10),
                TextHolder(
                  title: "Enter your PIN to log in",
                  size: 15,
                  fontWeight: FontWeight.w500,
                  color: CarePlanColor.grey,
                ),
              ],
            ),
          ),
          newprojectPinCode(
            controller: _pinCodeController,
            onCompleted: (code) {
              // Logic removed - design only
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                CarePlanKeyPad(onKeyPress: _valueEntered),
                Gap(10),
                InkWell(
                  onTap: () {
                    router.pushAndRemoveUntil(GetStartedScreen(), (route) => false);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: CarePlanColor.light_orange),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: TextHolder(
                        title: "No, I am not $_firstname!",
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _pinCodeController?.text = '';
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _pinCodeController?.text;
      if (currentText == null || currentText.isEmpty) return;
      if (currentText.length == 1) _pinCodeController?.text = '';
      _pinCodeController?.text = currentText.substring(0, currentText.length - 1);
      return;
    }
    if (_pinCodeController?.text.length != 4) {
      _pinCodeController?.text += s;
    }
  }
}
