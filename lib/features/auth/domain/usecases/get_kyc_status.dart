


import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../../data/model/kyc_status_model.dart';
import '../repositories /auth_repository.dart';

class GetKycStatus implements UseCase<KycStatusResponse, NoParams> {
  final AuthenticationRepository _repo;

  GetKycStatus(this._repo);

  @override
  Future<Either<UIError, KycStatusResponse>> call([params]) async {
    try {
      final res = await _repo.getKycStatus();
      return Right(res);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}