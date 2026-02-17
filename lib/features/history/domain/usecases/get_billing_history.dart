import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/billing_history_response_model.dart';
import '../repositories/history_repository.dart';

class GetBillingHistory implements UseCase<BillingHistoryResponseModel, GetBillingHistoryParams> {
  final HistoryRepository _repository;

  GetBillingHistory(this._repository);

  @override
  Future<Either<UIError, BillingHistoryResponseModel>> call([GetBillingHistoryParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.getBillingHistory(
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

class GetBillingHistoryParams {
  final String patientId;
  final int page;
  final int limit;

  GetBillingHistoryParams({
    required this.patientId,
    this.page = 1,
    this.limit = 15,
  });
}
