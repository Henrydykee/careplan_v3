import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/auth/presentation/login_flow/login_screen.dart';
import 'package:careplan/features/auth/presentation/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../domain/usecases/verify_email.dart';

class PhoneNumberConfrimationScreen extends StatefulWidget {
  final String? email;

  const PhoneNumberConfrimationScreen({Key? key, this.email}) : super(key: key);

  @override
  _PhoneNumberConfrimationScreenState createState() =>
      _PhoneNumberConfrimationScreenState();
}

class _PhoneNumberConfrimationScreenState extends State<PhoneNumberConfrimationScreen> {
  TextEditingController? _pinCodeController;
  final _authProvider = inject<AuthenticationProvider>();
  bool _hasHandledState = false;

  @override
  void initState() {
    _pinCodeController = TextEditingController();
    _authProvider.addListener(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onStateChanged);
    _pinCodeController?.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted || _hasHandledState) return;

    if (_authProvider.hasError) {
      _hasHandledState = true;
      showErrorDialog(context, "Verification Failed", _authProvider.errorMessage);
      _pinCodeController?.clear();
      Future.delayed(const Duration(milliseconds: 500), () {
        _hasHandledState = false;
      });
    }

    if (_authProvider.isReady) {
      _hasHandledState = true;
      _showSuccessModal();
    }
  }

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.celebration_image,
              height: 120,
            ),
            const Gap(24),
            TextHolder(
              title: "Verification Successful",
              size: 20,
              fontWeight: FontWeight.w800,
              color: CarePlanColor.brown,
            ),
            const Gap(12),
            TextHolder(
              title: "Your account has been verified successfully. You can now log in to your account.",
              size: 14,
              align: TextAlign.center,
              color: CarePlanColor.grey_3,
            ),
            const Gap(32),
            CustomButtom(
              title: "Continue",
              btnColor: CarePlanColor.orange,
              textColor: Colors.white,
              onTap: () {
                Navigator.of(context).pop();
                router.pushAndRemoveUntil(LoginScreen(), (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _verifyOtp(String code) {
    _authProvider.verifyEmail(
      VerifyEmailParams(
        email: widget.email ?? '',
        verificationCode: code,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authProvider,
      builder: (context, _) {
        return LoaderWrapper(
          isLoading: _authProvider.isLoading,
          view: Scaffold(
            appBar: CustomAppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                        child: TextHolder(
                          title: "OTP Verification",
                          size: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextHolder(
                        title: "Enter the 6-digit verification code sent to your email",
                        size: 15,
                        fontWeight: FontWeight.w500,
                        align: TextAlign.center,
                        color: CarePlanColor.grey,
                      ),
                    ],
                  ),
                  newprojectPinCode(
                    controller: _pinCodeController,
                    length: 4,
                    onCompleted: (code) {
                      _verifyOtp(code);
                    },
                  ),
                  Column(
                    children: [
                      CarePlanKeyPad(onKeyPress: _valueEntered),
                      const SizedBox(height: 20),
                      const Gap(30),
                      const SizedBox(height: 50),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
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
