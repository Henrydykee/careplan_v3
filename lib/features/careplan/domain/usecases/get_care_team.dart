import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/care_team_response_model.dart';
import '../repositories/careplan_repository.dart';

class GetCareTeam implements UseCase<CareTeamResponseModel, GetCareTeamParams> {
  final CarePlanRepository _repository;

  GetCareTeam(this._repository);

  @override
  Future<Either<UIError, CareTeamResponseModel>> call(
      [GetCareTeamParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.getCareTeam(
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

class GetCareTeamParams {
  final String patientId;
  final int page;
  final int limit;

  GetCareTeamParams({
    required this.patientId,
    this.page = 1,
    this.limit = 10,
  });
}
