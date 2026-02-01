import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature - Coming Soon"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
            onTap: () => _showComingSoon(context, "Change PIN"),
          ),
          const Gap(15),
          AccountActionItems(
            title: "Password",
            subTitle: "Change your password",
            onTap: () => _showComingSoon(context, "Change Password"),
          ),
        ],
      ),
    );
  }
}
