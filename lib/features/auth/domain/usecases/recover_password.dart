import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/auth_repository.dart';

class RecoverPassword implements UseCase<String, RecoverPasswordParams> {
  final AuthenticationRepository _repo;

  RecoverPassword(this._repo);

  @override
  Future<Either<UIError, String>> call([RecoverPasswordParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final result = await _repo.recoverPassword(
        email: params!.email,
        otp: params.otp,
        newPassword: params.newPassword,
      );
      return Right(result);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}

class RecoverPasswordParams {
  final String email;
  final String otp;
  final String newPassword;

  RecoverPasswordParams({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}
