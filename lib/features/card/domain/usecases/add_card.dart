import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/card_repository.dart';

class AddCard implements UseCase<String, AddCardParams> {
  final CardRepository _repository;

  AddCard(this._repository);

  @override
  Future<Either<UIError, String>> call([AddCardParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final response = await _repository.addCard(
        cardNumber: params!.cardNumber,
        expiryMonth: params.expiryMonth,
        expiryYear: params.expiryYear,
        cvc: params.cvc,
        cardholderName: params.cardholderName,
      );
      return Right(response);
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

class AddCardParams {
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvc;
  final String cardholderName;

  AddCardParams({
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvc,
    required this.cardholderName,
  });
}
