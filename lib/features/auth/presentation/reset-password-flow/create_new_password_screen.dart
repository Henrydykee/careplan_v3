import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String otpCode;

  CreateNewPasswordScreen({required this.otpCode});

  @override
  _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _obscureText = true;
  bool _obscureText1 = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _passwordController;
  TextEditingController? _reEnterPasswordController;
  var _showHideController = TextEditingController(text: 'Show');
  var _showHideController1 = TextEditingController(text: 'Show');

  @override
  void initState() {
    _passwordController = TextEditingController();
    _reEnterPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(15),
                      TextHolder(
                        title: "Create New Password",
                        size: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      Gap(10),
                      TextHolder(
                        title: "Your new password must be different from previous used passwords. ",
                        color: CarePlanColor.grey_2,
                      ),
                      Gap(40),
                      CustomTextField(
                        title: Strings.password,
                        obscureText: _obscureText,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 8) {
                            return "Password cannot be less than 8 characters";
                          }
                          if (!RegExp("^(?=.*[a-z])").hasMatch(value)) {
                            return "Password must contain a lowercase alphabet";
                          }
                          if (!RegExp("^(?=.*[A-Z])").hasMatch(value)) {
                            return "Password must contain a uppercase alphabet";
                          }
                          if (!RegExp("^(?=.*[0-9])").hasMatch(value)) {
                            return "Password must contain at least one number";
                          }
                          return null;
                        },
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
                      Gap(40),
                      CustomTextField(
                        title: "Re-enter password",
                        obscureText: _obscureText1,
                        controller: _reEnterPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 8) {
                            return "Password cannot be less than 8 characters";
                          }
                          if (!RegExp("^(?=.*[a-z])").hasMatch(value)) {
                            return "Password must contain a lowercase alphabet";
                          }
                          if (!RegExp("^(?=.*[A-Z])").hasMatch(value)) {
                            return "Password must contain a uppercase alphabet";
                          }
                          if (!RegExp("^(?=.*[0-9])").hasMatch(value)) {
                            return "Password must contain at least one number";
                          }
                          return null;
                        },
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_obscureText1 == true) {
                                _obscureText1 = false;
                                _showHideController1.text = 'Hide';
                              } else {
                                _obscureText1 = true;
                                _showHideController1.text = 'Show';
                              }
                            });
                          },
                          child: Container(
                            child: Text(
                              _showHideController1.text,
                              style: TextStyle(color: CarePlanColor.grey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
              child: CustomButtom(
                title: "Reset Password",
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
