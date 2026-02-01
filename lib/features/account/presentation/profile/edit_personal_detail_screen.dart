import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EditPersonalProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const EditPersonalProfileScreen({super.key, this.userData});

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

  DateTime? _date;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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
    phoneController =
        TextEditingController(text: d['phone'] ?? '412345678');
    dodController =
        TextEditingController(text: d['dateOfBirth'] ?? '1990-01-15');
    medicareController =
        TextEditingController(text: d['medicareNum'] ?? '');
    medicareIRNController =
        TextEditingController(text: d['medicareReferralNumber'] ?? '1');
    try {
      _date = _dateFormat.parse(d['dateOfBirth']?.toString() ?? '1990-01-15');
    } catch (_) {
      _date = DateTime(1990, 1, 15);
    }
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
        dodController.text = _dateFormat.format(date);
      });
    }
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );
    router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
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
