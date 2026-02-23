import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/card_model.dart';
import '../repositories/card_repository.dart';

class GetCards implements UseCase<List<CardModel>, NoParams> {
  final CardRepository _repository;

  GetCards(this._repository);

  @override
  Future<Either<UIError, List<CardModel>>> call([NoParams? params]) async {
    try {
      final response = await _repository.getCards();
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
