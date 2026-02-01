import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/view_pager.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'edit_address_screen.dart';
import 'edit_personal_detail_screen.dart';

/// Mock profile data for edit profile screen.
class MockProfileData {
  static const String firstName = "John";
  static const String lastName = "Smith";
  static const String email = "john.smith@example.com";
  static const String phone = "412345678";
  static const String dateOfBirth = "1990-01-15";
  static const String medicareNum = "1234567890";
  static const String medicareReferralNumber = "1";
  static const String street = "123 Main Street";
  static const String postalCode = "2000";
  static const String city = "Sydney";
  static const String state = "NSW";
  static const String country = "Australia";

  static Map<String, dynamic> get personal => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'medicareNum': medicareNum,
        'medicareReferralNumber': medicareReferralNumber,
      };

  static Map<String, dynamic> get address => {
        'street': street,
        'postalCode': postalCode,
        'city': city,
        'state': state,
        'country': country,
      };
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackIcon: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextHolder(
              title: "Update Profile Information",
              fontWeight: FontWeight.w900,
              size: 19,
              color: CarePlanColor.brown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: _carePlanViewPager(),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) => setState(() => pageChanged = index),
              children: [
                EditPersonalProfileScreen(userData: MockProfileData.personal),
                EditAddressScreen(addressData: MockProfileData.address),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _carePlanViewPager() {
    return Row(
      children: [
        Expanded(
          child: ViewPagerHeader(
            title: "Personal",
            color: pageChanged == 0 ? CarePlanColor.light_orange : Colors.white,
            borderColor: pageChanged == 0
                ? CarePlanColor.orange
                : Colors.grey.withValues(alpha: 0.3),
            textColor: pageChanged == 0 ? CarePlanColor.brown : Colors.grey,
            onTap: () => pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: ViewPagerHeader(
            title: "Address",
            textColor: pageChanged == 1 ? CarePlanColor.brown : Colors.grey,
            color: pageChanged == 1 ? CarePlanColor.light_orange : Colors.white,
            borderColor: pageChanged == 1
                ? CarePlanColor.orange
                : Colors.grey.withValues(alpha: 0.3),
            onTap: () => pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
        ),
      ],
    );
  }
}
