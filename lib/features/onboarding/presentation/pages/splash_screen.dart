import 'dart:async';
import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/storage/secured_storage.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/auth/presentation/login_flow/welcome_back_screen.dart';
import 'package:careplan/features/auth/presentation/set-pin/set_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/presentation/widgets/router.dart';
import '../../../../core/utils/color.dart';
import '../../../../features/getting_started/get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Keep the existing 2s splash experience
    await Future.delayed(const Duration(seconds: 2));

    final securedStorage = inject<SecuredStorage>();
    final token =
        await securedStorage.get(key: SecureStorageStrings.TOKEN) as String?;
    final localStorage = inject<LocalStorageService>();
    final userJson = localStorage.getJson('user');

    if (!mounted) return;

    if (token == null || token.isEmpty || userJson == null) {
      router.pushAndRemoveUntil(GetStartedScreen(), (route) => false);
      return;
    }

    bool isPinSet = false;
    String? firstName;
    try {
      final user = UserModel.fromJson(userJson);
      isPinSet = user.isPinSet == true;
      firstName = user.firstName;
    } catch (_) {
      isPinSet = userJson['isPinSet'] == true;
      firstName = userJson['firstName'] as String?;
    }

    if (isPinSet) {
      router.pushAndRemoveUntil(
        WelcomeBackScreen(firstName: firstName),
        (route) => false,
      );
    } else {
      router.pushAndRemoveUntil(SetPinScreen(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarePlanColor.deep_green,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/splash_background.png",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: SvgPicture.asset(
              "assets/images/cp_spalsh_image.svg",
              height: 150,
            ),
          )
        ],
      ),
    );
  }
}

