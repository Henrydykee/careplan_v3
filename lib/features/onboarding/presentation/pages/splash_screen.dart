import 'dart:async';
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        router.pushAndRemoveUntil(GetStartedScreen(), (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          Center(child: SvgPicture.asset("assets/images/cp_spalsh_image.svg",height: 150,))
        ],
      ),
    );
  }
}

