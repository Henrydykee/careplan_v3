import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/features/auth/presentation/change-password-flow/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'account_screen.dart';
import 'update_pin/enter_old_pin_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Settings",
        showBackIcon: true,
      ),
      body: Column(
        children: [
          const Gap(20),
          AccountActionItems(
            title: "PIN",
            subTitle: "Change current pin",
            onTap: () => router.push(const EnterOldPinScreen()),
          ),
          const Gap(15),
          AccountActionItems(
            title: "Password",
            subTitle: "Change your password",
            onTap: () => router.push(const ChangePasswordScreen()),
          ),
        ],
      ),
    );
  }
}
