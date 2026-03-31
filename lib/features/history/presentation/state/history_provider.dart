import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../data/models/billing_history_response_model.dart';
import '../../data/models/care_plan_history_item_model.dart';
import '../../data/models/notes_history_response_model.dart';
import '../../data/models/session_history_response_model.dart';
import '../../domain/usecases/get_billing_history.dart';
import '../../domain/usecases/get_current_careplan.dart';
import '../../domain/usecases/get_notes_history.dart';
import '../../domain/usecases/get_session_history.dart';
import '../../domain/usecases/history_usecases.dart';

class HistoryProvider with ChangeNotifier, ProviderState {
  final HistoryUseCases useCases;

  HistoryProvider(this.useCases);

  BillingHistoryResponseModel? get billingHistory => _billingHistoryPayload;
  NotesHistoryResponseModel? get notesHistory => _notesHistoryPayload;
  SessionHistoryResponseModel? get sessionHistory => _sessionHistoryPayload;
  CarePlanHistoryItemModel? get currentCarePlan => _currentCarePlan;

  BillingHistoryResponseModel? _billingHistoryPayload;
  NotesHistoryResponseModel? _notesHistoryPayload;
  SessionHistoryResponseModel? _sessionHistoryPayload;
  CarePlanHistoryItemModel? _currentCarePlan;

  void _setState({
    loading = false,
    isReady = false,
    hasError = false,
    errorMsg = '',
    payload,
    billingHistoryPayload,
    notesHistoryPayload,
    sessionHistoryPayload,
    currentCarePlanPayload,
  }) {
    update(
      loading: loading,
      hasErr: hasError,
      errorMsg: errorMsg,
      ready: isReady,
      statePayload: payload,
    );
    if (billingHistoryPayload != null) {
      _billingHistoryPayload = billingHistoryPayload;
    }
    if (notesHistoryPayload != null) {
      _notesHistoryPayload = notesHistoryPayload;
    }
    if (sessionHistoryPayload != null) {
      _sessionHistoryPayload = sessionHistoryPayload;
    }
    if (currentCarePlanPayload != null || payload is CarePlanHistoryItemModel?) {
      _currentCarePlan = currentCarePlanPayload ?? payload as CarePlanHistoryItemModel?;
    }
    notifyListeners();
  }

  Future<void> fetchBillingHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    Either<UIError, BillingHistoryResponseModel>? response = await useCases.getBillingHistory(
      GetBillingHistoryParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );
    response.fold((l) {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: l.message,
        payload: null,
        billingHistoryPayload: null,
      );
    }, (r) {
      _setState(
        loading: false,
        isReady: true,
        hasError: false,
        payload: r,
        billingHistoryPayload: r,
      );
    });
  }

  Future<void> fetchNotesHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    Either<UIError, NotesHistoryResponseModel>? response = await useCases.getNotesHistory(
      GetNotesHistoryParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );
    response.fold((l) {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: l.message,
        payload: null,
        notesHistoryPayload: null,
      );
    }, (r) {
      _setState(
        loading: false,
        isReady: true,
        hasError: false,
        payload: r,
        notesHistoryPayload: r,
      );
    });
  }

  Future<void> fetchSessionHistory({
    required String patientId,
    int page = 1,
    int limit = 15,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    Either<UIError, SessionHistoryResponseModel>? response =
        await useCases.getSessionHistory(
      GetSessionHistoryParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );
    response.fold((l) {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: l.message,
        payload: null,
        sessionHistoryPayload: null,
      );
    }, (r) {
      _setState(
        loading: false,
        isReady: true,
        hasError: false,
        payload: r,
        sessionHistoryPayload: r,
      );
    });
  }

  Future<void> fetchCurrentCarePlan({
    required String patientId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _currentCarePlan != null) {
      return;
    }

    _setState(
      loading: true,
      hasError: false,
    );
    Either<UIError, CarePlanHistoryItemModel?> response =
        await useCases.getCurrentCarePlan(
      GetCurrentCarePlanParams(
        patientId: patientId,
      ),
    );
    response.fold((l) {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: l.message,
        payload: null,
        currentCarePlanPayload: null,
      );
    }, (r) {
      _setState(
        loading: false,
        isReady: true,
        hasError: false,
        payload: r,
        currentCarePlanPayload: r,
      );
    });
  }
}
