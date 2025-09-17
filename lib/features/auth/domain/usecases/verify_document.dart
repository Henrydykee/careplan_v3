

import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories /auth_repository.dart';

class VerifyDocument implements UseCase<String, VerifyDocumentParams> {
  final AuthenticationRepository _repo;

  VerifyDocument(this._repo);

  @override
  Future<Either<UIError, String>> call([VerifyDocumentParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final user = await _repo.verifyDocument(idCardType: params!.idCardType, idImage: params.idImage, selfieImage: params.selfieImage);
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

class VerifyDocumentParams {
  final String idCardType;
  final String idImage;
  final String selfieImage;

  VerifyDocumentParams({
    required this.idCardType,
    required this.idImage,
    required this.selfieImage,
  });
}