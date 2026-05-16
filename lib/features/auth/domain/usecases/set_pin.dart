import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/auth_repository.dart';

class SetPin implements UseCase<String, SetPinParams> {
  final AuthenticationRepository _repo;

  SetPin(this._repo);

  @override
  Future<Either<UIError, String>> call([SetPinParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final message = await _repo.setPin(pin: params!.pin);
      return Right(message);
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

class SetPinParams {
  final String pin;

  SetPinParams({required this.pin});
}
