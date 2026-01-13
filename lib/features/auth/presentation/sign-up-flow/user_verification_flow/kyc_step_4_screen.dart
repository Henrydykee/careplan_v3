import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'kyc_step_1_screen.dart';

class KycVerificationScreen4 extends StatefulWidget {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? street;
  final String? postalCode;
  final String? city;
  final String? state;
  final String? gender;
  final String? dob;

  const KycVerificationScreen4(
      {Key? key,
      this.firstName,
      this.middleName,
      this.lastName,
      this.street,
      this.postalCode,
      this.city,
        this.gender,
      this.state,
      this.dob})
      : super(key: key);

  @override
  _KycVerificationScreen4State createState() => _KycVerificationScreen4State();
}

class _KycVerificationScreen4State extends State<KycVerificationScreen4> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController? medicareidController;
  TextEditingController? medicareReferralNumberController;

  @override
  void initState() {
    super.initState();
    medicareidController = TextEditingController();
    medicareReferralNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
      ),
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
                          KycStepIndicator()
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextHolder(
                        title: "Provide Medicare Information",
                        size: 16,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "Medicare Card number",
                          hinttitle: "Enter Medicare Card number",
                          keyboardType: TextInputType.number,
                          controller: medicareidController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      Gap(10),
                      CustomTextField(
                          title: "IRN (Individual Reference Number)",
                          hinttitle: "Enter IRN (Individual Reference Number)",
                          keyboardType: TextInputType.number,
                          controller: medicareReferralNumberController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      SizedBox(
                        height: 40,
                      ),
                      // UploadDocWidget()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomButtom(
                  title: Strings.confirm,
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    // Logic removed - design only
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
