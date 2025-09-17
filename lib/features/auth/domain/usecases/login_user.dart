import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/model/login_response_model.dart';
import '../repositories /auth_repository.dart';

class LoginUser implements UseCase<LoginResponseModel, LoginParams> {
  final AuthenticationRepository _repo;

  LoginUser(this._repo);

  @override
  Future<Either<UIError, LoginResponseModel>> call([LoginParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.loginUser(email: params!.email, password: params.password);
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

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
