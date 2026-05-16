import 'package:careplan/features/auth/data/models/create_user_model.dart';
import 'package:careplan/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/recover_password.dart';
import '../../domain/usecases/resend_verification_code.dart';
import '../../domain/usecases/verify_email.dart';

class AuthenticationProvider with ChangeNotifier, ProviderState {
  AuthenticationUseCases useCases;

  AuthenticationProvider(this.useCases) {}

  void _setState(
      {loading = false,
      isReady = false,
      hasError = false,
      errorMsg = '',
      payload,
      requires2fa = false}) {
    update(
        loading: loading,
        hasErr: hasError,
        errorMsg: errorMsg,
        ready: isReady,
        statePayload: payload);
    notifyListeners();
  }

  Future register(CreateUserModel user) async {
    _setState(loading: true, hasError: false);
    Either<UIError, UserModel>? response = await useCases.createUser(user);
    response.fold(
      (l) => _setState(loading: false, hasError: true, errorMsg: l.message),
      (r) => _setState(loading: false, isReady: true, payload: r),
    );
  }

  Future verifyEmail(VerifyEmailParams params) async {
    _setState(loading: true, hasError: false);
    Either<UIError, String>? response = await useCases.verifyEmail(params);
    response.fold(
      (l) => _setState(loading: false, hasError: true, errorMsg: l.message),
      (r) => _setState(loading: false, isReady: true, payload: r),
    );
  }

  Future resendVerificationCode(ResendVerificationCodeParams params) async {
    _setState(loading: true, hasError: false);
    Either<UIError, String>? response = await useCases.resendVerificationCode(params);
    response.fold(
      (l) => _setState(loading: false, hasError: true, errorMsg: l.message),
      (r) => _setState(loading: false, hasError: false, payload: r),
    );
  }

  Future login(LoginParams params) async {
    _setState(
      loading: true,
      hasError: false,
    );
    Either<UIError, UserModel>? response = await useCases.loginUser(params);
    response.fold((l) {
      _setState(
          loading: false, hasError: true, errorMsg: l.message, payload: null);
    }, (r) {
      _setState(loading: false, hasError: false, payload: r.toString());
    });
  }

  Future recoverPassword(RecoverPasswordParams params) async {
    _setState(loading: true, hasError: false);
    Either<UIError, String>? response = await useCases.recoverPassword(params);
    response.fold(
      (l) => _setState(loading: false, hasError: true, errorMsg: l.message),
      (r) => _setState(loading: false, isReady: true, payload: r),
    );
  }
}
