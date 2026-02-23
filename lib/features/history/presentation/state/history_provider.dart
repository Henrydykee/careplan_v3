import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../data/models/billing_history_response_model.dart';
import '../../data/models/notes_history_response_model.dart';
import '../../data/models/session_history_response_model.dart';
import '../../domain/usecases/history_usecases.dart';
import '../../domain/usecases/get_billing_history.dart';
import '../../domain/usecases/get_notes_history.dart';
import '../../domain/usecases/get_session_history.dart';

class HistoryProvider with ChangeNotifier, ProviderState {
  final HistoryUseCases useCases;

  HistoryProvider(this.useCases);

  BillingHistoryResponseModel? get billingHistory => _billingHistoryPayload;
  NotesHistoryResponseModel? get notesHistory => _notesHistoryPayload;
  SessionHistoryResponseModel? get sessionHistory => _sessionHistoryPayload;

  BillingHistoryResponseModel? _billingHistoryPayload;
  NotesHistoryResponseModel? _notesHistoryPayload;
  SessionHistoryResponseModel? _sessionHistoryPayload;

  void _setState({
    loading = false,
    isReady = false,
    hasError = false,
    errorMsg = '',
    payload,
    billingHistoryPayload,
    notesHistoryPayload,
    sessionHistoryPayload,
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
}
