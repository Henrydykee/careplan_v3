import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileUpdateSuccessScreen extends StatelessWidget {
  const ProfileUpdateSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: CarePlanColor.brown,
              ),
              const Gap(24),
              Text(
                "Profile updated successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: CarePlanColor.brown,
                ),
              ),
              const Gap(12),
              Text(
                "Your details have been saved. You can continue to use the app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: CarePlanColor.grey_2,
                ),
              ),
              const Gap(40),
              CustomButtom(
                title: "Continue",
                btnColor: CarePlanColor.brown,
                onTap: () {
                  router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
