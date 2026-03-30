import 'dart:io';

import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_4_screen.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class KycVerificationScreen3 extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String street;
  final String postalCode;
  final String city;
  final String state;

  const KycVerificationScreen3({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.state,
  });

  @override
  State<KycVerificationScreen3> createState() =>
      _KycVerificationScreen3State();
}

class _KycVerificationScreen3State extends State<KycVerificationScreen3> {
  final _dobFormat = DateFormat('yyyy-MM-dd');
  late final DateFormat _pickerFormat = _dobFormat;

  late final TextEditingController _dobController;
  DateTime _selectedDate = DateTime.now();

  String dropdownValue = 'Male';
  final List<String> items = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _handleDatePicker() async {
    if (Platform.isIOS) {
      _showCupertinoDatePicker();
    } else {
      _showMaterialDatePicker();
    }
  }

  Future<void> _showMaterialDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                ColorScheme.light(primary: CarePlanColor.orange),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (date == null || date == _selectedDate) return;

    setState(() {
      _selectedDate = date;
      _dobController.text = _pickerFormat.format(date);
    });
  }

  void _showCupertinoDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height / 3,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: DateTime(1800),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                    _dobController.text = _pickerFormat.format(newDate);
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => router.pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    final dob = _dobController.text.trim();
    if (dob.isEmpty) {
      GlobalSnackBar.show(context, 'Please select your date of birth.');
      return;
    }

    router.push(
      KycVerificationScreen4(
        firstName: widget.firstName,
        lastName: widget.lastName,
        street: widget.street,
        postalCode: widget.postalCode,
        city: widget.city,
        state: widget.state,
        dob: dob,
        gender: dropdownValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: false,
      view: Scaffold(
        appBar: CustomAppBar(showBackIcon: true),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextHolder(
                            title: Strings.user_verification,
                            size: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          const KycStepIndicator(step: '3'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextHolder(
                        title: "Date of Birth",
                        size: 16,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                      CustomTextField(
                        readOnly: true,
                        onTap: () {
                          _handleDatePicker();
                        },
                        controller: _dobController,
                        hinttitle: "Select Date of Birth",
                      ),
                      const Gap(20),
                      TextHolder(
                        title: "Sex at Birth",
                        size: 16,
                        fontWeight: FontWeight.w800,
                        color: CarePlanColor.brown,
                      ),
                      const Gap(20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          value: dropdownValue,
                          items: items.map((v) {
                            return DropdownMenuItem(
                              value: v,
                              child: Text(v),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue == null) return;
                            setState(() => dropdownValue = newValue);
                          },
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
                  onTap: _onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
