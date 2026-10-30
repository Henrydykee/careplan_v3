import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/auth/domain/usecases/recover_password.dart';
import 'package:careplan/features/auth/presentation/set-pin/set_pin_screen.dart';
import 'package:careplan/features/nav_bar/presentation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const NewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password cannot be less than 8 characters";
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return "Password must contain a lowercase alphabet";
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return "Password must contain an uppercase alphabet";
    }
    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    return null;
  }

  String? _confirmValidator(String? value) {
    final err = _passwordValidator(value);
    if (err != null) return err;
    if (value != _newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> _onResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await inject<RecoverPassword>().call(
      RecoverPasswordParams(
        email: widget.email,
        otp: widget.otp,
        newPassword: _newPasswordController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    result.fold(
      (error) => showErrorDialog(context, "Password Reset Failed", error.message),
      (user) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successfully")),
        );
        // The reset signs the user back in, so skip the login screen.
        router.pushAndRemoveUntil(
          user.isPinSet == true ? CarePlanNavBar() : SetPinScreen(),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
        appBar: CustomAppBar(
          showBackIcon: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(15),
                  TextHolder(
                    title: "Create a new password",
                    size: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  const Gap(10),
                  TextHolder(
                    title: "Choose a new password. You will use it to sign in.",
                    fontWeight: FontWeight.w500,
                    color: CarePlanColor.grey_2,
                  ),
                  const Gap(30),
                  CustomTextField(
                    title: Strings.password,
                    hinttitle: "New password",
                    obscureText: _obscureNew,
                    controller: _newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: _passwordValidator,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscureNew = !_obscureNew),
                      child: Text(
                        _obscureNew ? 'Show' : 'Hide',
                        style: const TextStyle(color: CarePlanColor.grey),
                      ),
                    ),
                  ),
                  const Gap(20),
                  CustomTextField(
                    title: "Confirm password",
                    hinttitle: "Re-enter new password",
                    obscureText: _obscureConfirm,
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: _confirmValidator,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Text(
                        _obscureConfirm ? 'Show' : 'Hide',
                        style: const TextStyle(color: CarePlanColor.grey),
                      ),
                    ),
                  ),
                  const Gap(30),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: CustomButtom(
                      title: "Reset Password",
                      onTap: _onResetPassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
