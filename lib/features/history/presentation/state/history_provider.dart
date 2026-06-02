import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../data/models/billing_history_item_model.dart';
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

  /// Accumulated billing items across all loaded pages.
  List<BillingHistoryItemModel> get billingItems =>
      List.unmodifiable(_billingItems);

  /// Whether another page of billing history is available to load.
  bool get billingHasNextPage => _billingHasNextPage;

  /// Whether a "load more" (next page) request is currently in flight.
  bool get isLoadingMoreBilling => _isLoadingMoreBilling;

  final List<BillingHistoryItemModel> _billingItems = [];
  int _billingPage = 1;
  bool _billingHasNextPage = false;
  bool _isLoadingMoreBilling = false;

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

  /// Loads the first page of billing history, replacing any previously
  /// accumulated items. Use [loadMoreBilling] to append subsequent pages.
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
      _billingPage = page;
      _billingHasNextPage = r.hasNextPage;
      _billingItems
        ..clear()
        ..addAll(r.history);
      _setState(
        loading: false,
        isReady: true,
        hasError: false,
        payload: r,
        billingHistoryPayload: r,
      );
    });
  }

  /// Appends the next page of billing history to [billingItems]. No-op when a
  /// load is already in flight or no further pages are available.
  Future<void> loadMoreBilling({
    required String patientId,
    int limit = 15,
  }) async {
    if (_isLoadingMoreBilling || !_billingHasNextPage) return;

    _isLoadingMoreBilling = true;
    notifyListeners();

    final nextPage = _billingPage + 1;
    Either<UIError, BillingHistoryResponseModel>? response =
        await useCases.getBillingHistory(
      GetBillingHistoryParams(
        patientId: patientId,
        page: nextPage,
        limit: limit,
      ),
    );

    response.fold((l) {
      _isLoadingMoreBilling = false;
      notifyListeners();
    }, (r) {
      _billingPage = nextPage;
      _billingHasNextPage = r.hasNextPage;
      _billingItems.addAll(r.history);
      _billingHistoryPayload = r;
      _isLoadingMoreBilling = false;
      notifyListeners();
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
