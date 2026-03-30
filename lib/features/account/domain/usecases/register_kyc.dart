import 'package:dartz/dartz.dart';

import '../../../../core/data/database/db_exceptions.dart';
import '../../../../core/presentation/domain/ui_exceptions.dart';
import '../../../../core/presentation/domain/usercase_typedefs.dart';
import '../../../../core/utils/error_helpers.dart';
import '../repositories/account_repository.dart';

class RegisterKyc implements UseCase<String, RegisterKycParams> {
  final AccountRepository _repo;
  RegisterKyc(this._repo);

  @override
  Future<Either<UIError, String>> call([RegisterKycParams? params]) async {
    UseCase.assertParamsRequired(params);
    try {
      final message = await _repo.registerKyc(kycData: params!.toJson());
      return Right(message);
    } on NetworkFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } on CacheFailure catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure(e.message, e, s));
    } catch (e, s) {
      return Left(getUIErrorFromUsecaseFailure('An unexpected error occurred', e, s));
    }
  }
}

class RegisterKycParams {
  final String firstName;
  final String lastName;
  final String sex;
  final String street;
  final String postalCode;
  final String city;
  final String state;
  final String country;
  final String dateOfBirth;
  final String medicareNum;
  final String medicareReferralNumber;

  RegisterKycParams({
    required this.firstName,
    required this.lastName,
    required this.sex,
    required this.street,
    required this.postalCode,
    required this.city,
    required this.state,
    required this.country,
    required this.dateOfBirth,
    required this.medicareNum,
    required this.medicareReferralNumber,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'sex': sex,
        'street': street,
        'postalCode': postalCode,
        'city': city,
        'state': state,
        'country': country,
        'dateOfBirth': dateOfBirth,
        'medicareNum': medicareNum,
        'medicareReferralNumber': medicareReferralNumber,
      };
}
