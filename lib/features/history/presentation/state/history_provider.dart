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
    notifyListeners();
    Either<UIError, BillingHistoryResponseModel>? response = await useCases.getBillingHistory(
      GetBillingHistoryParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );
    notifyListeners();
    if (response != null) {
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
    } else {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: 'Failed to fetch billing history. Please try again.',
        payload: null,
        billingHistoryPayload: null,
      );
    }
  }

  Future<void> fetchNotesHistory({
    required String patientId,
    int page = 1,
    int limit = 10,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    notifyListeners();
    Either<UIError, NotesHistoryResponseModel>? response = await useCases.getNotesHistory(
      GetNotesHistoryParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );
    notifyListeners();
    if (response != null) {
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
    } else {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: 'Failed to fetch notes history. Please try again.',
        payload: null,
        notesHistoryPayload: null,
      );
    }
  }

  Future<void> fetchSessionHistory({
    required String patientId,
    int page = 1,
    int limit = 10,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    notifyListeners();
    Either<UIError, SessionHistoryResponseModel>? response =
        await useCases.getSessionHistory(
      GetSessionHistoryParams(
        patientId: patientId,
        page: page,
        limit: limit,
      ),
    );
    notifyListeners();
    if (response != null) {
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
    } else {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: 'Failed to fetch care plan history. Please try again.',
        payload: null,
        sessionHistoryPayload: null,
      );
    }
  }

  Future<void> fetchCurrentCarePlan({
    required String patientId,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    notifyListeners();
    Either<UIError, CarePlanHistoryItemModel?>? response =
        await useCases.getCurrentCarePlan(
      GetCurrentCarePlanParams(
        patientId: patientId,
      ),
    );
    notifyListeners();
    if (response != null) {
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
    } else {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: 'Failed to fetch current care plan. Please try again.',
        payload: null,
        currentCarePlanPayload: null,
      );
    }
  }
}
