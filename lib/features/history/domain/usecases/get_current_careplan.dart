import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/care_plan_history_item_model.dart';
import '../repositories/history_repository.dart';

class GetCurrentCarePlan
    implements UseCase<CarePlanHistoryItemModel?, GetCurrentCarePlanParams> {
  final HistoryRepository _repository;

  GetCurrentCarePlan(this._repository);

  @override
  Future<Either<UIError, CarePlanHistoryItemModel?>> call(
      [GetCurrentCarePlanParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.getCurrentCarePlan(
        patientId: params!.patientId,
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

class GetCurrentCarePlanParams {
  final String patientId;

  GetCurrentCarePlanParams({
    required this.patientId,
  });
}

