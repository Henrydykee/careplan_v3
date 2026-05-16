import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/auth/domain/usecases/update_pin.dart';
import 'package:careplan/features/nav_bar/presentation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConfirmNewPinScreen extends StatefulWidget {
  final String oldPin;
  final String newPin;

  const ConfirmNewPinScreen({
    super.key,
    required this.oldPin,
    required this.newPin,
  });

  @override
  State<ConfirmNewPinScreen> createState() => _ConfirmNewPinScreenState();
}

class _ConfirmNewPinScreenState extends State<ConfirmNewPinScreen> {
  final TextEditingController _pinCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  void _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _pinCodeController.text = '';
      setState(() {});
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _pinCodeController.text;
      if (currentText.isEmpty) return;
      _pinCodeController.text =
          currentText.length == 1 ? '' : currentText.substring(0, currentText.length - 1);
      setState(() {});
      return;
    }
    if (_pinCodeController.text.length < 4) {
      _pinCodeController.text += s;
      setState(() {});
    }
  }

  Future<void> _onConfirmCompleted(String enteredPin) async {
    if (enteredPin != widget.newPin) {
      showErrorDialog(context, "PIN Mismatch", "PINs do not match. Please try again.");
      _pinCodeController.clear();
      setState(() {});
      return;
    }
    setState(() => _isLoading = true);
    final result = await inject<UpdatePin>().call(
      UpdatePinParams(oldPin: widget.oldPin, newPin: widget.newPin),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (error) => showErrorDialog(context, "Update PIN Error", error.message),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PIN updated successfully")),
        );
        router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
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
                    title: "Confirm your new 4-digit pin",
                    size: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  const Gap(10),
                  TextHolder(
                    title: "Re-enter your new pin to confirm.",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    align: TextAlign.center,
                    color: CarePlanColor.grey,
                  ),
                ],
              ),
              newprojectPinCode(
                controller: _pinCodeController,
                ignoreTouch: true,
                onCompleted: _onConfirmCompleted,
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
      ),
    );
  }
}
