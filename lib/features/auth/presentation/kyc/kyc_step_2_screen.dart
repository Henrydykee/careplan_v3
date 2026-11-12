import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/state_selector_screen.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_3_screen.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class KycVerificatonScreen2 extends StatefulWidget {
  final String firstName;
  final String lastName;

  const KycVerificatonScreen2({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<KycVerificatonScreen2> createState() => _KycVerificatonScreen2State();
}

class _KycVerificatonScreen2State extends State<KycVerificatonScreen2> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _streetController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  final _streetFocus = FocusNode();
  final _postalCodeFocus = FocusNode();
  final _cityFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    final userJson = inject<LocalStorageService>().getJson('user');
    final user = userJson != null ? UserModel.fromJson(userJson) : null;

    _streetController = TextEditingController(text: user?.street ?? '');
    _postalCodeController = TextEditingController(text: user?.postalCode ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
    _stateController = TextEditingController(text: user?.state ?? '');
  }

  @override
  void dispose() {
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _streetFocus.dispose();
    _postalCodeFocus.dispose();
    _cityFocus.dispose();
    super.dispose();
  }

  Future<void> _selectState() async {
    final result = await router.push(StateSelectorScreen());
    final stateName = result is String ? result.trim() : '';
    if (!mounted || stateName.isEmpty) return;
    setState(() => _stateController.text = stateName);
    // Clear the "field is required" error now that a state is picked.
    _formKey.currentState?.validate();
  }

  String? _required(String? val) =>
      (val == null || val.trim().isEmpty) ? 'Field is required' : null;

  String? _validatePostalCode(String? val) {
    final value = val?.trim() ?? '';
    if (value.isEmpty) return 'Field is required';
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Postal code must be 4 digits';
    }
    return null;
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    router.push(
      KycVerificationScreen3(
        firstName: widget.firstName,
        lastName: widget.lastName,
        street: _streetController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: KycStepScaffold(
        step: 2,
        numericFocusNodes: [_postalCodeFocus],
        heading: 'Home address',
        subheading:
            '',
        onContinue: _onContinue,
        fields: [
          CustomTextField(
            title: 'Street',
            hinttitle: 'Enter Street',
            keyboardType: TextInputType.streetAddress,
            controller: _streetController,
            autofocus: false,
            currentFocusNode: _streetFocus,
            nextFocusNode: _postalCodeFocus,
            textInputAction: TextInputAction.next,
            validator: _required,
          ),
          const Gap(14),
          CustomTextField(
            title: 'Postal Code',
            hinttitle: 'e.g. 2000',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            controller: _postalCodeController,
            autofocus: false,
            currentFocusNode: _postalCodeFocus,
            nextFocusNode: _cityFocus,
            validator: _validatePostalCode,
          ),
          const Gap(14),
          CustomTextField(
            title: 'City',
            hinttitle: 'Enter City',
            keyboardType: TextInputType.text,
            controller: _cityController,
            autofocus: false,
            currentFocusNode: _cityFocus,
            textInputAction: TextInputAction.done,
            validator: _required,
          ),
          const Gap(14),
          CustomTextField(
            title: 'State',
            hinttitle: 'Select State',
            readOnly: true,
            autofocus: false,
            onTap: _selectState,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: CarePlanColor.grey_3,
            ),
            keyboardType: TextInputType.text,
            controller: _stateController,
            validator: _required,
          ),
        ],
      ),
    );
  }
}
