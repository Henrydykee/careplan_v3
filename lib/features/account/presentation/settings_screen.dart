import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/biometric_manager.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/presentation/change-password-flow/change_password_screen.dart';
import 'package:careplan/features/auth/presentation/login_flow/enable_biometric_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'widgets/account_action_item.dart';
import 'update_pin/enter_old_pin_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
  }

  Future<void> _loadBiometricPreference() async {
    try {
      final localStorage = inject<LocalStorageService>();
      final stored = localStorage.getBool(SPref.BIOMETRIC);
      if (mounted) {
        setState(() {
          _biometricEnabled = stored ?? false;
        });
      }
    } catch (_) {}
  }

  Future<void> _navigateToEnableBiometric() async {
    final result = await router.push<bool>(const EnableBiometricScreen());
    if (result == true && mounted) {
      await _loadBiometricPreference();
    }
  }

  Future<void> _disableBiometric() async {
    try {
      final localStorage = inject<LocalStorageService>();
      await localStorage.setBool(SPref.BIOMETRIC, false);
      await localStorage.remove('biometric_pin');
      await localStorage.remove('biometric_email');
      BioMetricManager().enableBiometric(false);
    } catch (_) {}
    if (mounted) {
      setState(() {
        _biometricEnabled = false;
      });
    }
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
            onTap: () => router.push(const EnterOldPinScreen()),
          ),
          const Gap(15),
          AccountActionItems(
            title: "Password",
            subTitle: "Change your password",
            onTap: () => router.push(const ChangePasswordScreen()),
          ),
          const Gap(15),
          AccountActionItems(
            title: "Biometric login",
            subTitle: "Use Face ID / fingerprint to log in",
            onTap: () {
              if (_biometricEnabled) {
                _disableBiometric();
              } else {
                _navigateToEnableBiometric();
              }
            },
            trailing: Switch(
              value: _biometricEnabled,
              activeColor: CarePlanColor.brown,
              onChanged: (value) {
                if (value) {
                  _navigateToEnableBiometric();
                } else {
                  _disableBiometric();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
