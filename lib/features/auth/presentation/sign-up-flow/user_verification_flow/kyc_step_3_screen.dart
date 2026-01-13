import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'kyc_step_1_screen.dart';
import 'kyc_step_4_screen.dart';

class KycVerificationScreen3 extends StatefulWidget {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? street;
  final String? postalCode;
  final String? city;
  final String? state;

  const KycVerificationScreen3(
      {Key? key,
      this.firstName,
      this.middleName,
      this.lastName,
      this.street,
      this.postalCode,
      this.city,
      this.state})
      : super(key: key);

  @override
  _KycVerificationScreen3State createState() => _KycVerificationScreen3State();
}

class _KycVerificationScreen3State extends State<KycVerificationScreen3> {
  TextEditingController? _dobController;
  DateTime _date = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  String dropdownvalue = 'Male';

  var items = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          step: "3",
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextHolder(
                      title: "Date of Birth",
                      size: 16,
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.brown,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    CustomTextField(
                      readOnly: true,
                      onTap: () => _handleDatePicker(),
                      controller: _dobController,
                      hinttitle: "Enter Date Of birth",
                    ),
                    Gap(20),
                    TextHolder(
                      title: "Sex at Birth",
                      size: 16,
                      fontWeight: FontWeight.w800,
                      color: CarePlanColor.brown,
                    ),
                    Gap(20),
                    Container(
                      // ignore: deprecated_member_use
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.withOpacity(0.3)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            value: dropdownvalue,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue){
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomButtom(
                  title: Strings.cotinue,
                  onTap: () {
                    if (_dobController?.text == "") {
            
                    } else {
                      router.push(KycVerificationScreen4(
                        firstName: widget.firstName,
                        middleName: widget.middleName,
                        lastName: widget.lastName,
                        street: widget.street,
                        postalCode: widget.postalCode,
                        city: widget.city,
                        state: widget.state,
                        dob: _dobController?.text,
                        gender: dropdownvalue.toString(),
                      ));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  _handleDatePicker() async {
    if (Platform.isIOS) {
      _showCupertinoDatePicker();
    } else {
      _showMaterialDatePicker();
    }
  }

  _showMaterialDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: CarePlanColor.orange),
          ),
          child: child!,
        );
      },
    );

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dobController?.text = _dateFormat.format(date);
    }
  }

  _showCupertinoDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height /3,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _date,
                minimumDate: DateTime(1800),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _date = newDate;
                  });
                  _dobController?.text = _dateFormat.format(newDate);
                },
              ),
            ),
            CupertinoButton(
              child: Text('Done'),
              onPressed: () => router.pop(),
            )
          ],
        ),
      ),
    );
  }
}
