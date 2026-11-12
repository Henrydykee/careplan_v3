import 'dart:io';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:careplan/features/auth/presentation/kyc/kyc_step_4_screen.dart';
import 'package:careplan/features/auth/presentation/kyc/widgets/kyc_step_scaffold.dart';
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
  State<KycVerificationScreen3> createState() => _KycVerificationScreen3State();
}

class _KycVerificationScreen3State extends State<KycVerificationScreen3> {
  static const _sexOptions = ['Male', 'Female'];

  final _dobFormat = DateFormat('yyyy-MM-dd');

  late final TextEditingController _dobController;
  late DateTime _selectedDate;
  late String _sex;
  String? _dobError;

  @override
  void initState() {
    super.initState();

    final userJson = inject<LocalStorageService>().getJson('user');
    final user = userJson != null ? UserModel.fromJson(userJson) : null;

    // UserModel carries no date of birth, so this always starts empty; the
    // picker just opens on a sensible year instead of today.
    _selectedDate = DateTime(DateTime.now().year - 30);
    _dobController = TextEditingController();

    final savedSex = user?.sex?.trim().toLowerCase();
    _sex = _sexOptions.firstWhere(
      (o) => o.toLowerCase() == savedSex,
      orElse: () => _sexOptions.first,
    );
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  void _setDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _dobController.text = _dobFormat.format(date);
      _dobError = null;
    });
  }

  Future<void> _handleDatePicker() async {
    FocusScope.of(context).unfocus();
    if (Platform.isIOS) {
      _showCupertinoDatePicker();
    } else {
      await _showMaterialDatePicker();
    }
  }

  Future<void> _showMaterialDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CarePlanColor.orange,
              onPrimary: Colors.white,
              onSurface: CarePlanColor.grey_2,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (date == null) return;
    _setDate(date);
  }

  void _showCupertinoDatePicker() {
    // Mirrors the picker's own starting value so "Done" without scrolling
    // still records a date.
    DateTime pending = _selectedDate;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(bottom: 10),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(8),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: CarePlanColor.grey_5,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(
                height: 220,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (date) => pending = date,
                ),
              ),
              CupertinoButton(
                child: TextHolder(
                  title: 'Done',
                  size: 16,
                  fontWeight: FontWeight.w800,
                  color: CarePlanColor.orange,
                ),
                onPressed: () {
                  _setDate(pending);
                  router.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinue() {
    if (_dobController.text.trim().isEmpty) {
      setState(() => _dobError = 'Please select your date of birth');
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
        dob: _dobController.text.trim(),
        gender: _sex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KycStepScaffold(
      step: 3,
      heading: 'About you',
      subheading: 'These details must match your Medicare record.',
      onContinue: _onContinue,
      fields: [
        CustomTextField(
          title: 'Date of Birth',
          hinttitle: 'Select Date of Birth',
          readOnly: true,
          autofocus: false,
          onTap: _handleDatePicker,
          controller: _dobController,
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: CarePlanColor.grey_3,
          ),
        ),
        if (_dobError != null) ...[
          const Gap(6),
          TextHolder(
            title: _dobError!,
            size: 12,
            color: const Color(0xFFC0392B),
          ),
        ],
        const Gap(18),
        const KycFieldLabel(title: 'Sex at Birth'),
        const Gap(8),
        Row(
          children: [
            for (final option in _sexOptions) ...[
              Expanded(
                child: _SexOption(
                  label: option,
                  selected: _sex == option,
                  onTap: () => setState(() => _sex = option),
                ),
              ),
              if (option != _sexOptions.last) const Gap(12),
            ],
          ],
        ),
      ],
    );
  }
}

class _SexOption extends StatelessWidget {
  const _SexOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 50,
        decoration: BoxDecoration(
          color: selected ? CarePlanColor.light_orange : const Color(0xFFF3F5F7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? CarePlanColor.orange : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: TextHolder(
            title: label,
            size: 15,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? CarePlanColor.brown : CarePlanColor.grey_2,
          ),
        ),
      ),
    );
  }
}
