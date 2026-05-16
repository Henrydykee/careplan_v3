




import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationCode implements UseCase<String, ResendVerificationCodeParams> {
  final AuthenticationRepository _repo;

  ResendVerificationCode(this._repo);

  @override
  Future<Either<UIError, String>> call([ResendVerificationCodeParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.resendVerificationCode(email: params!.email, verificationType: params.verificationType);
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

class ResendVerificationCodeParams {
  final String email;
  final String verificationType;

  ResendVerificationCodeParams({
    required this.email,
     this.verificationType = "registration",
  });
}