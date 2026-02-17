import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/upcoming_appointments_response_model.dart';
import '../repositories/appointment_repository.dart';

class GetUpcomingAppointments implements UseCase<UpcomingAppointmentsResponseModel, GetUpcomingAppointmentsParams> {
  final AppointmentRepository _repository;

  GetUpcomingAppointments(this._repository);

  @override
  Future<Either<UIError, UpcomingAppointmentsResponseModel>> call([GetUpcomingAppointmentsParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.getUpcomingAppointments(
        patientId: params!.patientId,
        page: params.page,
        limit: params.limit,
      );
      return Right(response);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}

class GetUpcomingAppointmentsParams {
  final String patientId;
  final int page;
  final int limit;

  GetUpcomingAppointmentsParams({
    required this.patientId,
    this.page = 1,
    this.limit = 20,
  });
}
