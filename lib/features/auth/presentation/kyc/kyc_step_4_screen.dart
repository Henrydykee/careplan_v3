import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/google_analytics_manager.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/account/domain/usecases/register_kyc.dart';
import 'package:careplan/features/account/presentation/state/kyc_provider.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/auth/domain/usecases/get_user_details.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_scaffold.dart';
import 'package:careplan/features/nav_bar/presentation/nav_bar.dart';
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

  final _medicareNumFocus = FocusNode();
  final _irnFocus = FocusNode();

  /// Keeps the loader up while the refreshed profile is fetched, between a
  /// successful submit and landing on Home.
  bool _finishing = false;

  @override
  void initState() {
    super.initState();

    final userJson = inject<LocalStorageService>().getJson('user');
    final user = userJson != null ? UserModel.fromJson(userJson) : null;

    _medicareNumController = TextEditingController(text: user?.medicareNum ?? '');
    _medicareReferralNumberController =
        TextEditingController(text: user?.medicareReferralNumber ?? '');
  }

  @override
  void dispose() {
    _medicareNumController.dispose();
    _medicareReferralNumberController.dispose();
    _medicareNumFocus.dispose();
    _irnFocus.dispose();
    super.dispose();
  }

  String? _required(String? val) =>
      (val == null || val.trim().isEmpty) ? 'Field is required' : null;

  Future<void> _onConfirm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

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

    setState(() => _finishing = true);

    // Pull the updated profile before leaving. getUserDetails also rewrites the
    // cached user in local storage, which is what Home reads on mount — without
    // this it would still show the pre-KYC status and empty details.
    await inject<GetUserDetails>().call();

    if (!mounted) return;

    router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KycProvider>(
      builder: (context, kycProvider, _) {
        return Form(
          key: _formKey,
          child: KycStepScaffold(
            step: 4,
            numericFocusNodes: [_medicareNumFocus, _irnFocus],
            heading: 'Medicare details',
            subheading:
                'Your card number and the reference number next to your name.',
            buttonTitle: Strings.confirm,
            isLoading: kycProvider.isLoading || _finishing,
            onContinue: _onConfirm,
            fields: [
              CustomTextField(
                title: 'Medicare Card number',
                hinttitle: 'Enter Medicare Card number',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                controller: _medicareNumController,
                autofocus: false,
                currentFocusNode: _medicareNumFocus,
                nextFocusNode: _irnFocus,
                validator: _required,
              ),
              const Gap(14),
              CustomTextField(
                title: 'IRN (Individual Reference Number)',
                hinttitle: 'The number beside your name on the card',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                controller: _medicareReferralNumberController,
                autofocus: false,
                currentFocusNode: _irnFocus,
                validator: _required,
              ),
            ],
          ),
        );
      },
    );
  }
}
