import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/managers/local_storage_service.dart';
import 'package:careplan/core/platform/storage/secured_storage.dart';
import 'package:careplan/core/platform/string_constants.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/key_pad.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/pin_code_field.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/features/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../domain/usecases/set_pin.dart';

class ConfrimPinScreen extends StatefulWidget {
  final String? pin;

  const ConfrimPinScreen({Key? key, this.pin}) : super(key: key);

  @override
  _ConfrimPinScreenState createState() => _ConfrimPinScreenState();
}

class _ConfrimPinScreenState extends State<ConfrimPinScreen> {
  TextEditingController? _pinCodeController;
  bool _isProcessing = false;

  @override
  void initState() {
    _pinCodeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isProcessing,
      view: Scaffold(
        appBar: CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: "Confirm your 4-digit pin",
                    size: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  TextHolder(
                    title: "Please confirm your pin.",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    align: TextAlign.center,
                    color: CarePlanColor.grey,
                  ),
                ],
              ),
              newprojectPinCode(
                controller: _pinCodeController,
                onCompleted: _onCompleted,
              ),
              Column(
                children: [
                  CarePlanKeyPad(onKeyPress: _valueEntered),
                  SizedBox(
                    height: 20,
                  ),
                  Gap(30),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _valueEntered(String s) {
    if (s.toLowerCase() == 'clear') {
      _pinCodeController!.text = '';
      return;
    }
    if (s.toLowerCase() == 'backspace') {
      final currentText = _pinCodeController!.text;
      if (currentText.isEmpty) return;
      if (currentText.length == 1) _pinCodeController!.text = '';
      _pinCodeController!.text =
          currentText.substring(0, currentText.length - 1);
      return;
    }
    if (_pinCodeController?.text.length != 4) {
      _pinCodeController!.text += s;
    }
  }

  Future<void> _onCompleted(String code) async {
    if (_isProcessing) return;
    if (widget.pin == null || code != widget.pin) {
      showErrorDialog(
        context,
        "PIN Mismatch",
        "PINs do not match. Please try again.",
      );
      _pinCodeController!.clear();
      setState(() {});
      return;
    }

    setState(() => _isProcessing = true);
    final result = await inject<SetPin>().call(SetPinParams(pin: code));
    if (!mounted) return;
    setState(() => _isProcessing = false);

    result.fold(
      (error) => showErrorDialog(context, "Set PIN Error", error.message),
      (_) async {
        // Mark user as having a PIN and store the PIN securely for login-pin flow
        final localStorage = inject<LocalStorageService>();
        final userJson = localStorage.getJson('user') ?? {};
        userJson['isPinSet'] = true;
        await localStorage.setJson('user', userJson);
        await inject<SecuredStorage>()
            .add(key: SecureStorageStrings.PASSWORD_TOKEN, value: code);

        router.pushAndRemoveUntil(const CarePlanNavBar(), (route) => false);
      },
    );
  }
}
