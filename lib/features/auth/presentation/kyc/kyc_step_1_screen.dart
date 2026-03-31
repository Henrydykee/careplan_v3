import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_indicator.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class KycVerificatonScreen1 extends StatefulWidget {
  const KycVerificatonScreen1({super.key});

  @override
  State<KycVerificatonScreen1> createState() => _KycVerificatonScreen1State();
}

class _KycVerificatonScreen1State extends State<KycVerificatonScreen1> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();

    final localStorage = inject<LocalStorageService>();
    final userJson = localStorage.getJson('user');
    final user = userJson != null ? UserModel.fromJson(userJson) : null;

    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
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
                            const KycStepIndicator(step: '1'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextHolder(
                          title: "Name on your medicare card",
                          size: 16,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.brown,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          title: "First Name",
                          hinttitle: "Enter First Name",
                          controller: _firstNameController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Field is required";
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        CustomTextField(
                          title: "Last Name",
                          controller: _lastNameController,
                          hinttitle: "Enter Last Name",
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
                        KycVerificatonScreen2(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
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
