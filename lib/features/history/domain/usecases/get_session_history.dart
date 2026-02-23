import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/session_history_response_model.dart';
import '../repositories/history_repository.dart';

class GetSessionHistory
    implements UseCase<SessionHistoryResponseModel, GetSessionHistoryParams> {
  final HistoryRepository _repository;

  GetSessionHistory(this._repository);

  @override
  Future<Either<UIError, SessionHistoryResponseModel>> call(
      [GetSessionHistoryParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.getSessionHistory(
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
      return Left(
          getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}

class GetSessionHistoryParams {
  final String patientId;
  final int page;
  final int limit;

  GetSessionHistoryParams({
    required this.patientId,
    this.page = 1,
    this.limit = 10,
  });
}
