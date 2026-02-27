import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/biometric_manager.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/auth/domain/usecases/login_with_pin.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EnableBiometricScreen extends StatefulWidget {
  const EnableBiometricScreen({super.key});

  @override
  State<EnableBiometricScreen> createState() => _EnableBiometricScreenState();
}

class _EnableBiometricScreenState extends State<EnableBiometricScreen> {
  TextEditingController? _pinCodeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pinCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
        appBar: CustomAppBar(
          showBackIcon: true,
          title: "Enable biometric login",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  TextHolder(
                    title: "Confirm your PIN",
                    size: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  const Gap(10),
                  TextHolder(
                    title: "Enter your login PIN to turn on biometric login.",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    color: CarePlanColor.grey,
                  ),
                ],
              ),
            ),
            newprojectPinCode(
              controller: _pinCodeController,
              onCompleted: _onCompleted,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  CarePlanKeyPad(onKeyPress: _valueEntered),
                  const Gap(10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _pinCodeController?.text = '';
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _pinCodeController?.text;
      if (currentText == null || currentText.isEmpty) return;
      if (currentText.length == 1) _pinCodeController?.text = '';
      _pinCodeController?.text =
          currentText.substring(0, currentText.length - 1);
      return;
    }
    if (_pinCodeController?.text.length != 4) {
      _pinCodeController?.text += s;
    }
  }

  Future<void> _onCompleted(String code) async {
    final localStorage = inject<LocalStorageService>();
    final userJson = localStorage.getJson('user');
    final email = userJson?['email'] as String?;

    if (email == null || email.isEmpty) {
      if (!mounted) return;
      showErrorDialog(
        context,
        "Error",
        "We couldn't find your email. Please log in again.",
      );
      Navigator.of(context).pop(false);
      return;
    }

    setState(() => _isLoading = true);
    final result = await inject<LoginWithPin>()
        .call(LoginWithPinParams(email: email, pin: code));
    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (error) {
        showErrorDialog(context, "Login Error", error.message);
      },
      (_) async {
        // Store biometric preferences and PIN for future biometric login
        await localStorage.setBool(SPref.BIOMETRIC, true);
        await localStorage.setString('biometric_pin', code);
        await localStorage.setString('biometric_email', email);
        BioMetricManager().enableBiometric(true);

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      },
    );
  }
}

