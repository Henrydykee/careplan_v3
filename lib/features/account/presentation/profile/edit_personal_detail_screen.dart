import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/nav_bar/presentation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EditPersonalProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final Future<void> Function(Map<String, dynamic> personalData)? onSavePersonal;

  const EditPersonalProfileScreen({
    super.key,
    this.userData,
    this.onSavePersonal,
  });

  @override
  State<EditPersonalProfileScreen> createState() =>
      _EditPersonalProfileScreenState();
}

class _EditPersonalProfileScreenState extends State<EditPersonalProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dodController;
  late TextEditingController medicareController;
  late TextEditingController medicareIRNController;

  static const List<String> _sexOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  String? _sex;

  DateTime? _date;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _displayDateFormat = DateFormat('d MMMM yyyy');

  /// Strips Australian dial code (+61 / 61) so the prefix "+61 " is not duplicated in the field.
  static String _phoneWithoutDialCode(String? phone) {
    if (phone == null || phone.isEmpty) return '';
    return phone.trim().replaceFirst(RegExp(r'^\+?61\s*'), '').trim();
  }

  @override
  void initState() {
    super.initState();
    final d = widget.userData ?? {};
    firstNameController =
        TextEditingController(text: d['firstName'] ?? 'John');
    lastNameController =
        TextEditingController(text: d['lastName'] ?? 'Smith');
    emailController =
        TextEditingController(text: d['email'] ?? 'john.smith@example.com');
    final phoneDisplay = _phoneWithoutDialCode(d['phone']?.toString());
    phoneController =
        TextEditingController(text: phoneDisplay.isEmpty ? '412345678' : phoneDisplay);
    try {
      _date = _dateFormat.parse(d['dateOfBirth']?.toString() ?? '1990-01-15');
    } catch (_) {
      _date = DateTime(1990, 1, 15);
    }
    dodController =
        TextEditingController(text: _date != null ? _displayDateFormat.format(_date!) : '');
    medicareController =
        TextEditingController(text: d['medicareNum'] ?? '');
    medicareIRNController =
        TextEditingController(text: d['medicareReferralNumber'] ?? '1');
    _sex = d['sex']?.toString().trim();
    if (_sex != null && _sex!.isEmpty) _sex = null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dodController.dispose();
    medicareController.dispose();
    medicareIRNController.dispose();
    super.dispose();
  }

  Future<void> _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
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
    if (date != null) {
      setState(() {
        _date = date;
        dodController.text = _displayDateFormat.format(date);
      });
    }
  }

  Widget _sexDropdown() {
    final selected = _sex != null && _sexOptions.contains(_sex) ? _sex! : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sex",
          style: TextStyle(
            fontSize: 14,
            color: CarePlanColor.brown,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8),
        InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selected,
              isExpanded: true,
              hint: const Text("Select"),
              items: _sexOptions
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _sex = v),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    final onSave = widget.onSavePersonal;
    if (onSave == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
      router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
      return;
    }
    final phoneRaw = phoneController.text.trim().replaceAll(RegExp(r'\s+'), '');
    final phone = phoneRaw.isEmpty ? '' : (phoneRaw.startsWith('+') ? phoneRaw : '+61$phoneRaw');
    final personalData = {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phone,
      'dateOfBirth': _date != null ? _dateFormat.format(_date!) : null,
      'medicareNum': medicareController.text.trim(),
      'medicareReferralNumber': medicareIRNController.text.trim(),
      'sex': _sex,
    };
    await onSave(personalData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(30),
              CustomTextField(
                title: "First Name",
                controller: firstNameController,
              ),
              const Gap(20),
              CustomTextField(
                title: "Last Name",
                controller: lastNameController,
                keyboardType: TextInputType.text,
              ),
              const Gap(20),
              CustomTextField(
                title: "Email Address",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              const Gap(20),
              CustomTextField(
                title: "Phone",
                controller: phoneController,
                keyboardType: TextInputType.phone,
                prefixText: "+61 ",
              ),
              const Gap(20),
              CustomTextField(
                title: "Date of Birth",
                controller: dodController,
                readOnly: true,
                onTap: _handleDatePicker,
              ),
              const Gap(20),
              CustomTextField(
                title: "Medicare Card number",
                controller: medicareController,
                maxLength: 10,
              ),
              const Gap(20),
              CustomTextField(
                title: "Individual Reference Number (IRN)",
                controller: medicareIRNController,
              ),
          
              const Gap(30),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomButtom(
                  title: "Save Changes",
                  onTap: _onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
