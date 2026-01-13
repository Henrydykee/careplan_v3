import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/web_view_screen.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/getting_started/get_started_screen.dart';
import 'package:flutter/material.dart';

import '../reset-password-flow/enter_email_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? passwordController;
  bool _obscureText = true;
  var _showHideController = TextEditingController(text: 'Show');

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        onTap: () => router.push(GetStartedScreen()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: Strings.sign_into_an_account,
                        color: CarePlanColor.grey,
                        size: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        controller: emailController,
                        title: Strings.email,
                        hinttitle: Strings.enter_email_address,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val == null || !val.contains('@') ? 'Email must be valid' : null,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        title: Strings.password,
                        hinttitle: Strings.enter_password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_obscureText == true) {
                                _obscureText = false;
                                _showHideController.text = 'Hide';
                              } else {
                                _obscureText = true;
                                _showHideController.text = 'Show';
                              }
                            });
                          },
                          child: Container(
                            child: Text(
                              _showHideController.text,
                              style: TextStyle(color: CarePlanColor.grey),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextHolder(
                            title: Strings.forgot_password,
                            color: CarePlanColor.green,
                            size: 15,
                            fontWeight: FontWeight.w800,
                            onTap: () => router.push(EnterEmailScreen()),
                          ),
                          TextHolder(
                            title: Strings.privacy_policy,
                            color: CarePlanColor.green,
                            size: 15,
                            fontWeight: FontWeight.w800,
                            onTap: () => router.push(WebViewScreen(
                              url: "https://app.cp365.health/privacy#intro",
                            )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomButtom(
                title: Strings.sign_in,
                btnColor: CarePlanColor.orange,
                textColor: Colors.white,
                onTap: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  // Logic removed - design only
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
