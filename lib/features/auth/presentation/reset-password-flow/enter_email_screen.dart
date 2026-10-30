import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/auth/presentation/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../domain/usecases/send_recovery_code.dart';
import 'check_email_screen.dart';

class EnterEmailScreen extends StatefulWidget {
  @override
  _EnterEmailScreenState createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  TextEditingController? _emailController;
  final _formKey = GlobalKey<FormState>();
  final _authProvider = inject<AuthenticationProvider>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final email = _emailController!.text.trim();
    await _authProvider.sendRecoveryCode(
      SendRecoveryCodeParams(email: email),
    );
    if (!mounted) return;

    if (_authProvider.hasError) {
      showErrorDialog(context, "Request Failed", _authProvider.errorMessage);
      return;
    }
    router.push(CheckEmailScreen(userEmail: email));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authProvider,
      builder: (context, _) {
        return LoaderWrapper(
          isLoading: _authProvider.isLoading,
          view: Form(
            key: _formKey,
            child: Scaffold(
              appBar: CustomAppBar(
                showBackIcon: true,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(15),
                            TextHolder(
                              title: "Reset my password",
                              size: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            Gap(10),
                            TextHolder(
                              title:
                                  "Enter the email associated with your account and we'll send an email with a link to reset your password. ",
                              fontWeight: FontWeight.w500,
                              color: CarePlanColor.grey_2,
                            ),
                            Gap(30),
                            CustomTextField(
                              title: "Email",
                              controller: _emailController,
                              validator: (val) => val == null || !val.contains('@') ? 'Email must be valid' : null,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: CustomButtom(
                        title: "Send Password Reset Email",
                        onTap: _sendResetCode,
                      ),
                    )
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
