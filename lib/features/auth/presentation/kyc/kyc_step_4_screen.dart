import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class KycVerificationScreen4 extends StatefulWidget {
  final String street;
  final String postalCode;
  final String city;
  final String state;
  final String dob;
  final String gender;

  const KycVerificationScreen4({
    super.key,
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

  void _onConfirm() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    // No submission logic for now (UI-only as requested).
    GlobalSnackBar.show(context, 'KYC registration submitted.');
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: false,
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
  }
}

