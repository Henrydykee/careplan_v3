import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/account/domain/usecases/register_kyc.dart';
import 'package:careplan/features/account/presentation/state/kyc_provider.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_indicator.dart';
import 'package:careplan/features/nav_bar/presentation/nav_bar.dart';
import 'package:careplan/core/managers/google_analytics_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class KycVerificationScreen4 extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String street;
  final String postalCode;
  final String city;
  final String state;
  final String dob;
  final String gender;

  const KycVerificationScreen4({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.state,
    required this.dob,
    required this.gender,
  });

  @override
  State<KycVerificationScreen4> createState() => _KycVerificationScreen4State();
}

class _KycVerificationScreen4State extends State<KycVerificationScreen4> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _medicareNumController;
  late final TextEditingController _medicareReferralNumberController;

  @override
  void initState() {
    super.initState();
    _medicareNumController = TextEditingController();
    _medicareReferralNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _medicareNumController.dispose();
    _medicareReferralNumberController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final kycProvider = context.read<KycProvider>();

    final params = RegisterKycParams(
      firstName: widget.firstName,
      lastName: widget.lastName,
      sex: widget.gender,
      street: widget.street,
      postalCode: widget.postalCode,
      city: widget.city,
      state: widget.state,
      country: "Australia",
      dateOfBirth: widget.dob,
      medicareNum: _medicareNumController.text.trim(),
      medicareReferralNumber: _medicareReferralNumberController.text.trim(),
    );

    await kycProvider.registerKyc(params);

    if (!mounted) return;

    if (kycProvider.hasError) {
      showErrorDialog(context, 'KYC Error', kycProvider.errorMessage);
      return;
    }

    googleAnalytics.logEvent(eventName: 'kyc_completed');
    router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KycProvider>(
      builder: (context, kycProvider, _) {
        return LoaderWrapper(
          isLoading: kycProvider.isLoading,
          view: Scaffold(
            appBar: CustomAppBar(showBackIcon: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextHolder(
                                  title: Strings.user_verification,
                                  size: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                                const KycStepIndicator(step: '4'),
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextHolder(
                              title: "Provide Medicare Information",
                              size: 16,
                              fontWeight: FontWeight.w800,
                              color: CarePlanColor.brown,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              title: "Medicare Card number",
                              hinttitle: "Enter Medicare Card number",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _medicareNumController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Field is required";
                                }
                                return null;
                              },
                            ),
                            const Gap(10),
                            CustomTextField(
                              title: "IRN (Individual Reference Number)",
                              hinttitle:
                                  "Enter IRN (Individual Reference Number)",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _medicareReferralNumberController,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Field is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: CustomButtom(
                        title: Strings.confirm,
                        onTap: _onConfirm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
