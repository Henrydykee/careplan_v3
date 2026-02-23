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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(50),
            _AccountImageComponent(width: width, user: _user),
            const Gap(30),
            AccountActionItems(
              title: "Profile Settings",
              subTitle: "Update or modify your profile",
              onTap: () async {
                await router.push(EditProfileScreen());
                _loadUserData();
              },
            ),
            const Gap(10),
            AccountActionItems(
              title: "Privacy",
              subTitle: "Change your pin and password",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
            const Gap(10),
            AccountActionItems(
              title: "Payment",
              subTitle: "Add credit/debit card",
              onTap: () => router.push(ListOfCardsScreen()),
            ),
            const Gap(50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => _showLogoutModal(context),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: TextHolder(
                        title: "Logout",
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(10),
            Center(
              child: TextHolder(
                title: "V: ${_packageInfo.version} (${_packageInfo.buildNumber})",
                size: 10,
              ),
            ),
            const Gap(20),
          ],
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
  final String? title;
  final String? subTitle;
  final Color? color;
  final Function? onTap;

  const AccountActionItems({
    super.key,
    this.title,
    this.subTitle,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFFF8EEDF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: title ?? "",
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.brown,
                      size: 16,
                    ),
                    const Gap(5),
                    TextHolder(
                      title: subTitle ?? "",
                      fontWeight: FontWeight.w500,
                      size: 14,
                      color: const Color(0xFF666666),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
