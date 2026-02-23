import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories /auth_repository.dart';

class SetPassword implements UseCase<String, SetPasswordParams> {
  final AuthenticationRepository _repo;

  SetPassword(this._repo);

  @override
  Future<Either<UIError, String>> call([SetPasswordParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final message = await _repo.setPassword(newPassword: params!.newPassword);
      return Right(message);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}

class SetPasswordParams {
  final String newPassword;

  SetPasswordParams({required this.newPassword});
}
