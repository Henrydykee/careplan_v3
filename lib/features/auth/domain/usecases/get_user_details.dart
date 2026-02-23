import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/model/user_model.dart';
import '../repositories /auth_repository.dart';

class GetUserDetails implements UseCase<UserModel, NoParams> {
  final AuthenticationRepository _repo;

  GetUserDetails(this._repo);

  @override
  Future<Either<UIError, UserModel>> call([NoParams? params]) async {
    try {
      final user = await _repo.getUserDetails();
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
