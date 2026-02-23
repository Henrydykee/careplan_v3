import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/view_pager.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/features/auth/domain/usecases/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'edit_address_screen.dart';
import 'edit_personal_detail_screen.dart';
import 'profile_update_success_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;
  UserModel? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    try {
      final localStorage = inject<LocalStorageService>();
      final userJson = localStorage.getJson('user');
      if (userJson != null) {
        _user = UserModel.fromJson(userJson);
      }
    } catch (_) {}
  }

  Map<String, dynamic> get _personalData => {
        'firstName': _user?.firstName ?? '',
        'lastName': _user?.lastName ?? '',
        'email': _user?.email ?? '',
        'phone': _user?.phone ?? '',
        'dateOfBirth': _user?.dateOfApproval ?? '',
        'medicareNum': _user?.medicareNum ?? '',
        'medicareReferralNumber': _user?.medicareReferralNumber ?? '',
        'sex': _user?.sex ?? '',
      };

  Map<String, dynamic> get _addressData => {
        'street': _user?.street ?? '',
        'postalCode': _user?.postalCode ?? '',
        'city': _user?.city ?? '',
        'state': _user?.state ?? '',
        'country': _user?.country ?? '',
      };

  /// Builds the full profile payload for PATCH users/profile (API expects camelCase).
  Map<String, dynamic> _fullPayload({
    Map<String, dynamic>? personal,
    Map<String, dynamic>? address,
  }) {
    final u = _user;
    return {
      'firstName': personal?['firstName'] ?? u?.firstName,
      'lastName': personal?['lastName'] ?? u?.lastName,
      'email': personal?['email'] ?? u?.email,
      'phone': personal?['phone'] ?? u?.phone,
      'dateOfBirth': personal?['dateOfBirth'] ?? u?.dateOfApproval,
      'medicareNum': personal?['medicareNum'] ?? u?.medicareNum,
      'medicareReferralNumber': personal?['medicareReferralNumber'] ?? u?.medicareReferralNumber,
      'sex': personal?['sex'] ?? u?.sex,
      'street': address?['street'] ?? u?.street,
      'postalCode': address?['postalCode'] ?? u?.postalCode,
      'city': address?['city'] ?? u?.city,
      'state': address?['state'] ?? u?.state,
      'country': address?['country'] ?? u?.country,
    };
  }

  Future<void> _onSavePersonal(Map<String, dynamic> personalData) async {
    if (_user == null) return;
    setState(() => _isLoading = true);
    final payload = _fullPayload(personal: personalData);
    final result = await inject<UpdateProfile>().call(UpdateProfileParams(payload: payload));
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (error) => showErrorDialog(context, "Update Profile Error", error.message),
      (user) {
        setState(() => _user = user);
        router.pushAndRemoveUntil(const ProfileUpdateSuccessScreen(), (route) => false);
      },
    );
  }

  Future<void> _onSaveAddress(Map<String, dynamic> addressData) async {
    if (_user == null) return;
    setState(() => _isLoading = true);
    final payload = _fullPayload(address: addressData);
    final result = await inject<UpdateProfile>().call(UpdateProfileParams(payload: payload));
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (error) => showErrorDialog(context, "Update Profile Error", error.message),
      (user) {
        setState(() => _user = user);
        router.pushAndRemoveUntil(const ProfileUpdateSuccessScreen(), (route) => false);
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
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
                  EditPersonalProfileScreen(
                    userData: _personalData,
                    onSavePersonal: _onSavePersonal,
                  ),
                  EditAddressScreen(
                    addressData: _addressData,
                    onSaveAddress: _onSaveAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
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
