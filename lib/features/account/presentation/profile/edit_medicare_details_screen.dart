import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditMedicareDetailsScreen extends StatefulWidget {
  const EditMedicareDetailsScreen({super.key});

  @override
  State<EditMedicareDetailsScreen> createState() =>
      _EditMedicareDetailsScreenState();
}

class _EditMedicareDetailsScreenState extends State<EditMedicareDetailsScreen> {
  late TextEditingController medicareIdController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController middleNameController;
  late TextEditingController sexController;

  @override
  void initState() {
    super.initState();
    medicareIdController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    middleNameController = TextEditingController();
    sexController = TextEditingController();
  }

  @override
  void dispose() {
    medicareIdController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    sexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Gap(30),
            CustomTextField(
              title: "Medicare ID",
              controller: medicareIdController,
            ),
            const Gap(20),
            CustomTextField(
              title: "First Name on Medicare Card",
              controller: firstNameController,
            ),
            const Gap(20),
            CustomTextField(
              title: "Middle Name (Optional)",
              controller: middleNameController,
            ),
            const Gap(20),
            CustomTextField(
              title: "Last Name on Medicare Card",
              controller: lastNameController,
            ),
            const Gap(20),
            CustomTextField(
              title: "Sex at Birth",
              controller: sexController,
            ),
          ],
        ),
      ),
    );
  }
}
