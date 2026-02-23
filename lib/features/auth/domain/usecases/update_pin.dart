import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories /auth_repository.dart';

class UpdatePin implements UseCase<String, UpdatePinParams> {
  final AuthenticationRepository _repo;

  UpdatePin(this._repo);

  @override
  Future<Either<UIError, String>> call([UpdatePinParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final message = await _repo.updatePin(
        oldPin: params!.oldPin,
        newPin: params.newPin,
      );
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

class UpdatePinParams {
  final String oldPin;
  final String newPin;

  UpdatePinParams({required this.oldPin, required this.newPin});
}
