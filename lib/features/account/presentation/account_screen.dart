import 'package:cached_network_image/cached_network_image.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/account/presentation/card/list_of_cards_screen.dart';
import 'package:careplan/features/auth/presentation/login_flow/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'profile/edit_profile_screen.dart';
import 'settings_screen.dart';

// Mock user data
class MockUser {
  static const String firstName = "John";
  static const String lastName = "Smith";
  static const String email = "john.smith@example.com";
  static const String phone = "+1 234 567 8900";
  static const String? imageUrl = null;
}

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

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(50),
            _AccountImageComponent(width: width),
            const Gap(30),
            AccountActionItems(
              title: "Profile Settings",
              subTitle: "Update or modify your profile",
              onTap: () => router.push(EditProfileScreen()),
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
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
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

  const _AccountImageComponent({required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: CarePlanColor.light_orange,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: MockUser.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: MockUser.imageUrl!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    errorWidget: (context, url, error) => _buildInitials(),
                  )
                : _buildInitials(),
          ),
        ),
        const Gap(15),
        TextHolder(
          title: "${MockUser.firstName} ${MockUser.lastName}",
          fontWeight: FontWeight.w800,
          color: CarePlanColor.brown,
          size: 20,
        ),
        const Gap(5),
        TextHolder(
          title: MockUser.email,
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
          title: "${MockUser.firstName[0]}${MockUser.lastName[0]}",
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
