import 'package:careplan/features/auth/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/login_user.dart';

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

  // Future register(CreateUserModel user) async {
  //   _setState(
  //     loading: true,
  //     hasError: false,
  //   );
  //   notifyListeners();
  //   Either<UIError, String>? response = await useCases.createUser(user);
  //   response.fold((l) {
  //     _setState(loading: false, hasError: true, errorMsg: l.message, payload: null);
  //     notifyListeners();
  //   }, (r) {
  //     _setState(loading: false, hasError: false, payload: r.toString());
  //     notifyListeners();
  //   });
  // }

  Future login(LoginParams params) async {
    _setState(
      loading: true,
      hasError: false,
    );
    notifyListeners();
    Either<UIError, UserModel>? response = await useCases.loginUser(params);
    notifyListeners();
    response.fold((l) {
      _setState(
          loading: false, hasError: true, errorMsg: l.message, payload: null);
    }, (r) {
      _setState(loading: false, hasError: false, payload: r.toString());
      notifyListeners();
    });
  }
}
