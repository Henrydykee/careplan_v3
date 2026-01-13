import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailAddressController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _passwordController;
  late final TextEditingController _reEnterPasswordController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;

  bool _obscureText = true;
  bool _obscureText1 = true;

  final _showHideController = TextEditingController(text: 'Show');
  final _showHideController1 = TextEditingController(text: 'Show');

  @override
  void initState() {
    super.initState();
    _emailAddressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _reEnterPasswordController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _showHideController.dispose();
    _showHideController1.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: Strings.create_account,
                        size: 20,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.grey,
                      ),
                      TextHolder(
                        title: Strings.create_account_hint,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        title: "First Name",
                        keyboardType: TextInputType.text,
                        controller: _firstnameController,
                        validator: (val) =>
                        val == null || val.isEmpty ? "This field is required" : null,
                      ),
                      CustomTextField(
                        title: "Last Name",
                        keyboardType: TextInputType.text,
                        controller: _lastnameController,
                        validator: (val) =>
                        val == null || val.isEmpty ? "This field is required" : null,
                      ),
                      CustomTextField(
                        title: Strings.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailAddressController,
                        validator: (val) =>
                        val == null || !val.contains('@') ? 'Email must be valid' : null,
                      ),
                      CustomTextField(
                        title: "Phone Number",
                        controller: _phoneNumberController,
                        validator: (val) =>
                        val == null || val.isEmpty ? 'This field is required' : null,
                        keyboardType: TextInputType.phone,
                        onchanged: (text) {
                          if (text.isNotEmpty && text[0] == '0') {
                            final newText = text.substring(1);
                            _phoneNumberController.value =
                                TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
                          }
                        },
                        prefixText: "+61",
                      ),
                      CustomTextField(
                        title: Strings.password,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        validator: _passwordValidator,
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                              _showHideController.text =
                              _obscureText ? 'Show' : 'Hide';
                            });
                          },
                          child: Text(
                            _showHideController.text,
                            style: TextStyle(color: CarePlanColor.grey),
                          ),
                        ),
                      ),
                      CustomTextField(
                        title: "Re-enter password",
                        obscureText: _obscureText1,
                        keyboardType: TextInputType.text,
                        controller: _reEnterPasswordController,
                        validator: _passwordValidator,
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText1 = !_obscureText1;
                              _showHideController1.text =
                              _obscureText1 ? 'Show' : 'Hide';
                            });
                          },
                          child: Text(
                            _showHideController1.text,
                            style: TextStyle(color: CarePlanColor.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  CustomButtom(
                    title: "Sign Up",
                    btnColor: CarePlanColor.orange,
                    textColor: Colors.white,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Logic removed - design only
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => router.pop(),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                          color: CarePlanColor.green,
                          fontSize: 16,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(
                            text: " Sign In",
                            style: TextStyle(
                              color: CarePlanColor.orange,
                              fontFamily: "Avenir",
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
