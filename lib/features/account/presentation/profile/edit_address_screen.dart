// ignore_for_file: must_be_immutable
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/state_selector_screen.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Mock address data for edit address screen.
class MockAddress {
  static const String street = "123 Main Street";
  static const String postalCode = "2000";
  static const String city = "Sydney";
  static const String state = "NSW";
  static const String country = "Australia";
}

class EditAddressScreen extends StatefulWidget {
  /// Optional; when null, mock data is used.
  final Map<String, dynamic>? addressData;

  const EditAddressScreen({super.key, this.addressData});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController streetController;
  late TextEditingController postalCodeController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late TextEditingController stateController;

  @override
  void initState() {
    super.initState();
    final data = widget.addressData;
    streetController = TextEditingController(text: data?['street'] ?? MockAddress.street);
    postalCodeController = TextEditingController(text: data?['postalCode'] ?? MockAddress.postalCode);
    cityController = TextEditingController(text: data?['city'] ?? MockAddress.city);
    countryController = TextEditingController(text: data?['country'] ?? MockAddress.country);
    stateController = TextEditingController(text: data?['state'] ?? MockAddress.state);
  }

  @override
  void dispose() {
    streetController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    countryController.dispose();
    stateController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address updated")),
    );
    router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackIcon: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(30),
              CustomTextField(
                title: "Street",
                controller: streetController,
                keyboardType: TextInputType.streetAddress,
              ),
              const Gap(20),
              CustomTextField(
                title: "Postal Code",
                keyboardType: TextInputType.number,
                controller: postalCodeController,
              ),
              const Gap(20),
              CustomTextField(
                title: "City",
                controller: cityController,
                keyboardType: TextInputType.text,
              ),
              const Gap(20),
              CustomTextField(
                title: "State",
                controller: stateController,
                keyboardType: TextInputType.text,
                readOnly: true,
                onTap: () async {
                  final state = await router.push<String>(StateSelectorScreen());
                  if (state != null && state.isNotEmpty) {
                    setState(() => stateController.text = state);
                  }
                },
              ),
              const Gap(20),
              CustomTextField(
                title: "Country",
                controller: countryController,
                readOnly: true,
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
