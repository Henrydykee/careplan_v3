import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/storage/secured_storage.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/account/presentation/card/list_of_cards_screen.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/auth/domain/usecases/get_user_details.dart';
import 'package:careplan/features/auth/presentation/login_flow/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:careplan/features/auth/presentation/kyc/kyc_step_1_screen.dart';

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
    } catch (_) {

    }
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

  void _showLogoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (sheetContext) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
                bottom: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: "Log out?",
                    color: CarePlanColor.brown,
                    size: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const Gap(10),
                  TextHolder(
                    title:
                        "You will need to sign in again to access your account.",
                    color: CarePlanColor.grey_3,
                    size: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const Gap(24),
                  CustomButtom(
                    title: "Cancel",
                    btnColor: CarePlanColor.grey_5,
                    textColor: CarePlanColor.grey,
                    onTap: () => Navigator.of(sheetContext).pop(),
                  ),
                  const Gap(12),
                  CustomButtom(
                    title: "Log out",
                    btnColor: Colors.red.shade700,
                    textColor: Colors.white,
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      await _performLogout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  ),
                  const Gap(30),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    final securedStorage = inject<SecuredStorage>();
    await securedStorage.delete(key: SecureStorageStrings.TOKEN);
    await securedStorage.delete(key: SecureStorageStrings.REFRESH_TOKEN);
    await inject<LocalStorageService>().remove('user');
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
            // Header with colored background
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
                  child: _AccountImageComponent(width: width, user: _user),
                ),
              ),
            ),
            const Gap(24),
            // Menu section
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
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => _showLogoutModal(context),
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

class _AccountImageComponent extends StatelessWidget {
  final double width;
  final UserModel? user;

  const _AccountImageComponent({required this.width, this.user});

  String get _displayName {
    if (user?.firstName != null || user?.lastName != null) {
      return "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();
    }
    return "User";
  }

  String get _displayEmail => user?.email ?? "";

  String get _initials {
    final first = user?.firstName?.isNotEmpty == true ? user!.firstName![0] : '';
    final last = user?.lastName?.isNotEmpty == true ? user!.lastName![0] : '';
    if (first.isNotEmpty || last.isNotEmpty) return "$first$last".toUpperCase();
    return "?";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: CarePlanColor.light_orange,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: _buildInitials(),
          ),
        ),
        const Gap(15),
        TextHolder(
          title: _displayName,
          fontWeight: FontWeight.w800,
          color: CarePlanColor.brown,
          size: 20,
        ),
        const Gap(5),
        TextHolder(
          title: _displayEmail,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF666666),
          size: 14,
        ),
      ],
    );
  }

  Widget _buildInitials() {
    return Container(
      width: 100,
      height: 100,
      color: CarePlanColor.light_orange,
      child: Center(
        child: TextHolder(
          title: _initials,
          fontWeight: FontWeight.w800,
          color: CarePlanColor.brown,
          size: 32,
        ),
      ),
    );
  }
}

class AccountActionItems extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final Color? color;
  final Function? onTap;
  final Widget? trailing;

  const AccountActionItems({
    super.key,
    this.icon,
    this.title,
    this.subTitle,
    this.color,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: CarePlanColor.brown),
              ),
            if (icon != null) const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: title ?? "",
                    fontWeight: FontWeight.w700,
                    color: CarePlanColor.brown,
                    size: 15,
                  ),
                  const Gap(3),
                  TextHolder(
                    title: subTitle ?? "",
                    fontWeight: FontWeight.w400,
                    size: 13,
                    color: CarePlanColor.grey_3,
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    color: CarePlanColor.grey_3, size: 22),
          ],
        ),
      ),
    );
  }
}
