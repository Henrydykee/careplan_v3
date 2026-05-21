// ignore_for_file: deprecated_member_use
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/card/presentation/state/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

enum CardBrand { visa, mastercard, amex, discover, unknown }

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  late final List<String> _months;
  late final List<String> _years;
  late String _selectedMonth;
  late String _selectedYear;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _securityCodeController = TextEditingController();

  CardBrand _brand = CardBrand.unknown;
  int _cvvLength = 3;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _months =
        List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
    _years = List.generate(16, (i) => (now.year + i).toString());
    _selectedMonth = now.month.toString().padLeft(2, '0');
    _selectedYear = now.year.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  CardBrand _detectBrand(String digits) {
    if (digits.isEmpty) return CardBrand.unknown;
    if (digits.startsWith('4')) return CardBrand.visa;
    if (RegExp(r'^3[47]').hasMatch(digits)) return CardBrand.amex;
    if (RegExp(r'^5[1-5]').hasMatch(digits)) return CardBrand.mastercard;
    if (RegExp(r'^6(?:011|5)').hasMatch(digits)) return CardBrand.discover;
    return CardBrand.unknown;
  }

  String _brandLabel(CardBrand brand) {
    switch (brand) {
      case CardBrand.visa:
        return 'VISA';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.amex:
        return 'Amex';
      case CardBrand.discover:
        return 'Discover';
      case CardBrand.unknown:
        return '';
    }
  }

  void _onCardNumberChanged(String value) {
    final brand = _detectBrand(value.replaceAll(' ', ''));
    if (brand != _brand) {
      setState(() {
        _brand = brand;
        _cvvLength = brand == CardBrand.amex ? 4 : 3;
      });
    }
  }

  /// Validates a card number against the Luhn checksum algorithm.
  bool _passesLuhn(String digits) {
    int sum = 0;
    bool alternate = false;
    for (int i = digits.length - 1; i >= 0; i--) {
      int d = int.parse(digits[i]);
      if (alternate) {
        d *= 2;
        if (d > 9) d -= 9;
      }
      sum += d;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  String? _validateName(String? value) =>
      (value == null || value.trim().isEmpty) ? "Name is required" : null;

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(' ', '');
    if (digits.isEmpty) return "Card number is required";
    if (digits.length < 13 || digits.length > 19 || !_passesLuhn(digits)) {
      return "Enter a valid card number";
    }
    return null;
  }

  String? _validateCvv(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "CVV is required";
    if (v.length != _cvvLength) return "CVV must be $_cvvLength digits";
    return null;
  }

  bool _isExpiryInPast() {
    final now = DateTime.now();
    final month = int.parse(_selectedMonth);
    final year = int.parse(_selectedYear);
    return year < now.year || (year == now.year && month < now.month);
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isExpiryInPast()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Card expiration date can't be in the past"),
        ),
      );
      return;
    }

    final provider = context.read<CardProvider>();
    setState(() => _isSaving = true);
    final success = await provider.addCard(
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      expiryMonth: _selectedMonth,
      expiryYear: _selectedYear,
      cvc: _securityCodeController.text.trim(),
      cardholderName: _nameController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card added successfully")),
      );
      router.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : "Failed to add card",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isSaving,
      view: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(showBackIcon: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: TextHolder(
                            title: "New card",
                            size: 20,
                            fontWeight: FontWeight.w900,
                            color: CarePlanColor.grey,
                          ),
                        ),
                        const Gap(10),
                        CustomTextField(
                          title: "Name on Card",
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          validator: _validateName,
                        ),
                        const Gap(10),
                        CustomTextField(
                          title: "Card number",
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          onchanged: _onCardNumberChanged,
                          validator: _validateCardNumber,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(19),
                            _CardNumberFormatter(),
                          ],
                          suffix: _brand == CardBrand.unknown
                              ? null
                              : TextHolder(
                                  title: _brandLabel(_brand),
                                  size: 13,
                                  fontWeight: FontWeight.w700,
                                  color: CarePlanColor.grey,
                                ),
                        ),
                        const Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextHolder(title: "Expiration date"),
                                  const Gap(4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDropdown(
                                          _months,
                                          _selectedMonth,
                                          (v) => setState(
                                              () => _selectedMonth = v!),
                                        ),
                                      ),
                                      const Gap(8),
                                      Expanded(
                                        child: _buildDropdown(
                                          _years,
                                          _selectedYear,
                                          (v) => setState(
                                              () => _selectedYear = v!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextHolder(title: "CVV"),
                                  const Gap(4),
                                  CustomTextField(
                                    showTittle: false,
                                    controller: _securityCodeController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          _cvvLength),
                                    ],
                                    validator: _validateCvv,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 10),
                  child: CustomButtom(
                    title: _isSaving ? 'Saving...' : 'Save',
                    isdisabled: _isSaving,
                    onTap: _onSave,
                  ),
                ),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
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
