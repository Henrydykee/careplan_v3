import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories /auth_repository.dart';

class VerifyBvn implements UseCase<String, String> {
  final AuthenticationRepository _repo;

  VerifyBvn(this._repo);

  @override
  Future<Either<UIError, String>> call([String? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.verifyBvn(bvnNumber: params!);
      return Right(user);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}
