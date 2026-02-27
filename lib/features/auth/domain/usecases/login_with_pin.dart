import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/model/user_model.dart';
import '../repositories /auth_repository.dart';

class LoginWithPin implements UseCase<UserModel, LoginWithPinParams> {
  final AuthenticationRepository _repo;

  LoginWithPin(this._repo);

  @override
  Future<Either<UIError, UserModel>> call([LoginWithPinParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.loginWithPin(
        email: params!.email,
        pin: params.pin,
      );
      return Right(user);
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

class LoginWithPinParams {
  final String email;
  final String pin;

  LoginWithPinParams({required this.email, required this.pin});
}
