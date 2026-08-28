import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/biometric_manager.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/core/data/network/network_interceptor.dart';
import 'package:careplan/features/auth/domain/usecases/login_with_pin.dart';
import 'package:careplan/features/getting_started/presentation/get_started_screen.dart';
import 'package:careplan/features/nav_bar/presentation/nav_bar.dart';
import 'package:careplan/core/managers/google_analytics_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class WelcomeBackScreen extends StatefulWidget {
  final String? firstName;
  final bool fromUnauthorized;

  const WelcomeBackScreen({
    super.key,
    this.firstName,
    this.fromUnauthorized = false,
  });

  @override
  _WelcomeBackScreenState createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  TextEditingController? _pinCodeController;
  bool _isLoading = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _pinCodeController = TextEditingController();
    _loadBiometricPreference();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
        appBar: CustomAppBar(showBackIcon: false),
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
                    title:
                        "Welcome back, ${widget.firstName?.isNotEmpty == true ? widget.firstName : "User"}! 👋",
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
              onCompleted: _onCompleted,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  CarePlanKeyPad(
                    onKeyPress: _valueEntered,
                    rightAction: _biometricEnabled
                        ? EquityKeyCell.withChild(
                            value: 'biometric',
                            onTap: (_) => _onBiometricTap(),
                            child: SvgPicture.asset(
                              Assets.biometric,
                              height: 26,
                              width: 26,
                            ),
                          )
                        : null,
                  ),
                  Gap(10),
                  InkWell(
                    onTap: () {
                      router.pushAndRemoveUntil(
                          GetStartedScreen(), (route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: CarePlanColor.light_orange),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextHolder(
                          title:
                              "No, I am not ${widget.firstName?.isNotEmpty == true ? widget.firstName : "User"}!",
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

  Future<void> _onCompleted(String code) async {
    await _loginWithPin(code);
  }

  Future<void> _loadBiometricPreference() async {
    try {
      final localStorage = inject<LocalStorageService>();
      final enabled = localStorage.getBool(SPref.BIOMETRIC) ?? false;
      final biometricPin = localStorage.getString('biometric_pin');
      if (!mounted) return;
      setState(() {
        _biometricEnabled =
            enabled && biometricPin != null && biometricPin.isNotEmpty;
      });
    } catch (_) {}
  }

  Future<void> _onBiometricTap() async {
    if (_isLoading || !_biometricEnabled) return;

    final localStorage = inject<LocalStorageService>();
    final storedPin = localStorage.getString('biometric_pin');
    final storedBiometricEmail = localStorage.getString('biometric_email');

    if (storedPin == null || storedPin.isEmpty) {
      showErrorDialog(
        context,
        "Login Error",
        "Biometric PIN is missing. Please enter your PIN and enable biometric again.",
      );
      return;
    }

    try {
      final bioMetricManager = BioMetricManager();
      await bioMetricManager.checkAvailableBiometrics();
      final requireAuthentication =
          await bioMetricManager.authenticateUser();

      if (requireAuthentication) {
        return;
      }

      await _loginWithPin(storedPin, emailOverride: storedBiometricEmail);
    } catch (e) {
      if (mounted) {
        showErrorDialog(
          context,
          "Biometric Error",
          "Biometric authentication failed. Please use your PIN instead.",
        );
      }
    }
  }

  Future<void> _loginWithPin(String code, {String? emailOverride}) async {
    final localStorage = inject<LocalStorageService>();
    final userJson = localStorage.getJson('user');
    final emailFromUser = userJson?['email'] as String?;
    final email = (emailOverride != null && emailOverride.isNotEmpty)
        ? emailOverride
        : emailFromUser;

    if (email == null || email.isEmpty) {
      showErrorDialog(
        context,
        "Login Error",
        "We couldn't find your email. Please log in again.",
      );
      router.pushAndRemoveUntil(GetStartedScreen(), (route) => false);
      return;
    }

    setState(() => _isLoading = true);
    final result = await inject<LoginWithPin>()
        .call(LoginWithPinParams(email: email, pin: code));
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (error) =>
          showErrorDialog(context, "Login Error", error.message),
      (_) {
        resetUnauthorizedNavigation();
        googleAnalytics.logEvent(eventName: 'login', parameters: {'method': 'pin'});
        router.pushAndRemoveUntil(
          CarePlanNavBar(),
          (route) => false,
        );
      },
    );
  }
}
