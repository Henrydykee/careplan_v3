import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/care_team_response_model.dart';
import '../../domain/usecases/careplan_usecases.dart';
import '../../domain/usecases/get_care_team.dart';

class CarePlanProvider with ChangeNotifier, ProviderState {
  final CarePlanUseCases useCases;

  CarePlanProvider(this.useCases);

  List<CarePlanTeamMember> get careTeam => _careTeam;
  List<CarePlanTeamMember> _careTeam = const [];

  void _setState({
    loading = false,
    isReady = false,
    hasError = false,
    errorMsg = '',
    payload,
    List<CarePlanTeamMember>? careTeamPayload,
  }) {
    update(
      loading: loading,
      hasErr: hasError,
      errorMsg: errorMsg,
      ready: isReady,
      statePayload: payload,
    );
    if (careTeamPayload != null) {
      _careTeam = careTeamPayload;
    }
    notifyListeners();
  }

  Future<void> fetchCareTeam({
    required String patientId,
    int page = 1,
    int limit = 10,
  }) async {
    _setState(loading: true, hasError: false);

    Either<UIError, CareTeamResponseModel> response =
        await useCases.getCareTeam(
      GetCareTeamParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );

    response.fold(
      (l) => _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: l.message,
      ),
      (r) => _setState(
        loading: false,
        isReady: true,
        hasError: false,
        payload: r,
        careTeamPayload: r.careTeam,
      ),
    );
  }
}
