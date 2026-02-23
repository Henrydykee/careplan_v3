import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/card_repository.dart';

class MarkDefaultCard
    implements UseCase<String, MarkDefaultCardParams> {
  final CardRepository _repository;

  MarkDefaultCard(this._repository);

  @override
  Future<Either<UIError, String>> call(
      [MarkDefaultCardParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.markDefaultCard(
        cardId: params!.cardId,
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

class MarkDefaultCardParams {
  final String cardId;

  MarkDefaultCardParams({required this.cardId});
}
