import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_2_screen.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_scaffold.dart';
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

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();

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
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  String? _required(String? val) =>
      (val == null || val.trim().isEmpty) ? 'Field is required' : null;

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    router.push(
      KycVerificatonScreen2(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: KycStepScaffold(
        step: 1,
        heading: 'Name on your Medicare card',
        subheading:
            'Enter your names exactly as they appear on your Medicare card.',
        onContinue: _onContinue,
        fields: [
          CustomTextField(
            title: 'First Name',
            hinttitle: 'Enter First Name',
            controller: _firstNameController,
            autofocus: false,
            currentFocusNode: _firstNameFocus,
            nextFocusNode: _lastNameFocus,
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          const Gap(14),
          CustomTextField(
            title: 'Last Name',
            hinttitle: 'Enter Last Name',
            controller: _lastNameController,
            autofocus: false,
            currentFocusNode: _lastNameFocus,
            textInputAction: TextInputAction.done,
            validator: _required,
          ),
        ],
      ),
    );
  }
}
