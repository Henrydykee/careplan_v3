import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/models/create_user_model.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class CreateUser implements UseCase<UserModel, CreateUserModel> {
  final AuthenticationRepository _repo;

  CreateUser(this._repo);

  @override
  Future<Either<UIError, UserModel>> call([CreateUserModel? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.CreateUser(params!);
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
