import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';

import 'kyc_step_2_screen.dart';

class KycVerificatonScreen1 extends StatefulWidget {
  @override
  _KycVerificatonScreen1State createState() => _KycVerificatonScreen1State();
}

class _KycVerificatonScreen1State extends State<KycVerificatonScreen1> {
  TextEditingController? _firstNameController;
  TextEditingController? _middleNameController;
  TextEditingController? _lastNameController;
  GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
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
                            step: "1",
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextHolder(
                        title: "Name on your medicare card",
                        size: 16,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "First Name",
                          hinttitle: "Enter First Name",
                          controller: _firstNameController,
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        title: "Middle Name (Optional)",
                        controller: _middleNameController,
                        hinttitle: "Enter Middle Name",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          title: "Last Name",
                          controller: _lastNameController,
                          hinttitle: "Enter Last Name",
                          validator: (val) => val == null || val.isEmpty ? "Field is required" : null)
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
                        router.push(KycVerificatonScreen2());
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

class KycStepIndicator extends StatelessWidget {
  final String? step;
  final String? total;

  const KycStepIndicator({Key? key, this.step, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xFFF4EDE3),
            border: Border.all(color: Color(0xFFF9E2C8), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 13),
          child: Row(
            children: [
              TextHolder(
                title: "Step",
                color: CarePlanColor.brown,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(
                width: 3,
              ),
              TextHolder(
                title: step ?? "4",
                color: CarePlanColor.brown,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(
                width: 3,
              ),
              TextHolder(
                title: "of",
                color: CarePlanColor.brown,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(
                width: 3,
              ),
              TextHolder(
                title: total ?? "4",
                color: CarePlanColor.brown,
                fontWeight: FontWeight.w800,
              )
            ],
          ),
        ));
  }
}
