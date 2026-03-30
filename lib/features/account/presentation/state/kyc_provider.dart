import 'package:flutter/foundation.dart';

import '../../../../core/presentation/state/provider_state.dart';
import '../../domain/usecases/account_usecases.dart';
import '../../domain/usecases/register_kyc.dart';

class KycProvider with ChangeNotifier, ProviderState {
  final AccountUseCases useCases;
  KycProvider(this.useCases);

  void _setState({loading = false, isReady = false, hasError = false, errorMsg = '', payload}) {
    update(loading: loading, hasErr: hasError, errorMsg: errorMsg, ready: isReady, statePayload: payload);
    notifyListeners();
  }

  Future<void> registerKyc(RegisterKycParams params) async {
    _setState(loading: true, hasError: false);

    final response = await useCases.registerKyc.call(params);

    response.fold(
      (l) => _setState(loading: false, hasError: true, errorMsg: l.message),
      (r) => _setState(loading: false, isReady: true, payload: r),
    );
  }
}
