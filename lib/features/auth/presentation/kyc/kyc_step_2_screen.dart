import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/state_selector_screen.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_3_screen.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class KycVerificatonScreen2 extends StatefulWidget {
  const KycVerificatonScreen2({super.key});

  @override
  State<KycVerificatonScreen2> createState() => _KycVerificatonScreen2State();
}

class _KycVerificatonScreen2State extends State<KycVerificatonScreen2> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _streetController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController();
    _postalCodeController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _selectState() async {
    final result = await router.push(StateSelectorScreen());
    final stateName = result is String ? result.trim() : '';
    if (!mounted) return;
    setState(() {
      _stateController.text = stateName;
    });
  }

  void _onStateTap() {
    _selectState();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const KycStepIndicator(step: '2'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextHolder(
                          title: "Home Address",
                          size: 16,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.brown,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          title: "Street",
                          hinttitle: "Enter Street",
                          keyboardType: TextInputType.text,
                          controller: _streetController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        CustomTextField(
                          title: "Postal Code",
                          hinttitle: "Enter Postal Code",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _postalCodeController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        CustomTextField(
                          title: "City",
                          hinttitle: "Enter City",
                          keyboardType: TextInputType.text,
                          controller: _cityController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        CustomTextField(
                          title: "State",
                          hinttitle: "Select State",
                          readOnly: true,
                          onTap: _onStateTap,
                          keyboardType: TextInputType.text,
                          controller: _stateController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: CustomButtom(
                    title: Strings.cotinue,
                    onTap: () {
                      final valid = _formKey.currentState?.validate() ?? false;
                      if (!valid) return;
                      router.push(
                        KycVerificationScreen3(
                          street: _streetController.text.trim(),
                          postalCode: _postalCodeController.text.trim(),
                          city: _cityController.text.trim(),
                          state: _stateController.text.trim(),
                        ),
                      );
                    },
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

