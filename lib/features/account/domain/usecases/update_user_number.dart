import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/account_repository.dart';

class UpdateUserNumber implements UseCase<String, UpdateUserNumberParams> {
  final AccountRepository _repo;

  UpdateUserNumber(this._repo);

  @override
  Future<Either<UIError, String>> call([UpdateUserNumberParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final message = await _repo.updateUserNumber(number: params!.number);
      return Right(message);
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

class UpdateUserNumberParams {
  final String number;

  UpdateUserNumberParams({required this.number});
}
