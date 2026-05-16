// ignore_for_file: deprecated_member_use
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  late List<String> years;
  late String selectedMonth;
  late String selectedYear;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _cardNumberController;
  late TextEditingController _securityCodeController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _nameController = TextEditingController();
    _securityCodeController = TextEditingController();
    int currentYear = DateTime.now().year;
    years = List.generate(16, (index) => (currentYear + index).toString());
    selectedMonth = months[DateTime.now().month - 1];
    selectedYear = currentYear.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card added successfully")),
    );
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(showBackIcon: true),
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
                      Center(
                        child: TextHolder(
                          title: "New card",
                          size: 20,
                          fontWeight: FontWeight.w900,
                          color: CarePlanColor.grey,
                        ),
                      ),
                      CustomTextField(
                        title: "Name on Card",
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Name is required" : null,
                      ),
                      const Gap(10),
                      CustomTextField(
                        title: "Card number",
                        controller: _cardNumberController,
                        maxLength: 19,
                        validator: (value) => value == null || value.isEmpty
                            ? "Card number is required"
                            : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _CardNumberFormatter()
                        ],
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextHolder(title: "Expiration date"),
                          TextHolder(title: "CVV"),
                        ],
                      ),
                      Row(
                        children: [
                          _buildDropdown(
                            months,
                            selectedMonth,
                            (value) => setState(() => selectedMonth = value!),
                          ),
                          const Gap(5),
                          _buildDropdown(
                            years,
                            selectedYear,
                            (value) => setState(() => selectedYear = value!),
                          ),
                          const Gap(30),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomTextField(
                                showTittle: false,
                                controller: _securityCodeController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? "CVV is required"
                                        : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomButtom(
                  title: 'Save',
                  onTap: _onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String selectedValue,
    void Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: CarePlanColor.grey.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0.5),
        child: DropdownButton<String>(
          value: selectedValue,
          underline: const SizedBox(),
          items: items
              .map((String item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
