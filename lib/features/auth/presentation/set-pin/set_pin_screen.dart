import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'confrim_pin_screen.dart';

class SetPinScreen extends StatefulWidget {
  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  TextEditingController? _pinCodeController;

  @override
  void initState() {
    _pinCodeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "Create your 4 digit pin",
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                Gap(10),
                TextHolder(
                  title: "This pin will be used to log into your account.",
                  size: 15,
                  fontWeight: FontWeight.w500,
                  align: TextAlign.center,
                  color: CarePlanColor.grey,
                ),
              ],
            ),
            newprojectPinCode(
              controller: _pinCodeController,
              onCompleted: (code) {
                router.pushAndRemoveUntil(
                    ConfrimPinScreen(
                          pin: _pinCodeController!.text,
                    ),
                    (route) => false);
              },
            ),
            Column(
              children: [
                CarePlanKeyPad(onKeyPress: _valueEntered),
                SizedBox(
                  height: 20,
                ),
                // CarePlanText(
                //   title: "Resend Code",
                //   color: Color(0xFF215543),
                //   size: 15,
                //   fontWeight: FontWeight.w800,
                // ),
                Gap(30),
                SizedBox(
                  height: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _pinCodeController!.text = '';
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _pinCodeController!.text;
      if (currentText.isEmpty) return;
      if (currentText.length == 1) _pinCodeController!.text = '';
      _pinCodeController!.text =
          currentText.substring(0, currentText.length - 1);
      return;
    }
    if (_pinCodeController?.text.length != 4) {
      _pinCodeController!.text += s;
    }
  }
}
