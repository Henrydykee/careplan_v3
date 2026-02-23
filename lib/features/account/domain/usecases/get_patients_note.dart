import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/account_repository.dart';

class GetPatientsNote implements UseCase<String, NoParams> {
  final AccountRepository _repo;

  GetPatientsNote(this._repo);

  @override
  Future<Either<UIError, String>> call([NoParams? params]) async {
    try {
      final result = await _repo.getPatientsNote();
      return Right(result);
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
