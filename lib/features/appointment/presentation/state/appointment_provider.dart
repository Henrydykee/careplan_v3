import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/state/provider_state.dart';
import '../../data/models/upcoming_appointments_response_model.dart';
import '../../domain/usecases/appointment_usecases.dart';
import '../../domain/usecases/get_upcoming_appointments.dart';

class AppointmentProvider with ChangeNotifier, ProviderState {
  final AppointmentUseCases useCases;

  AppointmentProvider(this.useCases);

  UpcomingAppointmentsResponseModel? get appointments => payload;

  void _setState({
    loading = false,
    isReady = false,
    hasError = false,
    errorMsg = '',
    payload,
  }) {
    update(
      loading: loading,
      hasErr: hasError,
      errorMsg: errorMsg,
      ready: isReady,
      statePayload: payload,
    );
    notifyListeners();
  }

  Future<void> fetchUpcomingAppointments({
    required String patientId,
    int page = 1,
    int limit = 20,
  }) async {
    _setState(
      loading: true,
      hasError: false,
    );
    notifyListeners();
    Either<UIError, UpcomingAppointmentsResponseModel>? response = await useCases.getUpcomingAppointments(
      GetUpcomingAppointmentsParams(
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
        );
      }, (r) {
        _setState(
          loading: false,
          isReady: true,
          hasError: false,
          payload: r,
        );
      });
    } else {
      _setState(
        loading: false,
        isReady: false,
        hasError: true,
        errorMsg: 'Failed to fetch appointments. Please try again.',
        payload: null,
      );
    }
  }
}
