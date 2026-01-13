import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/state_selector_screen.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'kyc_step_1_screen.dart';
import 'kyc_step_3_screen.dart';

class KycVerificatonScreen2 extends StatefulWidget {
  @override
  _KycVerificatonScreen2State createState() => _KycVerificatonScreen2State();
}

class _KycVerificatonScreen2State extends State<KycVerificatonScreen2> {
  TextEditingController? _streetController;
  TextEditingController? _postalcodeController;
  TextEditingController? _cityController;
  TextEditingController? _stateController;
  GlobalKey<FormState> _formKey = new GlobalKey();
  List<Map<String, dynamic>> stateData = [];

  @override
  void initState() {
    super.initState();
    // _getState();
    _streetController = TextEditingController();
    _postalcodeController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
      ),
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
                          KycStepIndicator(
                            step: "2",
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextHolder(
                        title: "Home Address",
                        size: 16,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "Street",
                          hinttitle: "Enter Street",
                          keyboardType: TextInputType.text,
                          controller: _streetController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "Postal Code",
                          hinttitle: "Enter Postal Code",
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: _postalcodeController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "City",
                          hinttitle: "Enter City",
                          keyboardType: TextInputType.text,
                          controller: _cityController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "State",
                          hinttitle: "Enter State",
                          readOnly: true,
                          onTap: () async {
                            var state = await router.push(StateSelectorScreen());
                            if (state == null || state.toString().isEmpty || state.toString() == "") {
                              setState(() {
                                _stateController?.text = "";
                              });
                            } else {
                              setState(() {
                                _stateController?.text = state.toString();
                              });
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: _stateController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // TextHolderField(
                      //   title: "Country",
                      //   // controller: _lastNameController,
                      // )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomButtom(
                    title: Strings.cotinue,
                    onTap: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      } else {
                        router.push(KycVerificationScreen3(
                          street: _streetController?.text,
                          postalCode: _postalcodeController?.text,
                          city: _cityController?.text,
                          state: _stateController?.text,
                        ));
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
