import '../../../../core/utils/data/guarded_datasource_calls.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/user_remote_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  final UserRemoteDataSource _remoteDataSource;

  AccountRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> sendFcmToken({required String fcm}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.sendFcmToken(fcm: fcm),
      source: 'sendFcmToken',
      showNetworkError: true,
    );
  }

  @override
  Future<String> registerKyc({required Map<String, dynamic> kycData}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.registerKyc(kycData: kycData),
      source: 'registerKyc',
      showNetworkError: true,
    );
  }

  @override
  Future<String> updateUserDetails({required Map<String, dynamic> body}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.updateUserDetails(body: body),
      source: 'updateUserDetails',
      showNetworkError: true,
    );
  }

  @override
  Future<String> updateUserNumber({required String number}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.updateUserNumber(number: number),
      source: 'updateUserNumber',
      showNetworkError: true,
    );
  }

  @override
  Future<String> verifyUpdateUserNumber({required String otp}) async {
    return guardedApiCall<String>(
      () => _remoteDataSource.verifyUpdateUserNumber(otp: otp),
      source: 'verifyUpdateUserNumber',
      showNetworkError: true,
    );
  }

  @override
  Future<String> getPatientsNote() async {
    return guardedApiCall<String>(
      () => _remoteDataSource.getPatientsNote(),
      source: 'getPatientsNote',
      showNetworkError: true,
    );
  }
}
