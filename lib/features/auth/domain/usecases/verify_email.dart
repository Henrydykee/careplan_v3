import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/auth_repository.dart';

class VerifyEmail implements UseCase<String, VerifyEmailParams> {
  final AuthenticationRepository _repo;

  VerifyEmail(this._repo);

  @override
  Future<Either<UIError, String>> call([VerifyEmailParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.verifyEmail(email: params!.email, verificationCode: params.verificationCode, verificationType: params.verificationType);
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

class VerifyEmailParams {
  final String email;
  final String verificationType;
  final String verificationCode;

  VerifyEmailParams({
    required this.email,
    required this.verificationCode,
    this.verificationType = "registration",
  });
}
