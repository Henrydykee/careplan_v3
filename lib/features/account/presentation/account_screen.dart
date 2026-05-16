import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/storage/secured_storage.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/account/presentation/card/list_of_cards_screen.dart';
import 'package:careplan/features/account/presentation/widgets/account_action_item.dart';
import 'package:careplan/features/account/presentation/widgets/account_header.dart';
import 'package:careplan/features/account/presentation/widgets/logout_confirmation_sheet.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/auth/domain/usecases/get_user_details.dart';
import 'package:careplan/features/auth/presentation/login_flow/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'profile/edit_profile_screen.dart';
import 'settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  PackageInfo _packageInfo = PackageInfo(
    version: '1.0.0',
    buildNumber: '1',
    packageName: '',
    appName: '',
  );
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _loadUserData();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _loadUserData() async {
    try {
      final localStorage = inject<LocalStorageService>();
      final userJson = localStorage.getJson('user');
      if (userJson != null) {
        try {
          final loadedUser = UserModel.fromJson(userJson);
          if (mounted) setState(() => _user = loadedUser);
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _onRefresh() async {
    final result = await inject<GetUserDetails>().call();
    result.fold(
      (_) {},
      (user) {
        if (mounted) setState(() => _user = user);
      },
    );
  }

  Future<void> _performLogout() async {
    final securedStorage = inject<SecuredStorage>();
    await securedStorage.delete(key: SecureStorageStrings.TOKEN);
    await securedStorage.delete(key: SecureStorageStrings.REFRESH_TOKEN);
    await inject<LocalStorageService>().remove('user');
  }

  void _handleLogoutTap() {
    showLogoutConfirmationSheet(
      context: context,
      onConfirm: () async {
        await _performLogout();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F2),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: CarePlanColor.brown,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: width,
                decoration: const BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: AccountHeader(width: width, user: _user),
                  ),
                ),
              ),
              const Gap(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AccountActionItems(
                        icon: Icons.person_outline_rounded,
                        title: "Profile Settings",
                        subTitle: "Update or modify your profile",
                        onTap: () async {
                          await router.push(EditProfileScreen());
                          _loadUserData();
                        },
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: Colors.grey.shade100,
                      ),
                      AccountActionItems(
                        icon: Icons.lock_outline_rounded,
                        title: "Privacy",
                        subTitle: "Change your pin and password",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: Colors.grey.shade100,
                      ),
                      AccountActionItems(
                        icon: Icons.credit_card_rounded,
                        title: "Payment",
                        subTitle: "Add credit/debit card",
                        onTap: () => router.push(ListOfCardsScreen()),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: _handleLogoutTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            color: Colors.red.shade600, size: 20),
                        const Gap(8),
                        TextHolder(
                          title: "Log out",
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(20),
              Center(
                child: TextHolder(
                  title:
                      "Version ${_packageInfo.version} (${_packageInfo.buildNumber})",
                  size: 12,
                  color: CarePlanColor.grey_3,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
